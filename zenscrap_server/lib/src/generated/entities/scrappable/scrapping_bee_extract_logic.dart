/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../entities/scrappable/scrappable.dart' as _i2;
import 'package:zenscrap_server/src/generated/protocol.dart' as _i3;

abstract class ScrappingBeeExtractLogic
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ScrappingBeeExtractLogic._({
    this.id,
    this.scrappableId,
    this.scrappable,
    required this.extractRules,
    this.jsScenario,
    required this.renderJs,
    this.wait,
    this.waitFor,
    this.waitBrowser,
    required this.premiumProxy,
    required this.stealthProxy,
    this.countryCode,
    this.sessionId,
    this.customGoogle,
  });

  factory ScrappingBeeExtractLogic({
    int? id,
    int? scrappableId,
    _i2.Scrappable? scrappable,
    required String extractRules,
    String? jsScenario,
    required bool renderJs,
    int? wait,
    String? waitFor,
    String? waitBrowser,
    required bool premiumProxy,
    required bool stealthProxy,
    String? countryCode,
    String? sessionId,
    bool? customGoogle,
  }) = _ScrappingBeeExtractLogicImpl;

  factory ScrappingBeeExtractLogic.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ScrappingBeeExtractLogic(
      id: jsonSerialization['id'] as int?,
      scrappableId: jsonSerialization['scrappableId'] as int?,
      scrappable: jsonSerialization['scrappable'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Scrappable>(
              jsonSerialization['scrappable'],
            ),
      extractRules: jsonSerialization['extractRules'] as String,
      jsScenario: jsonSerialization['jsScenario'] as String?,
      renderJs: jsonSerialization['renderJs'] as bool,
      wait: jsonSerialization['wait'] as int?,
      waitFor: jsonSerialization['waitFor'] as String?,
      waitBrowser: jsonSerialization['waitBrowser'] as String?,
      premiumProxy: jsonSerialization['premiumProxy'] as bool,
      stealthProxy: jsonSerialization['stealthProxy'] as bool,
      countryCode: jsonSerialization['countryCode'] as String?,
      sessionId: jsonSerialization['sessionId'] as String?,
      customGoogle: jsonSerialization['customGoogle'] as bool?,
    );
  }

  static final t = ScrappingBeeExtractLogicTable();

  static const db = ScrappingBeeExtractLogicRepository._();

  @override
  int? id;

  int? scrappableId;

  _i2.Scrappable? scrappable;

  String extractRules;

  String? jsScenario;

  bool renderJs;

  int? wait;

  String? waitFor;

  String? waitBrowser;

  bool premiumProxy;

  bool stealthProxy;

  String? countryCode;

  String? sessionId;

  bool? customGoogle;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ScrappingBeeExtractLogic]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrappingBeeExtractLogic copyWith({
    int? id,
    int? scrappableId,
    _i2.Scrappable? scrappable,
    String? extractRules,
    String? jsScenario,
    bool? renderJs,
    int? wait,
    String? waitFor,
    String? waitBrowser,
    bool? premiumProxy,
    bool? stealthProxy,
    String? countryCode,
    String? sessionId,
    bool? customGoogle,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScrappingBeeExtractLogic',
      if (id != null) 'id': id,
      if (scrappableId != null) 'scrappableId': scrappableId,
      if (scrappable != null) 'scrappable': scrappable?.toJson(),
      'extractRules': extractRules,
      if (jsScenario != null) 'jsScenario': jsScenario,
      'renderJs': renderJs,
      if (wait != null) 'wait': wait,
      if (waitFor != null) 'waitFor': waitFor,
      if (waitBrowser != null) 'waitBrowser': waitBrowser,
      'premiumProxy': premiumProxy,
      'stealthProxy': stealthProxy,
      if (countryCode != null) 'countryCode': countryCode,
      if (sessionId != null) 'sessionId': sessionId,
      if (customGoogle != null) 'customGoogle': customGoogle,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScrappingBeeExtractLogic',
      if (id != null) 'id': id,
      if (scrappableId != null) 'scrappableId': scrappableId,
      if (scrappable != null) 'scrappable': scrappable?.toJsonForProtocol(),
      'extractRules': extractRules,
      if (jsScenario != null) 'jsScenario': jsScenario,
      'renderJs': renderJs,
      if (wait != null) 'wait': wait,
      if (waitFor != null) 'waitFor': waitFor,
      if (waitBrowser != null) 'waitBrowser': waitBrowser,
      'premiumProxy': premiumProxy,
      'stealthProxy': stealthProxy,
      if (countryCode != null) 'countryCode': countryCode,
      if (sessionId != null) 'sessionId': sessionId,
      if (customGoogle != null) 'customGoogle': customGoogle,
    };
  }

  static ScrappingBeeExtractLogicInclude include({
    _i2.ScrappableInclude? scrappable,
  }) {
    return ScrappingBeeExtractLogicInclude._(scrappable: scrappable);
  }

  static ScrappingBeeExtractLogicIncludeList includeList({
    _i1.WhereExpressionBuilder<ScrappingBeeExtractLogicTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappingBeeExtractLogicTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappingBeeExtractLogicTable>? orderByList,
    ScrappingBeeExtractLogicInclude? include,
  }) {
    return ScrappingBeeExtractLogicIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScrappingBeeExtractLogic.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ScrappingBeeExtractLogic.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScrappingBeeExtractLogicImpl extends ScrappingBeeExtractLogic {
  _ScrappingBeeExtractLogicImpl({
    int? id,
    int? scrappableId,
    _i2.Scrappable? scrappable,
    required String extractRules,
    String? jsScenario,
    required bool renderJs,
    int? wait,
    String? waitFor,
    String? waitBrowser,
    required bool premiumProxy,
    required bool stealthProxy,
    String? countryCode,
    String? sessionId,
    bool? customGoogle,
  }) : super._(
         id: id,
         scrappableId: scrappableId,
         scrappable: scrappable,
         extractRules: extractRules,
         jsScenario: jsScenario,
         renderJs: renderJs,
         wait: wait,
         waitFor: waitFor,
         waitBrowser: waitBrowser,
         premiumProxy: premiumProxy,
         stealthProxy: stealthProxy,
         countryCode: countryCode,
         sessionId: sessionId,
         customGoogle: customGoogle,
       );

  /// Returns a shallow copy of this [ScrappingBeeExtractLogic]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrappingBeeExtractLogic copyWith({
    Object? id = _Undefined,
    Object? scrappableId = _Undefined,
    Object? scrappable = _Undefined,
    String? extractRules,
    Object? jsScenario = _Undefined,
    bool? renderJs,
    Object? wait = _Undefined,
    Object? waitFor = _Undefined,
    Object? waitBrowser = _Undefined,
    bool? premiumProxy,
    bool? stealthProxy,
    Object? countryCode = _Undefined,
    Object? sessionId = _Undefined,
    Object? customGoogle = _Undefined,
  }) {
    return ScrappingBeeExtractLogic(
      id: id is int? ? id : this.id,
      scrappableId: scrappableId is int? ? scrappableId : this.scrappableId,
      scrappable: scrappable is _i2.Scrappable?
          ? scrappable
          : this.scrappable?.copyWith(),
      extractRules: extractRules ?? this.extractRules,
      jsScenario: jsScenario is String? ? jsScenario : this.jsScenario,
      renderJs: renderJs ?? this.renderJs,
      wait: wait is int? ? wait : this.wait,
      waitFor: waitFor is String? ? waitFor : this.waitFor,
      waitBrowser: waitBrowser is String? ? waitBrowser : this.waitBrowser,
      premiumProxy: premiumProxy ?? this.premiumProxy,
      stealthProxy: stealthProxy ?? this.stealthProxy,
      countryCode: countryCode is String? ? countryCode : this.countryCode,
      sessionId: sessionId is String? ? sessionId : this.sessionId,
      customGoogle: customGoogle is bool? ? customGoogle : this.customGoogle,
    );
  }
}

class ScrappingBeeExtractLogicUpdateTable
    extends _i1.UpdateTable<ScrappingBeeExtractLogicTable> {
  ScrappingBeeExtractLogicUpdateTable(super.table);

  _i1.ColumnValue<int, int> scrappableId(int? value) => _i1.ColumnValue(
    table.scrappableId,
    value,
  );

  _i1.ColumnValue<String, String> extractRules(String value) => _i1.ColumnValue(
    table.extractRules,
    value,
  );

  _i1.ColumnValue<String, String> jsScenario(String? value) => _i1.ColumnValue(
    table.jsScenario,
    value,
  );

  _i1.ColumnValue<bool, bool> renderJs(bool value) => _i1.ColumnValue(
    table.renderJs,
    value,
  );

  _i1.ColumnValue<int, int> wait(int? value) => _i1.ColumnValue(
    table.wait,
    value,
  );

  _i1.ColumnValue<String, String> waitFor(String? value) => _i1.ColumnValue(
    table.waitFor,
    value,
  );

  _i1.ColumnValue<String, String> waitBrowser(String? value) => _i1.ColumnValue(
    table.waitBrowser,
    value,
  );

  _i1.ColumnValue<bool, bool> premiumProxy(bool value) => _i1.ColumnValue(
    table.premiumProxy,
    value,
  );

  _i1.ColumnValue<bool, bool> stealthProxy(bool value) => _i1.ColumnValue(
    table.stealthProxy,
    value,
  );

  _i1.ColumnValue<String, String> countryCode(String? value) => _i1.ColumnValue(
    table.countryCode,
    value,
  );

  _i1.ColumnValue<String, String> sessionId(String? value) => _i1.ColumnValue(
    table.sessionId,
    value,
  );

  _i1.ColumnValue<bool, bool> customGoogle(bool? value) => _i1.ColumnValue(
    table.customGoogle,
    value,
  );
}

class ScrappingBeeExtractLogicTable extends _i1.Table<int?> {
  ScrappingBeeExtractLogicTable({super.tableRelation})
    : super(tableName: 'scrapping_bee_extract_logic') {
    updateTable = ScrappingBeeExtractLogicUpdateTable(this);
    scrappableId = _i1.ColumnInt(
      'scrappableId',
      this,
    );
    extractRules = _i1.ColumnString(
      'extractRules',
      this,
    );
    jsScenario = _i1.ColumnString(
      'jsScenario',
      this,
    );
    renderJs = _i1.ColumnBool(
      'renderJs',
      this,
    );
    wait = _i1.ColumnInt(
      'wait',
      this,
    );
    waitFor = _i1.ColumnString(
      'waitFor',
      this,
    );
    waitBrowser = _i1.ColumnString(
      'waitBrowser',
      this,
    );
    premiumProxy = _i1.ColumnBool(
      'premiumProxy',
      this,
    );
    stealthProxy = _i1.ColumnBool(
      'stealthProxy',
      this,
    );
    countryCode = _i1.ColumnString(
      'countryCode',
      this,
    );
    sessionId = _i1.ColumnString(
      'sessionId',
      this,
    );
    customGoogle = _i1.ColumnBool(
      'customGoogle',
      this,
    );
  }

  late final ScrappingBeeExtractLogicUpdateTable updateTable;

  late final _i1.ColumnInt scrappableId;

  _i2.ScrappableTable? _scrappable;

  late final _i1.ColumnString extractRules;

  late final _i1.ColumnString jsScenario;

  late final _i1.ColumnBool renderJs;

  late final _i1.ColumnInt wait;

  late final _i1.ColumnString waitFor;

  late final _i1.ColumnString waitBrowser;

  late final _i1.ColumnBool premiumProxy;

  late final _i1.ColumnBool stealthProxy;

  late final _i1.ColumnString countryCode;

  late final _i1.ColumnString sessionId;

  late final _i1.ColumnBool customGoogle;

  _i2.ScrappableTable get scrappable {
    if (_scrappable != null) return _scrappable!;
    _scrappable = _i1.createRelationTable(
      relationFieldName: 'scrappable',
      field: ScrappingBeeExtractLogic.t.scrappableId,
      foreignField: _i2.Scrappable.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ScrappableTable(tableRelation: foreignTableRelation),
    );
    return _scrappable!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    scrappableId,
    extractRules,
    jsScenario,
    renderJs,
    wait,
    waitFor,
    waitBrowser,
    premiumProxy,
    stealthProxy,
    countryCode,
    sessionId,
    customGoogle,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'scrappable') {
      return scrappable;
    }
    return null;
  }
}

class ScrappingBeeExtractLogicInclude extends _i1.IncludeObject {
  ScrappingBeeExtractLogicInclude._({_i2.ScrappableInclude? scrappable}) {
    _scrappable = scrappable;
  }

  _i2.ScrappableInclude? _scrappable;

  @override
  Map<String, _i1.Include?> get includes => {'scrappable': _scrappable};

  @override
  _i1.Table<int?> get table => ScrappingBeeExtractLogic.t;
}

class ScrappingBeeExtractLogicIncludeList extends _i1.IncludeList {
  ScrappingBeeExtractLogicIncludeList._({
    _i1.WhereExpressionBuilder<ScrappingBeeExtractLogicTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ScrappingBeeExtractLogic.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ScrappingBeeExtractLogic.t;
}

class ScrappingBeeExtractLogicRepository {
  const ScrappingBeeExtractLogicRepository._();

  final attachRow = const ScrappingBeeExtractLogicAttachRowRepository._();

  final detachRow = const ScrappingBeeExtractLogicDetachRowRepository._();

  /// Returns a list of [ScrappingBeeExtractLogic]s matching the given query parameters.
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
  Future<List<ScrappingBeeExtractLogic>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappingBeeExtractLogicTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappingBeeExtractLogicTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappingBeeExtractLogicTable>? orderByList,
    _i1.Transaction? transaction,
    ScrappingBeeExtractLogicInclude? include,
  }) async {
    return session.db.find<ScrappingBeeExtractLogic>(
      where: where?.call(ScrappingBeeExtractLogic.t),
      orderBy: orderBy?.call(ScrappingBeeExtractLogic.t),
      orderByList: orderByList?.call(ScrappingBeeExtractLogic.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ScrappingBeeExtractLogic] matching the given query parameters.
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
  Future<ScrappingBeeExtractLogic?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappingBeeExtractLogicTable>? where,
    int? offset,
    _i1.OrderByBuilder<ScrappingBeeExtractLogicTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappingBeeExtractLogicTable>? orderByList,
    _i1.Transaction? transaction,
    ScrappingBeeExtractLogicInclude? include,
  }) async {
    return session.db.findFirstRow<ScrappingBeeExtractLogic>(
      where: where?.call(ScrappingBeeExtractLogic.t),
      orderBy: orderBy?.call(ScrappingBeeExtractLogic.t),
      orderByList: orderByList?.call(ScrappingBeeExtractLogic.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ScrappingBeeExtractLogic] by its [id] or null if no such row exists.
  Future<ScrappingBeeExtractLogic?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ScrappingBeeExtractLogicInclude? include,
  }) async {
    return session.db.findById<ScrappingBeeExtractLogic>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ScrappingBeeExtractLogic]s in the list and returns the inserted rows.
  ///
  /// The returned [ScrappingBeeExtractLogic]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ScrappingBeeExtractLogic>> insert(
    _i1.Session session,
    List<ScrappingBeeExtractLogic> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ScrappingBeeExtractLogic>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ScrappingBeeExtractLogic] and returns the inserted row.
  ///
  /// The returned [ScrappingBeeExtractLogic] will have its `id` field set.
  Future<ScrappingBeeExtractLogic> insertRow(
    _i1.Session session,
    ScrappingBeeExtractLogic row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScrappingBeeExtractLogic>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ScrappingBeeExtractLogic]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ScrappingBeeExtractLogic>> update(
    _i1.Session session,
    List<ScrappingBeeExtractLogic> rows, {
    _i1.ColumnSelections<ScrappingBeeExtractLogicTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ScrappingBeeExtractLogic>(
      rows,
      columns: columns?.call(ScrappingBeeExtractLogic.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScrappingBeeExtractLogic]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ScrappingBeeExtractLogic> updateRow(
    _i1.Session session,
    ScrappingBeeExtractLogic row, {
    _i1.ColumnSelections<ScrappingBeeExtractLogicTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScrappingBeeExtractLogic>(
      row,
      columns: columns?.call(ScrappingBeeExtractLogic.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScrappingBeeExtractLogic] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ScrappingBeeExtractLogic?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ScrappingBeeExtractLogicUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ScrappingBeeExtractLogic>(
      id,
      columnValues: columnValues(ScrappingBeeExtractLogic.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ScrappingBeeExtractLogic]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ScrappingBeeExtractLogic>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ScrappingBeeExtractLogicUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ScrappingBeeExtractLogicTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappingBeeExtractLogicTable>? orderBy,
    _i1.OrderByListBuilder<ScrappingBeeExtractLogicTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ScrappingBeeExtractLogic>(
      columnValues: columnValues(ScrappingBeeExtractLogic.t.updateTable),
      where: where(ScrappingBeeExtractLogic.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScrappingBeeExtractLogic.t),
      orderByList: orderByList?.call(ScrappingBeeExtractLogic.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ScrappingBeeExtractLogic]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ScrappingBeeExtractLogic>> delete(
    _i1.Session session,
    List<ScrappingBeeExtractLogic> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ScrappingBeeExtractLogic>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ScrappingBeeExtractLogic].
  Future<ScrappingBeeExtractLogic> deleteRow(
    _i1.Session session,
    ScrappingBeeExtractLogic row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScrappingBeeExtractLogic>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ScrappingBeeExtractLogic>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ScrappingBeeExtractLogicTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ScrappingBeeExtractLogic>(
      where: where(ScrappingBeeExtractLogic.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappingBeeExtractLogicTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ScrappingBeeExtractLogic>(
      where: where?.call(ScrappingBeeExtractLogic.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ScrappingBeeExtractLogicAttachRowRepository {
  const ScrappingBeeExtractLogicAttachRowRepository._();

  /// Creates a relation between the given [ScrappingBeeExtractLogic] and [Scrappable]
  /// by setting the [ScrappingBeeExtractLogic]'s foreign key `scrappableId` to refer to the [Scrappable].
  Future<void> scrappable(
    _i1.Session session,
    ScrappingBeeExtractLogic scrappingBeeExtractLogic,
    _i2.Scrappable scrappable, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappingBeeExtractLogic.id == null) {
      throw ArgumentError.notNull('scrappingBeeExtractLogic.id');
    }
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }

    var $scrappingBeeExtractLogic = scrappingBeeExtractLogic.copyWith(
      scrappableId: scrappable.id,
    );
    await session.db.updateRow<ScrappingBeeExtractLogic>(
      $scrappingBeeExtractLogic,
      columns: [ScrappingBeeExtractLogic.t.scrappableId],
      transaction: transaction,
    );
  }
}

class ScrappingBeeExtractLogicDetachRowRepository {
  const ScrappingBeeExtractLogicDetachRowRepository._();

  /// Detaches the relation between this [ScrappingBeeExtractLogic] and the [Scrappable] set in `scrappable`
  /// by setting the [ScrappingBeeExtractLogic]'s foreign key `scrappableId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> scrappable(
    _i1.Session session,
    ScrappingBeeExtractLogic scrappingBeeExtractLogic, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappingBeeExtractLogic.id == null) {
      throw ArgumentError.notNull('scrappingBeeExtractLogic.id');
    }

    var $scrappingBeeExtractLogic = scrappingBeeExtractLogic.copyWith(
      scrappableId: null,
    );
    await session.db.updateRow<ScrappingBeeExtractLogic>(
      $scrappingBeeExtractLogic,
      columns: [ScrappingBeeExtractLogic.t.scrappableId],
      transaction: transaction,
    );
  }
}
