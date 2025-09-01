/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../entities/scrappable/request_status.dart' as _i2;
import '../../entities/scrappable/scrappable.dart' as _i3;

abstract class ScrappableAnalytics
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ScrappableAnalytics._({
    this.id,
    required this.requestStatus,
    required this.requestedAt,
    required this.attachedNanoId,
    required this.attachedApiKey,
    required this.scrappableId,
    this.scrappable,
  });

  factory ScrappableAnalytics({
    int? id,
    required _i2.RequestStatus requestStatus,
    required DateTime requestedAt,
    required String attachedNanoId,
    required String attachedApiKey,
    required int scrappableId,
    _i3.Scrappable? scrappable,
  }) = _ScrappableAnalyticsImpl;

  factory ScrappableAnalytics.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScrappableAnalytics(
      id: jsonSerialization['id'] as int?,
      requestStatus: _i2.RequestStatus.fromJson(
          (jsonSerialization['requestStatus'] as int)),
      requestedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['requestedAt']),
      attachedNanoId: jsonSerialization['attachedNanoId'] as String,
      attachedApiKey: jsonSerialization['attachedApiKey'] as String,
      scrappableId: jsonSerialization['scrappableId'] as int,
      scrappable: jsonSerialization['scrappable'] == null
          ? null
          : _i3.Scrappable.fromJson(
              (jsonSerialization['scrappable'] as Map<String, dynamic>)),
    );
  }

  static final t = ScrappableAnalyticsTable();

  static const db = ScrappableAnalyticsRepository._();

  @override
  int? id;

  _i2.RequestStatus requestStatus;

  DateTime requestedAt;

  String attachedNanoId;

  String attachedApiKey;

  int scrappableId;

  _i3.Scrappable? scrappable;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ScrappableAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrappableAnalytics copyWith({
    int? id,
    _i2.RequestStatus? requestStatus,
    DateTime? requestedAt,
    String? attachedNanoId,
    String? attachedApiKey,
    int? scrappableId,
    _i3.Scrappable? scrappable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'requestStatus': requestStatus.toJson(),
      'requestedAt': requestedAt.toJson(),
      'attachedNanoId': attachedNanoId,
      'attachedApiKey': attachedApiKey,
      'scrappableId': scrappableId,
      if (scrappable != null) 'scrappable': scrappable?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'requestStatus': requestStatus.toJson(),
      'requestedAt': requestedAt.toJson(),
      'attachedNanoId': attachedNanoId,
      'attachedApiKey': attachedApiKey,
      'scrappableId': scrappableId,
      if (scrappable != null) 'scrappable': scrappable?.toJsonForProtocol(),
    };
  }

  static ScrappableAnalyticsInclude include(
      {_i3.ScrappableInclude? scrappable}) {
    return ScrappableAnalyticsInclude._(scrappable: scrappable);
  }

  static ScrappableAnalyticsIncludeList includeList({
    _i1.WhereExpressionBuilder<ScrappableAnalyticsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappableAnalyticsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableAnalyticsTable>? orderByList,
    ScrappableAnalyticsInclude? include,
  }) {
    return ScrappableAnalyticsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScrappableAnalytics.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ScrappableAnalytics.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScrappableAnalyticsImpl extends ScrappableAnalytics {
  _ScrappableAnalyticsImpl({
    int? id,
    required _i2.RequestStatus requestStatus,
    required DateTime requestedAt,
    required String attachedNanoId,
    required String attachedApiKey,
    required int scrappableId,
    _i3.Scrappable? scrappable,
  }) : super._(
          id: id,
          requestStatus: requestStatus,
          requestedAt: requestedAt,
          attachedNanoId: attachedNanoId,
          attachedApiKey: attachedApiKey,
          scrappableId: scrappableId,
          scrappable: scrappable,
        );

  /// Returns a shallow copy of this [ScrappableAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrappableAnalytics copyWith({
    Object? id = _Undefined,
    _i2.RequestStatus? requestStatus,
    DateTime? requestedAt,
    String? attachedNanoId,
    String? attachedApiKey,
    int? scrappableId,
    Object? scrappable = _Undefined,
  }) {
    return ScrappableAnalytics(
      id: id is int? ? id : this.id,
      requestStatus: requestStatus ?? this.requestStatus,
      requestedAt: requestedAt ?? this.requestedAt,
      attachedNanoId: attachedNanoId ?? this.attachedNanoId,
      attachedApiKey: attachedApiKey ?? this.attachedApiKey,
      scrappableId: scrappableId ?? this.scrappableId,
      scrappable: scrappable is _i3.Scrappable?
          ? scrappable
          : this.scrappable?.copyWith(),
    );
  }
}

class ScrappableAnalyticsTable extends _i1.Table<int?> {
  ScrappableAnalyticsTable({super.tableRelation})
      : super(tableName: 'scrappable_analytics') {
    requestStatus = _i1.ColumnEnum(
      'requestStatus',
      this,
      _i1.EnumSerialization.byIndex,
    );
    requestedAt = _i1.ColumnDateTime(
      'requestedAt',
      this,
    );
    attachedNanoId = _i1.ColumnString(
      'attachedNanoId',
      this,
    );
    attachedApiKey = _i1.ColumnString(
      'attachedApiKey',
      this,
    );
    scrappableId = _i1.ColumnInt(
      'scrappableId',
      this,
    );
  }

  late final _i1.ColumnEnum<_i2.RequestStatus> requestStatus;

  late final _i1.ColumnDateTime requestedAt;

  late final _i1.ColumnString attachedNanoId;

  late final _i1.ColumnString attachedApiKey;

  late final _i1.ColumnInt scrappableId;

  _i3.ScrappableTable? _scrappable;

  _i3.ScrappableTable get scrappable {
    if (_scrappable != null) return _scrappable!;
    _scrappable = _i1.createRelationTable(
      relationFieldName: 'scrappable',
      field: ScrappableAnalytics.t.scrappableId,
      foreignField: _i3.Scrappable.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ScrappableTable(tableRelation: foreignTableRelation),
    );
    return _scrappable!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        requestStatus,
        requestedAt,
        attachedNanoId,
        attachedApiKey,
        scrappableId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'scrappable') {
      return scrappable;
    }
    return null;
  }
}

class ScrappableAnalyticsInclude extends _i1.IncludeObject {
  ScrappableAnalyticsInclude._({_i3.ScrappableInclude? scrappable}) {
    _scrappable = scrappable;
  }

  _i3.ScrappableInclude? _scrappable;

  @override
  Map<String, _i1.Include?> get includes => {'scrappable': _scrappable};

  @override
  _i1.Table<int?> get table => ScrappableAnalytics.t;
}

class ScrappableAnalyticsIncludeList extends _i1.IncludeList {
  ScrappableAnalyticsIncludeList._({
    _i1.WhereExpressionBuilder<ScrappableAnalyticsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ScrappableAnalytics.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ScrappableAnalytics.t;
}

class ScrappableAnalyticsRepository {
  const ScrappableAnalyticsRepository._();

  final attachRow = const ScrappableAnalyticsAttachRowRepository._();

  /// Returns a list of [ScrappableAnalytics]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ScrappableAnalytics>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableAnalyticsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappableAnalyticsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableAnalyticsTable>? orderByList,
    _i1.Transaction? transaction,
    ScrappableAnalyticsInclude? include,
  }) async {
    return session.db.find<ScrappableAnalytics>(
      where: where?.call(ScrappableAnalytics.t),
      orderBy: orderBy?.call(ScrappableAnalytics.t),
      orderByList: orderByList?.call(ScrappableAnalytics.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ScrappableAnalytics] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ScrappableAnalytics?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableAnalyticsTable>? where,
    int? offset,
    _i1.OrderByBuilder<ScrappableAnalyticsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableAnalyticsTable>? orderByList,
    _i1.Transaction? transaction,
    ScrappableAnalyticsInclude? include,
  }) async {
    return session.db.findFirstRow<ScrappableAnalytics>(
      where: where?.call(ScrappableAnalytics.t),
      orderBy: orderBy?.call(ScrappableAnalytics.t),
      orderByList: orderByList?.call(ScrappableAnalytics.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ScrappableAnalytics] by its [id] or null if no such row exists.
  Future<ScrappableAnalytics?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ScrappableAnalyticsInclude? include,
  }) async {
    return session.db.findById<ScrappableAnalytics>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ScrappableAnalytics]s in the list and returns the inserted rows.
  ///
  /// The returned [ScrappableAnalytics]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ScrappableAnalytics>> insert(
    _i1.Session session,
    List<ScrappableAnalytics> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ScrappableAnalytics>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ScrappableAnalytics] and returns the inserted row.
  ///
  /// The returned [ScrappableAnalytics] will have its `id` field set.
  Future<ScrappableAnalytics> insertRow(
    _i1.Session session,
    ScrappableAnalytics row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScrappableAnalytics>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ScrappableAnalytics]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ScrappableAnalytics>> update(
    _i1.Session session,
    List<ScrappableAnalytics> rows, {
    _i1.ColumnSelections<ScrappableAnalyticsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ScrappableAnalytics>(
      rows,
      columns: columns?.call(ScrappableAnalytics.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScrappableAnalytics]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ScrappableAnalytics> updateRow(
    _i1.Session session,
    ScrappableAnalytics row, {
    _i1.ColumnSelections<ScrappableAnalyticsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScrappableAnalytics>(
      row,
      columns: columns?.call(ScrappableAnalytics.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ScrappableAnalytics]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ScrappableAnalytics>> delete(
    _i1.Session session,
    List<ScrappableAnalytics> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ScrappableAnalytics>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ScrappableAnalytics].
  Future<ScrappableAnalytics> deleteRow(
    _i1.Session session,
    ScrappableAnalytics row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScrappableAnalytics>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ScrappableAnalytics>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ScrappableAnalyticsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ScrappableAnalytics>(
      where: where(ScrappableAnalytics.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableAnalyticsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ScrappableAnalytics>(
      where: where?.call(ScrappableAnalytics.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ScrappableAnalyticsAttachRowRepository {
  const ScrappableAnalyticsAttachRowRepository._();

  /// Creates a relation between the given [ScrappableAnalytics] and [Scrappable]
  /// by setting the [ScrappableAnalytics]'s foreign key `scrappableId` to refer to the [Scrappable].
  Future<void> scrappable(
    _i1.Session session,
    ScrappableAnalytics scrappableAnalytics,
    _i3.Scrappable scrappable, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappableAnalytics.id == null) {
      throw ArgumentError.notNull('scrappableAnalytics.id');
    }
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }

    var $scrappableAnalytics =
        scrappableAnalytics.copyWith(scrappableId: scrappable.id);
    await session.db.updateRow<ScrappableAnalytics>(
      $scrappableAnalytics,
      columns: [ScrappableAnalytics.t.scrappableId],
      transaction: transaction,
    );
  }
}
