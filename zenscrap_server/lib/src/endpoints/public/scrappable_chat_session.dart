import 'dart:async';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:collection/collection.dart';
import 'package:rxdart/subjects.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/consts.dart';
import 'package:zenscrap_server/src/core/default_classes.dart';
import 'package:zenscrap_server/src/core/ip_validation/ip_validation.dart';
import 'package:zenscrap_server/src/core/translations/error_translations.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/chat_controller_openai_sdk_impl.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/i_chat_controller.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

typedef RedraftSrappableSessionId = String;
typedef ThinkingSessionId = String;

final Map<RedraftSrappableSessionId, ReplaySubject<ChatResponse>>
_scrapRedraftSessions = {};
final Map<ThinkingSessionId, StreamController<String>> _thinkingStream = {};
final Map<RedraftSrappableSessionId, IChatController> _chatSessions = {};
final Map<int, RedraftSrappableSessionId> _scrappableOpenedSessionsIds = {};
final Map<RedraftSrappableSessionId, int> _cacheScrappableIds = {};
final Map<RedraftSrappableSessionId, ReferenceTestData> _cacheRefTestData = {};
final Map<RedraftSrappableSessionId, ScrappingBeeExtractLogic?>
_cacheScrappingBeeExtractLogic = {};
final Map<RedraftSrappableSessionId, ScrappableRequest>
_cacheScrappableRequest = {};

/// Heartbeat timers to prevent infrastructure idle timeout (typically 60s).
/// Many load balancers/proxies close WebSocket connections after ~60s of inactivity.
/// Since AI processing can take 60-180s, we send heartbeats every 20s to keep alive.
final Map<RedraftSrappableSessionId, Timer> _heartbeatTimers = {};

// =============================================================================
// AI Usage Credit Tracking
// =============================================================================

/// Tracks AccountAIUsage for logged-in users per session.
/// This is used to deduct credits after each message and update the DB on session dispose.
final Map<RedraftSrappableSessionId, AccountAIUsage> _sessionAccountAIUsage =
    {};

/// Tracks spending for anonymous sessions (not logged in users).
/// Each session has a spending limit of kAnonymousSessionSpendingLimitInDollars.
final Map<RedraftSrappableSessionId, double> _anonymousSessionSpending = {};

/// Tracks whether the user is using their own API key (no cost to platform).
/// If true, we don't deduct any credits from the user.
final Map<RedraftSrappableSessionId, bool> _sessionUsesOwnApiKey = {};

ScrappingBeeExtractLogic? getTestExtractRules(int scrappableId) {
  return _cacheScrappingBeeExtractLogic[_scrappableOpenedSessionsIds[scrappableId]];
}

ScrappableRequest? getScrappableRequest(int scrappableId) {
  return _cacheScrappableRequest[_scrappableOpenedSessionsIds[scrappableId]];
}

ReferenceTestData? getReferenceTestData(int scrappableId) {
  return _cacheRefTestData[_scrappableOpenedSessionsIds[scrappableId]];
}

void updateTestReferenceData(int scrappableId, ReferenceTestData testData) {
  final sessionId = _scrappableOpenedSessionsIds[scrappableId];
  if (sessionId != null) {
    _cacheRefTestData[sessionId] = testData;
  }
}

/// Sends a chat response to an active chat session for a given scrappable ID
/// Returns true if message was sent, false if no active session exists
bool sendSystemMessageToScrappableSession({
  required int scrappableId,
  required ChatResponse response,
}) {
  final sessionId = _scrappableOpenedSessionsIds[scrappableId];
  if (sessionId == null) {
    return false; // No active session for this scrappable
  }

  final subject = _scrapRedraftSessions[sessionId];
  if (subject == null) {
    return false; // Session exists in map but stream was closed
  }

  // Add the response to the chat
  subject.add(response);

  return true;
}

class ScrappableChatSession extends Endpoint {
  final Uuid uuid = Uuid();

  Future<void> commitCurrentEditState(
    Session session, {
    required RedraftSrappableSessionId sessionUuid,
    required SupportedLanguage language,
  }) async {
    // =========================================================================
    // Check for data in cache first, then fall back to pending commit in DB
    // =========================================================================
    int? scrappableId = _cacheScrappableIds[sessionUuid];
    PendingSessionCommit? pendingCommit;
    bool isFromPendingCommit = false;

    if (scrappableId == null) {
      // Session expired - check for pending commit in database
      pendingCommit = await PendingSessionCommit.db.findFirstRow(
        session,
        where: (t) => t.sessionId.equals(sessionUuid),
      );

      if (pendingCommit == null) {
        throw createTranslatedException('cache_scrappable_id_not_found', language);
      }

      scrappableId = pendingCommit.scrappableId;
      isFromPendingCommit = true;
      session.log(
        'Using pending commit for session $sessionUuid (scrappable $scrappableId)',
      );
    }

    final userId = session.authenticated?.authUserId;

    // For pending commits, the data was already saved to DB in _savePendingSessionData
    // so we don't need to load from cache. For active sessions, get from cache.
    final ReferenceTestData? testData =
        isFromPendingCommit ? null : _cacheRefTestData[sessionUuid];
    final ScrappingBeeExtractLogic? scrappingBeeExtractLogic =
        isFromPendingCommit ? null : _cacheScrappingBeeExtractLogic[sessionUuid];
    final ScrappableRequest? scrappableRequest =
        isFromPendingCommit ? null : _cacheScrappableRequest[sessionUuid];

    // Validate cache data for active sessions
    if (!isFromPendingCommit &&
        (testData == null ||
            testData.byteData == null ||
            scrappingBeeExtractLogic == null ||
            scrappableRequest == null)) {
      throw createTranslatedException('cache_test_data_not_found', language);
    }

    await session.db.transaction((transaction) async {
      try {
        final Scrappable? scrappable;
        if (userId == null) {
          // If not authenticated, should only be able to modify scrappables that are not attached to any account
          scrappable = await Scrappable.db.findFirstRow(
            session,
            where: (t) => t.id.equals(scrappableId) & t.accountId.equals(null),
            transaction: transaction,
          );
        } else {
          final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(
            session,
            where: (p0) => p0.authUserId.equals(userId),
            transaction: transaction,
          );
          final accountId = accountInfo?.id;

          scrappable = await Scrappable.db.findFirstRow(
            session,
            where: (t) =>
                t.id.equals(scrappableId) & t.accountId.equals(accountId),
            transaction: transaction,
          );

          if (scrappable == null) {
            throw defaultAuthenticationException;
          }
        }

        if (scrappable == null) {
          throw createTranslatedException(
            'scrappable_not_found_or_no_access',
            language,
          );
        }

        // Always update the Scrappable's extractRulesUpdatedAt timestamp
        await Scrappable.db.updateRow(
          session,
          scrappable.copyWith(extractRulesUpdatedAt: DateTime.now()),
          transaction: transaction,
        );

        if (isFromPendingCommit) {
          // Data was already saved to DB in _savePendingSessionData
          // Just delete the pending commit record
          await PendingSessionCommit.db.deleteRow(
            session,
            pendingCommit!,
            transaction: transaction,
          );
          session.log(
            'Committed from pending session $sessionUuid, deleted pending record',
          );
        } else {
          // Active session - save all cached data to DB
          await ScrappingBeeExtractLogic.db.updateRow(
            session,
            scrappingBeeExtractLogic!,
            transaction: transaction,
          );
          await ScrappableRequest.db.updateRow(
            session,
            scrappableRequest!,
            transaction: transaction,
          );
          await ByteTestData.db.updateRow(
            session,
            testData!.byteData!,
            transaction: transaction,
          );
          await ReferenceTestData.db.updateRow(
            session,
            testData,
            transaction: transaction,
          );
        }
      } catch (e, s) {
        session.log(
          'Failed to commit changes for session $sessionUuid',
          exception: e,
          stackTrace: s,
          level: LogLevel.error,
        );
        rethrow;
      }
    });
  }

  Future<void> disposeSession(
    Session session, {
    required RedraftSrappableSessionId sessionId,
  }) {
    return _disposeSession(sessionId: sessionId, dbSession: session);
  }

  /// Updates the user's OpenAI API key for the current session.
  ///
  /// This endpoint is called when a user wants to add their own API key
  /// after receiving a [CreditLimitReachedResponse] (platform credits exhausted).
  ///
  /// The API key is:
  /// 1. Stored in the in-memory [_sessionAccountAIUsage] map
  /// 2. Persisted to the database when the session ends
  /// 3. Used for subsequent API calls in this session (no credits deducted)
  ///
  /// Returns success and sends an [ApiKeyUpdatedResponse] to the chat stream.
  Future<void> updateUserApiKey(
    Session session, {
    required RedraftSrappableSessionId sessionId,
    required String openAiApiKey,
    required SupportedLanguage language,
  }) async {
    // Validate session exists
    if (!_scrapRedraftSessions.containsKey(sessionId)) {
      throw createTranslatedException('session_not_found', language);
    }

    // Validate user is authenticated
    final userId = session.authenticated?.authUserId;
    if (userId == null) {
      throw createTranslatedException(
        'authentication_required_api_key',
        language,
      );
    }

    // Validate API key format (basic check)
    if (openAiApiKey.trim().isEmpty) {
      throw createTranslatedException('invalid_api_key', language);
    }

    // Get or create AccountAIUsage for this session
    AccountAIUsage? accountAIUsage = _sessionAccountAIUsage[sessionId];

    if (accountAIUsage == null) {
      // Load from database if not in cache
      final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(
        session,
        where: (p0) => p0.authUserId.equals(userId),
        include: AccountInfo.include(accountAIUsage: AccountAIUsage.include()),
      );

      if (accountInfo == null) {
        throw createTranslatedException('account_not_found', language);
      }

      accountAIUsage = accountInfo.accountAIUsage;
      accountAIUsage ??= await AccountAIUsage.db.findById(
        session,
        accountInfo.accountAIUsageId,
      );

      if (accountAIUsage == null) {
        throw createTranslatedException('ai_usage_record_not_found', language);
      }
    }

    // Update the API key
    accountAIUsage.userOpenAiApiKey = openAiApiKey.trim();
    _sessionAccountAIUsage[sessionId] = accountAIUsage;
    _sessionUsesOwnApiKey[sessionId] = true;

    // Persist to database immediately
    try {
      await AccountAIUsage.db.updateRow(session, accountAIUsage);
      session.log('Updated user API key for session $sessionId (user $userId)');
    } catch (e, s) {
      session.log(
        'Failed to persist API key update',
        exception: e,
        stackTrace: s,
        level: LogLevel.error,
      );
      throw createTranslatedException('failed_to_save_api_key', language);
    }

    // Send success response to chat stream
    _scrapRedraftSessions[sessionId]?.add(
      ApiKeyUpdatedResponse(
        role: PromptRole.system,
        expectsFollowUp: false,
        messageText: getErrorDescription('chat_api_key_configured', language),
      ),
    );
  }

  Future<void> updateScrappableRequest(
    Session session, {
    required int scrappableId,
    required String url,
    required List<String> pathParams,
    required Map<String, String?> queryParams,
    required SupportedLanguage language,
  }) async {
    final sessionId = _scrappableOpenedSessionsIds[scrappableId];
    if (sessionId == null) {
      throw createTranslatedException('session_not_found', language);
    }

    final ScrappableRequest? cachedRequest = _cacheScrappableRequest[sessionId];
    if (cachedRequest == null) {
      throw createTranslatedException('scrappable_request_not_found', language);
    }

    // Update the cached scrappable request
    _cacheScrappableRequest[sessionId] = cachedRequest.copyWith(
      url: url,
      pathParams: pathParams,
      queryParams: queryParams,
    );

    // Send notification to the chat session
    sendSystemMessageToScrappableSession(
      scrappableId: scrappableId,
      response: UpdatedScrappableRequestResponse(
        role: PromptRole.system,
        expectsFollowUp:
            false, // Configuration update notification, no follow-up
        messageText: getErrorDescription(
          'chat_scrappable_request_updated',
          language,
        ),
        url: url,
        pathParams: pathParams,
        queryParams: queryParams,
      ),
    );
  }

  Future<CreateSessionResponse> createSession(
    Session session, {
    required int scrappableId,
    required SupportedLanguage language,
  }) async {
    final userId = session.authenticated?.authUserId;
    final bool isLoggedIn = userId != null;

    // =========================================================================
    // IP Validation for Anonymous Users
    // =========================================================================
    // For anonymous users (not logged in), validate their IP address
    // to detect suspicious connections (VPN, proxy, Tor, datacenter, abusers).
    // Logged-in users bypass this check as they are already authenticated.
    // Skip in development/test mode since localhost IPs are detected as bogon.
    final runMode = session.serverpod.runMode;
    final isNonProductionMode = runMode == ServerpodRunMode.development ||
        runMode == ServerpodRunMode.test;
    if (!isNonProductionMode && !isLoggedIn && session is MethodCallSession) {
      final clientIpAddress = session.request.connectionInfo.remote.address
          .toString();

      // Get the ipapi API key from the password store
      final ipapiApiKey =
          session.passwords['ipapiApiKey'] ??
          session.serverpod.getPassword('ipapiApiKey');

      if (ipapiApiKey != null && ipapiApiKey.isNotEmpty) {
        final ipValidator = IpApiValidationService(
          apiKey: ipapiApiKey,
          onLog: (msg) => session.log(msg),
        );

        final validationResult = await ipValidator.validateIpWithCache(
          session,
          clientIpAddress,
        );

        if (!validationResult.isLegitimate) {
          session.log(
            'Blocked suspicious IP $clientIpAddress: ${validationResult.blockReason}',
            level: LogLevel.warning,
          );

          throw createTranslatedException(
            'suspicious_ip_detected',
            language,
            params: {'reason': validationResult.blockReason ?? 'Unknown'},
          );
        }

        // Log successful validation (for debugging/analytics)
        if (!validationResult.isFallback) {
          session.log(
            'IP $clientIpAddress validated successfully (country: ${validationResult.countryCode})',
          );
        }
      } else {
        session.log(
          'Warning: ipapiApiKey not configured, skipping IP validation',
          level: LogLevel.warning,
        );
      }
    }

    final Scrappable? scrappable = await Scrappable.db.findById(
      session,
      scrappableId,
      include: Scrappable.include(
        targetRequest: ScrappableRequest.include(),
        scrappingBeeExtractRules: ScrappingBeeExtractLogic.include(),
        referenceTestData: ReferenceTestData.include(
          byteData: ByteTestData.include(),
        ),
      ),
    );

    final ReferenceTestData? referenceTestData = scrappable?.referenceTestData;
    final ScrappableRequest? scrapperRequest = scrappable?.targetRequest;
    final ScrappingBeeExtractLogic? scrappingBeeExtractLogic =
        scrappable?.scrappingBeeExtractRules;
    if (scrappable == null) {
      session.log(
        'No scrappable found with id $scrappableId.',
        level: LogLevel.error,
      );
      throw createTranslatedException('scrappable_not_found', language);
    }

    // Variables for AI usage tracking
    AccountAIUsage? accountAIUsage;
    bool usesOwnApiKey = false;

    final doesScrappableHasOwner = scrappable.accountId != null;
    if (doesScrappableHasOwner) {
      final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(
        session,
        where: (p0) => p0.authUserId.equals(userId),
        include: AccountInfo.include(accountAIUsage: AccountAIUsage.include()),
      );
      if (accountInfo == null || accountInfo.id != scrappable.accountId) {
        throw createTranslatedException(
          'authentication_required_session',
          language,
        );
      }

      // Get AI usage for logged-in user
      accountAIUsage = accountInfo.accountAIUsage;
      // Load it separately if not included
      accountAIUsage ??= await AccountAIUsage.db.findById(
        session,
        accountInfo.accountAIUsageId,
      );

      // Check if user has their own API key
      usesOwnApiKey =
          accountAIUsage?.userOpenAiApiKey != null &&
          accountAIUsage!.userOpenAiApiKey!.isNotEmpty;

      // Check if user has credits (only if not using their own API key)
      if (!usesOwnApiKey && accountAIUsage != null) {
        final remainingCredits = accountAIUsage.totalDollarsSpentFromTotalInUSD;
        if (remainingCredits <= 0) {
          throw createTranslatedException(
            'ai_credits_exhausted',
            language,
            params: {
              'limit':
                  '\$${kDefaultMonthlyAICreditsInDollars.toStringAsFixed(2)}',
            },
          );
        }
      }
    } else if (isLoggedIn) {
      // User is logged in but scrappable has no owner - get their AI usage anyway
      final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(
        session,
        where: (p0) => p0.authUserId.equals(userId),
        include: AccountInfo.include(accountAIUsage: AccountAIUsage.include()),
      );

      if (accountInfo != null) {
        accountAIUsage = accountInfo.accountAIUsage;
        accountAIUsage ??= await AccountAIUsage.db.findById(
          session,
          accountInfo.accountAIUsageId,
        );

        usesOwnApiKey =
            accountAIUsage?.userOpenAiApiKey != null &&
            accountAIUsage!.userOpenAiApiKey!.isNotEmpty;

        if (!usesOwnApiKey && accountAIUsage != null) {
          final remainingCredits =
              accountAIUsage.totalDollarsSpentFromTotalInUSD;
          if (remainingCredits <= 0) {
            throw createTranslatedException(
              'ai_credits_exhausted',
              language,
              params: {
                'limit':
                    '\$${kDefaultMonthlyAICreditsInDollars.toStringAsFixed(2)}',
              },
            );
          }
        }
      }
    }
    // For anonymous users (not logged in), we track spending per session

    if (referenceTestData == null) {
      session.log(
        'No reference test data found for scrappable with id ${scrappable.id}.',
        level: LogLevel.error,
      );
      throw createTranslatedException('reference_test_data_not_found', language);
    }
    if (scrapperRequest == null) {
      session.log(
        'No target request found for scrappable with id ${scrappable.id}.',
        level: LogLevel.error,
      );
      throw createTranslatedException('target_request_not_found', language);
    }
    final bool isAlreadyAnyOpenedSession = _scrappableOpenedSessionsIds
        .containsKey(scrappable.id!);
    if (isAlreadyAnyOpenedSession) {
      throw createTranslatedException('session_already_opened', language);
    }

    final RedraftSrappableSessionId sessionUuid = uuid.v4();
    _scrappableOpenedSessionsIds[scrappable.id!] = sessionUuid;
    _scrapRedraftSessions[sessionUuid] = ReplaySubject<ChatResponse>();

    // Determine which OpenAI API key to use
    // Priority: User's own key > Server configured key
    String openAiApiKey;
    if (usesOwnApiKey && accountAIUsage?.userOpenAiApiKey != null) {
      openAiApiKey = accountAIUsage!.userOpenAiApiKey!;
      session.log('Using user\'s own OpenAI API key for session $sessionUuid');
    } else {
      openAiApiKey =
          session.passwords['openAiApiKey'] ??
          session.serverpod.getPassword('openAiApiKey') ??
          '';
      if (openAiApiKey.isEmpty) {
        throw createTranslatedException('openai_api_key_missing', language);
      }
    }

    // ScrapingBee API key is now configured server-side in the MCP,
    // so we don't need to pass it to the chat controller anymore

    _chatSessions[sessionUuid] = ChatControllerOpenAiSdkImpl.startChat(
      scrappableId: scrappable.id!,
      scrapperRequest: scrapperRequest,
      referenceTestData: referenceTestData,
      currentFetchSettings: scrappable.scrappingBeeExtractRules,
      openAiApiKey: openAiApiKey,
    );
    _cacheRefTestData[sessionUuid] = referenceTestData;
    _cacheScrappingBeeExtractLogic[sessionUuid] = scrappingBeeExtractLogic;
    _cacheScrappableRequest[sessionUuid] = scrapperRequest;

    // Initialize AI usage tracking for this session
    _sessionUsesOwnApiKey[sessionUuid] = usesOwnApiKey;
    if (accountAIUsage != null) {
      _sessionAccountAIUsage[sessionUuid] = accountAIUsage;
      session.log(
        'Session $sessionUuid: User has \$${accountAIUsage.totalDollarsSpentFromTotalInUSD.toStringAsFixed(4)} remaining credits, usesOwnApiKey: $usesOwnApiKey',
      );
    } else if (!isLoggedIn) {
      // Anonymous user - initialize session spending tracker
      _anonymousSessionSpending[sessionUuid] = 0.0;
      session.log(
        'Session $sessionUuid: Anonymous user, spending limit: \$${kAnonymousSessionSpendingLimitInDollars.toStringAsFixed(2)}',
      );
    }

    final duration = const Duration(hours: 1);
    final response = CreateSessionResponse(
      expiresIn: duration,
      sessionId: sessionUuid,
    );
    session.log('Created session $sessionUuid for scrappable ${scrappable.id}');
    await session.serverpod.futureCallWithDelay(
      'dispose_temporary_scrappable',
      response,
      duration + Duration(minutes: 1),
    );
    session.log('Scheduled dispose for session $sessionUuid');
    _cacheScrappableIds[sessionUuid] = scrappable.id!;
    await Scrappable.db.updateRow(
      session,
      scrappable.copyWith(
        testEndpointAvailableUntil: DateTime.now().add(duration),
      ),
    );
    session.log('Updated scrappable ${scrappable.id} expiration');
    return response;
  }

  Stream<ChatResponse> listenToScrappableRedraftSession(
    Session session, {
    required RedraftSrappableSessionId sessionUuid,
    required SupportedLanguage language,
  }) {
    // Clean up session when client disconnects
    session.addWillCloseListener((closingSession) async {
      await _disposeSession(sessionId: sessionUuid);
    });

    final subject = _scrapRedraftSessions[sessionUuid];
    if (subject == null) {
      throw createTranslatedException('session_not_found', language);
    }

    // Start heartbeat timer to prevent infrastructure idle timeout (~60s).
    // AI processing can take 60-180s, so we send heartbeats every 20s.
    _heartbeatTimers[sessionUuid]?.cancel();
    _heartbeatTimers[sessionUuid] = Timer.periodic(
      const Duration(seconds: 20),
      (timer) {
        final heartbeatSubject = _scrapRedraftSessions[sessionUuid];
        if (heartbeatSubject != null && !heartbeatSubject.isClosed) {
          heartbeatSubject.add(
            HeartbeatResponse(
              role: PromptRole.system,
              expectsFollowUp: false,
              timestamp: DateTime.now(),
            ),
          );
        } else {
          timer.cancel();
          _heartbeatTimers.remove(sessionUuid);
        }
      },
    );

    return subject.stream;
  }

  Future<void> changeChatModel(
    Session session, {
    required RedraftSrappableSessionId sessionUuid,
    required AiModel aiModel,
    required SupportedLanguage language,
  }) async {
    if (_chatSessions.containsKey(sessionUuid) == false) {
      throw createTranslatedException('session_not_found', language);
    }
    final scrappableId = _scrappableOpenedSessionsIds.entries
        .firstWhereOrNull((element) => element.value == sessionUuid)
        ?.key;
    if (scrappableId == null) {
      throw createTranslatedException('session_not_found', language);
    }

    // Validate plan for powerful model
    if (aiModel == AiModel.powerful) {
      final authenticationInfo = session.authenticated;
      if (authenticationInfo == null) {
        throw createTranslatedException(
          'authentication_required_ai_model',
          language,
        );
      }

      final userId = authenticationInfo.authUserId;
      final account = await AccountInfo.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(userId),
      );

      if (account == null) {
        throw createTranslatedException('account_not_found', language);
      }

      // Check if user has at least Pro plan
      if (account.planTier == PlanTier.none ||
          account.planTier == PlanTier.basic) {
        throw createTranslatedException('upgrade_required_ai_model', language);
      }
    }

    await _chatSessions[sessionUuid]?.changeModel(aiModel);
  }

  Stream<String> sendPromptMessage(
    Session session, {
    required RedraftSrappableSessionId sessionId,
    required String userPrompt,
    required SupportedLanguage language,
  }) async* {
    final chatController = _chatSessions[sessionId];
    if (chatController == null) {
      throw createTranslatedException('session_not_found', language);
    }

    if (!_cacheRefTestData.containsKey(sessionId) ||
        !_cacheScrappableRequest.containsKey(sessionId) ||
        !_cacheScrappingBeeExtractLogic.containsKey(sessionId)) {
      throw createTranslatedException('cache_test_data_not_found', language);
    }

    // Add user message to chat stream for instant UI feedback
    final redraftSubject = _scrapRedraftSessions[sessionId];
    redraftSubject?.add(
      MessageTextResponse(
        role: PromptRole.user,
        expectsFollowUp: true,
        messageText: userPrompt,
      ),
    );

    final ThinkingSessionId thinkingSessionId = uuid.v7();
    _thinkingStream[thinkingSessionId] = StreamController<ThinkingSessionId>();

    // Get client IP address for anonymous user rate limiting
    String? clientIpAddress;
    if (session is MethodCallSession) {
      clientIpAddress = session.request.connectionInfo.remote.address
          .toString();
    }

    await session.serverpod.futureCallWithDelay(
      'session_prompt',
      SessionPrompt(
        sessionId: sessionId,
        userPrompt: userPrompt,
        thinkingSessionId: thinkingSessionId,
        clientIpAddress: clientIpAddress,
        language: language,
      ),
      const Duration(seconds: 1),
    );

    await for (final data in _thinkingStream[thinkingSessionId]!.stream) {
      yield data;
    }
  }
}

Future<void> disposeFromScrappableId(int scrappableId) async {
  final sessionId = _scrappableOpenedSessionsIds[scrappableId];
  if (sessionId != null) await _disposeSession(sessionId: sessionId);
}

Future<void> _disposeSession({
  required RedraftSrappableSessionId sessionId,
  Session? dbSession,
}) async {
  // Save AccountAIUsage to database if we have a session and tracked usage
  if (dbSession != null) {
    final accountAIUsage = _sessionAccountAIUsage[sessionId];
    if (accountAIUsage != null && accountAIUsage.id != null) {
      try {
        await AccountAIUsage.db.updateRow(dbSession, accountAIUsage);
      } catch (e, s) {
        dbSession.log(
          'Failed to save AccountAIUsage for session $sessionId',
          exception: e,
          stackTrace: s,
          level: LogLevel.error,
        );
      }
    }

    // =========================================================================
    // Save pending session data before clearing caches
    // =========================================================================
    // This allows users to deploy their changes even after the session expires.
    // The data is saved to the database and a PendingSessionCommit record is
    // created so commitCurrentEditState can find it later.
    await _savePendingSessionData(sessionId: sessionId, session: dbSession);
  }

  // Clean up all session resources
  _sessionAccountAIUsage.remove(sessionId);
  _anonymousSessionSpending.remove(sessionId);
  _sessionUsesOwnApiKey.remove(sessionId);

  _heartbeatTimers[sessionId]?.cancel();
  _heartbeatTimers.remove(sessionId);

  final chatController = _chatSessions.remove(sessionId);
  await chatController?.dispose();

  final subject = _scrapRedraftSessions.remove(sessionId);
  await subject?.close();

  _cacheScrappableIds.remove(sessionId);
  _cacheRefTestData.remove(sessionId);
  _cacheScrappingBeeExtractLogic.remove(sessionId);
  _cacheScrappableRequest.remove(sessionId);
  _scrappableOpenedSessionsIds.removeWhere((key, value) => value == sessionId);
}

/// Saves the cached session data to the database before the session is disposed.
/// Creates a [PendingSessionCommit] record so the user can deploy changes later.
Future<void> _savePendingSessionData({
  required RedraftSrappableSessionId sessionId,
  required Session session,
}) async {
  final scrappableId = _cacheScrappableIds[sessionId];
  if (scrappableId == null) {
    session.log(
      'No scrappable ID found for session $sessionId, skipping pending data save',
      level: LogLevel.debug,
    );
    return;
  }

  final testData = _cacheRefTestData[sessionId];
  final extractLogic = _cacheScrappingBeeExtractLogic[sessionId];
  final request = _cacheScrappableRequest[sessionId];

  if (testData == null || request == null) {
    session.log(
      'Missing cache data for session $sessionId (testData: ${testData != null}, request: ${request != null}), skipping pending data save',
      level: LogLevel.debug,
    );
    return;
  }

  try {
    await session.db.transaction((transaction) async {
      // Save byte data if present
      if (testData.byteData != null && testData.byteData!.id != null) {
        await ByteTestData.db.updateRow(
          session,
          testData.byteData!,
          transaction: transaction,
        );
      }

      // Save reference test data
      if (testData.id != null) {
        await ReferenceTestData.db.updateRow(
          session,
          testData,
          transaction: transaction,
        );
      }

      // Save extract logic
      if (extractLogic != null && extractLogic.id != null) {
        await ScrappingBeeExtractLogic.db.updateRow(
          session,
          extractLogic,
          transaction: transaction,
        );
      }

      // Save request
      if (request.id != null) {
        await ScrappableRequest.db.updateRow(
          session,
          request,
          transaction: transaction,
        );
      }

      // Check if a pending commit already exists (e.g., from a previous dispose attempt)
      final existingPending = await PendingSessionCommit.db.findFirstRow(
        session,
        where: (t) => t.sessionId.equals(sessionId),
        transaction: transaction,
      );

      if (existingPending != null) {
        // Update existing record with new timestamp
        await PendingSessionCommit.db.updateRow(
          session,
          existingPending.copyWith(createdAt: DateTime.now()),
          transaction: transaction,
        );
        session.log(
          'Updated existing pending commit for session $sessionId (scrappable $scrappableId)',
        );
      } else {
        // Create new pending commit record
        await PendingSessionCommit.db.insertRow(
          session,
          PendingSessionCommit(
            sessionId: sessionId,
            scrappableId: scrappableId,
            createdAt: DateTime.now(),
          ),
          transaction: transaction,
        );
        session.log(
          'Created pending commit for session $sessionId (scrappable $scrappableId)',
        );
      }
    });
  } catch (e, s) {
    session.log(
      'Failed to save pending session data for session $sessionId',
      exception: e,
      stackTrace: s,
      level: LogLevel.error,
    );
    // Don't rethrow - we still want to clean up the session even if saving fails
  }
}

class TestScrappableDisposeFutureCall
    extends FutureCall<CreateSessionResponse> {
  @override
  Future<void> invoke(Session session, CreateSessionResponse? object) async {
    if (object == null) return;
    await _disposeSession(sessionId: object.sessionId, dbSession: session);
  }
}

class SessionPromptFutureCall extends FutureCall<SessionPrompt> {
  @override
  Future<void> invoke(Session session, SessionPrompt? object) async {
    if (object == null) return;
    final ThinkingSessionId thinkingSessionId = object.thinkingSessionId;
    final String sessionId = object.sessionId;
    final String userPrompt = object.userPrompt;
    final SupportedLanguage language = object.language;

    final chatController = _chatSessions[sessionId];
    if (chatController == null) {
      _scrapRedraftSessions[sessionId]?.add(
        ErrorTextResponse(
          role: PromptRole.system,
          expectsFollowUp: false, // Terminal error, no follow-up
          errorMessage: getErrorDescription('chat_session_closed', language),
        ),
      );
      return;
    }

    // =========================================================================
    // AI Credits Check - Before sending message
    // =========================================================================
    final bool usesOwnApiKey = _sessionUsesOwnApiKey[sessionId] ?? false;
    final String? clientIpAddress = object.clientIpAddress;

    // Only check credits if NOT using own API key
    if (!usesOwnApiKey) {
      // -----------------------------------------------------------------------
      // IP-based spending check for anonymous users (cross-session rate limit)
      // -----------------------------------------------------------------------
      if (clientIpAddress != null &&
          _anonymousSessionSpending.containsKey(sessionId)) {
        // Check IP spending limit from database
        final ipSpending = await AnonymousIpSpending.db.findFirstRow(
          session,
          where: (t) => t.ipAddress.equals(clientIpAddress),
        );

        if (ipSpending != null &&
            ipSpending.totalSpentUsd >= kAnonymousIpSpendingLimitInDollars) {
          // Calculate time until the record expires (7 days from creation)
          final expiryTime = ipSpending.createdAt.add(
            kAnonymousIpSpendingResetDuration,
          );
          final timeUntilReset = expiryTime.difference(DateTime.now());

          _scrapRedraftSessions[sessionId]?.add(
            IpLimitReachedResponse(
              role: PromptRole.system,
              expectsFollowUp: false,
              messageText: getErrorDescriptionWithParams(
                'chat_ip_limit',
                language,
                {
                  'limit':
                      '\$${kAnonymousIpSpendingLimitInDollars.toStringAsFixed(2)}',
                },
              ),
              timeUntilReset: timeUntilReset.isNegative
                  ? Duration.zero
                  : timeUntilReset,
              totalSpentUsd: ipSpending.totalSpentUsd,
              spendingLimitUsd: kAnonymousIpSpendingLimitInDollars,
            ),
          );
          await _thinkingStream[thinkingSessionId]?.close();
          _thinkingStream.remove(thinkingSessionId);
          return;
        }
      }

      final accountAIUsage = _sessionAccountAIUsage[sessionId];
      final anonymousSpending = _anonymousSessionSpending[sessionId];

      if (accountAIUsage != null) {
        // Logged-in user - check remaining credits
        final remainingCredits = accountAIUsage.totalDollarsSpentFromTotalInUSD;
        if (remainingCredits <= 0) {
          _scrapRedraftSessions[sessionId]?.add(
            CreditLimitReachedResponse(
              role: PromptRole.system,
              expectsFollowUp: false,
              messageText: getErrorDescription(
                'chat_credits_exhausted_logged_in',
                language,
              ),
              creditsSpent:
                  kDefaultMonthlyAICreditsInDollars - remainingCredits,
              creditsLimit: kDefaultMonthlyAICreditsInDollars,
              canUseOwnApiKey: true,
            ),
          );
          await _thinkingStream[thinkingSessionId]?.close();
          _thinkingStream.remove(thinkingSessionId);
          return;
        }
      } else if (anonymousSpending != null) {
        // Anonymous user - check session spending limit
        if (anonymousSpending >= kAnonymousSessionSpendingLimitInDollars) {
          _scrapRedraftSessions[sessionId]?.add(
            CreditLimitReachedResponse(
              role: PromptRole.system,
              expectsFollowUp: false,
              messageText: getErrorDescriptionWithParams(
                'chat_credits_exhausted_anonymous',
                language,
                {
                  'limit':
                      '\$${kAnonymousSessionSpendingLimitInDollars.toStringAsFixed(2)}',
                },
              ),
              creditsSpent: anonymousSpending,
              creditsLimit: kAnonymousSessionSpendingLimitInDollars,
              canUseOwnApiKey: false, // Must sign up first
            ),
          );
          await _thinkingStream[thinkingSessionId]?.close();
          _thinkingStream.remove(thinkingSessionId);
          return;
        }
      }
    }

    final testData = _cacheRefTestData[sessionId];
    final scrapperRequest = _cacheScrappableRequest[sessionId];
    final scrappingBeeExtractLogic = _cacheScrappingBeeExtractLogic[sessionId];
    if (testData == null ||
        scrapperRequest == null ||
        !_cacheScrappingBeeExtractLogic.containsKey(sessionId)) {
      _scrapRedraftSessions[sessionId]?.add(
        ErrorTextResponse(
          role: PromptRole.system,
          expectsFollowUp: false, // Terminal error, no follow-up
          errorMessage: getErrorDescription(
            'chat_session_data_closed',
            language,
          ),
        ),
      );
      return;
    }

    final StreamController<String> llmThinking = StreamController<String>();
    final StreamController<ChatResponse> chatSeason =
        StreamController<ChatResponse>();

    final StreamSubscription<ChatResponse>
    subsChatSeason = chatSeason.stream.listen((ChatResponse chatResponse) {
      _scrapRedraftSessions[sessionId]?.add(chatResponse);
      if (chatResponse is NewExtractRuleResponse) {
        if (_cacheRefTestData.containsKey(sessionId)) {
          // Preserve database id and byteDataId from existing cached object
          final existingTestData = _cacheRefTestData[sessionId];
          _cacheRefTestData[sessionId] = chatResponse.referenceTestData
              .copyWith(
                id: existingTestData?.id,
                byteDataId: existingTestData?.byteDataId,
              );
        }
        if (_cacheScrappableRequest.containsKey(sessionId)) {
          // Preserve database id from existing cached object
          final existingRequest = _cacheScrappableRequest[sessionId];
          _cacheScrappableRequest[sessionId] = chatResponse.scrapperRequest
              .copyWith(id: existingRequest?.id);
        }
        if (_cacheScrappingBeeExtractLogic.containsKey(sessionId)) {
          // Use the response's id/scrappableId if available (set by insertRow for new records),
          // otherwise fall back to existing cached values
          final existingLogic = _cacheScrappingBeeExtractLogic[sessionId];
          final responseLogic = chatResponse.scrappingBeeExtractLogic;
          _cacheScrappingBeeExtractLogic[sessionId] = responseLogic.copyWith(
            id: responseLogic.id ?? existingLogic?.id,
            scrappableId: responseLogic.scrappableId ?? existingLogic?.scrappableId,
          );
        }
      } else if (chatResponse is UpdatedScrappableRequestResponse) {
        final updatedRequest = chatResponse.scrappableRequest;
        if (updatedRequest != null &&
            _cacheScrappableRequest.containsKey(sessionId)) {
          // Preserve database id from existing cached object
          final existingRequest = _cacheScrappableRequest[sessionId];
          _cacheScrappableRequest[sessionId] =
              updatedRequest.copyWith(id: existingRequest?.id);
        }
      }
    });

    final StreamSubscription<String>
    subLlmThinking = llmThinking.stream.listen((event) {
      _thinkingStream[thinkingSessionId]?.add(
        event.replaceAll(
          '37N8150Q1JBVN85NS4RUOUIUYZ2AEUFX69QBM0X74VD13M9TLNRVOFWS7HZMKRG1X4SOH4BKJT5EUN6K',
          '{API_KEY}',
        ),
      );
    });

    // Note: User message is already added to the chat stream in sendPromptMessage()
    // for immediate UI feedback. Do NOT add it again here to avoid duplicates.

    SendMessageResult messageResult = SendMessageResult.zero;
    try {
      messageResult = await chatController.sendMessage(
        session: session,
        chatSeason: chatSeason,
        userPrompt: userPrompt,
        referenceTestData: testData,
        scrapperRequest: scrapperRequest,
        scrappingBeeExtractLogic: scrappingBeeExtractLogic,
        thinkingStream: llmThinking,
        language: language,
      );

      // =========================================================================
      // AI Credits Deduction - After message completes
      // =========================================================================
      // Only deduct if NOT using own API key and there was actual cost
      if (!usesOwnApiKey && messageResult.costInUsd > 0) {
        final accountAIUsage = _sessionAccountAIUsage[sessionId];
        if (accountAIUsage != null) {
          // Deduct from logged-in user's credits
          // totalDollarsSpentFromTotalInUSD represents REMAINING credits (not spent)
          accountAIUsage.totalDollarsSpentFromTotalInUSD -=
              messageResult.costInUsd;
          session.log(
            'Deducted \$${messageResult.costInUsd.toStringAsFixed(6)} from user credits. '
            'Remaining: \$${accountAIUsage.totalDollarsSpentFromTotalInUSD.toStringAsFixed(4)}',
          );

          // Note: Credits can go negative. This allows the current message to complete
          // even if it exceeds the limit. The negative amount will be "owed" and
          // subtracted from next month's reset.

          // Save to DB immediately after each message for data safety
          try {
            await AccountAIUsage.db.updateRow(session, accountAIUsage);
          } catch (e, s) {
            session.log(
              'Warning: Failed to save AI usage after message',
              exception: e,
              stackTrace: s,
              level: LogLevel.warning,
            );
          }
        } else if (_anonymousSessionSpending.containsKey(sessionId)) {
          // Track anonymous session spending (in-memory per session)
          _anonymousSessionSpending[sessionId] =
              (_anonymousSessionSpending[sessionId] ?? 0.0) +
              messageResult.costInUsd;
          session.log(
            'Anonymous session $sessionId spent \$${messageResult.costInUsd.toStringAsFixed(6)}. '
            'Total session spending: \$${_anonymousSessionSpending[sessionId]!.toStringAsFixed(4)}',
          );

          // Also track IP spending in database (cross-session rate limit)
          if (clientIpAddress != null) {
            try {
              final now = DateTime.now();
              final existingIpSpending = await AnonymousIpSpending.db
                  .findFirstRow(
                    session,
                    where: (t) => t.ipAddress.equals(clientIpAddress),
                  );

              if (existingIpSpending != null) {
                // Update existing record
                final updatedSpending = existingIpSpending.copyWith(
                  totalSpentUsd:
                      existingIpSpending.totalSpentUsd +
                      messageResult.costInUsd,
                  lastUpdatedAt: now,
                );
                await AnonymousIpSpending.db.updateRow(
                  session,
                  updatedSpending,
                );
                session.log(
                  'Updated IP spending for $clientIpAddress: '
                  '\$${updatedSpending.totalSpentUsd.toStringAsFixed(4)} total',
                );
              } else {
                // Create new record
                final newIpSpending = AnonymousIpSpending(
                  ipAddress: clientIpAddress,
                  totalSpentUsd: messageResult.costInUsd,
                  createdAt: now,
                  lastUpdatedAt: now,
                );
                await AnonymousIpSpending.db.insertRow(session, newIpSpending);
                session.log(
                  'Created IP spending record for $clientIpAddress: '
                  '\$${messageResult.costInUsd.toStringAsFixed(6)}',
                );
              }
            } catch (e, s) {
              session.log(
                'Warning: Failed to track IP spending for $clientIpAddress',
                exception: e,
                stackTrace: s,
                level: LogLevel.warning,
              );
            }
          }
        }
      } else if (usesOwnApiKey) {
        session.log('User using own API key - no credits deducted');
      }
    } on OpenAiQuotaExceededException catch (e) {
      // User's own API key has run out of credits on OpenAI's side
      session.log(
        'User API key quota exceeded: ${e.openAiErrorMessage}',
        level: LogLevel.warning,
      );

      // Determine the appropriate message based on whether the user is using their own key
      final String messageText;
      if (usesOwnApiKey) {
        messageText = getErrorDescription(
          'chat_user_api_key_quota',
          language,
        );
      } else {
        // This shouldn't happen normally, but handle it gracefully
        messageText = getErrorDescription(
          'chat_openai_quota_error',
          language,
        );
      }

      _scrapRedraftSessions[sessionId]?.add(
        UserApiKeyQuotaExceededResponse(
          role: PromptRole.system,
          expectsFollowUp: false,
          messageText: messageText,
          openAiErrorMessage: e.openAiErrorMessage,
        ),
      );
      // Don't rethrow - we've handled the error gracefully
    } catch (e, s) {
      chatSeason.add(
        ErrorTextResponse(
          role: PromptRole.system,
          expectsFollowUp: false, // Terminal error, no follow-up
          errorMessage: getErrorDescriptionWithParams(
            'chat_message_error',
            language,
            {'error': e.toString()},
          ),
        ),
      );
      session.log(
        'Error occurred while sending message: $e',
        exception: e,
        level: LogLevel.error,
        stackTrace: s,
      );
      rethrow;
    } finally {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!chatSeason.isClosed) {
        await subsChatSeason.cancel();
        await chatSeason.close();
      }
      if (!llmThinking.isClosed) {
        await subLlmThinking.cancel();
        await llmThinking.close();
      }

      await _thinkingStream[thinkingSessionId]?.close();
      _thinkingStream.remove(thinkingSessionId);
    }
  }
}
