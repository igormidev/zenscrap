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
import '../../entities/scrappable/scrappable_request.dart' as _i2;
import '../../entities/scrappable/reference_test_data.dart' as _i3;

abstract class Scrappable
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  Scrappable._({
    _i1.UuidValue? id,
    required this.createdAt,
    required this.name,
    required this.description,
    this.scrappingRules,
    this.testScrappingRules,
    required this.isActive,
    required this.targetRequestId,
    this.targetRequest,
    required this.referenceTestDataId,
    this.referenceTestData,
  }) : id = id ?? _i1.Uuid().v4obj();

  factory Scrappable({
    _i1.UuidValue? id,
    required DateTime createdAt,
    required String name,
    required String description,
    String? scrappingRules,
    String? testScrappingRules,
    required bool isActive,
    required int targetRequestId,
    _i2.ScrappableRequest? targetRequest,
    required int referenceTestDataId,
    _i3.ReferenceTestData? referenceTestData,
  }) = _ScrappableImpl;

  factory Scrappable.fromJson(Map<String, dynamic> jsonSerialization) {
    return Scrappable(
      id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      scrappingRules: jsonSerialization['scrappingRules'] as String?,
      testScrappingRules: jsonSerialization['testScrappingRules'] as String?,
      isActive: jsonSerialization['isActive'] as bool,
      targetRequestId: jsonSerialization['targetRequestId'] as int,
      targetRequest: jsonSerialization['targetRequest'] == null
          ? null
          : _i2.ScrappableRequest.fromJson(
              (jsonSerialization['targetRequest'] as Map<String, dynamic>)),
      referenceTestDataId: jsonSerialization['referenceTestDataId'] as int,
      referenceTestData: jsonSerialization['referenceTestData'] == null
          ? null
          : _i3.ReferenceTestData.fromJson(
              (jsonSerialization['referenceTestData'] as Map<String, dynamic>)),
    );
  }

  static final t = ScrappableTable();

  static const db = ScrappableRepository._();

  @override
  _i1.UuidValue id;

  DateTime createdAt;

  String name;

  String description;

  String? scrappingRules;

  String? testScrappingRules;

  bool isActive;

  int targetRequestId;

  _i2.ScrappableRequest? targetRequest;

  int referenceTestDataId;

  _i3.ReferenceTestData? referenceTestData;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  /// Returns a shallow copy of this [Scrappable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Scrappable copyWith({
    _i1.UuidValue? id,
    DateTime? createdAt,
    String? name,
    String? description,
    String? scrappingRules,
    String? testScrappingRules,
    bool? isActive,
    int? targetRequestId,
    _i2.ScrappableRequest? targetRequest,
    int? referenceTestDataId,
    _i3.ReferenceTestData? referenceTestData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      'createdAt': createdAt.toJson(),
      'name': name,
      'description': description,
      if (scrappingRules != null) 'scrappingRules': scrappingRules,
      if (testScrappingRules != null) 'testScrappingRules': testScrappingRules,
      'isActive': isActive,
      'targetRequestId': targetRequestId,
      if (targetRequest != null) 'targetRequest': targetRequest?.toJson(),
      'referenceTestDataId': referenceTestDataId,
      if (referenceTestData != null)
        'referenceTestData': referenceTestData?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'id': id.toJson(),
      'createdAt': createdAt.toJson(),
      'name': name,
      'description': description,
      if (scrappingRules != null) 'scrappingRules': scrappingRules,
      if (testScrappingRules != null) 'testScrappingRules': testScrappingRules,
      'isActive': isActive,
      'targetRequestId': targetRequestId,
      if (targetRequest != null)
        'targetRequest': targetRequest?.toJsonForProtocol(),
      'referenceTestDataId': referenceTestDataId,
      if (referenceTestData != null)
        'referenceTestData': referenceTestData?.toJsonForProtocol(),
    };
  }

  static ScrappableInclude include({
    _i2.ScrappableRequestInclude? targetRequest,
    _i3.ReferenceTestDataInclude? referenceTestData,
  }) {
    return ScrappableInclude._(
      targetRequest: targetRequest,
      referenceTestData: referenceTestData,
    );
  }

  static ScrappableIncludeList includeList({
    _i1.WhereExpressionBuilder<ScrappableTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappableTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableTable>? orderByList,
    ScrappableInclude? include,
  }) {
    return ScrappableIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Scrappable.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Scrappable.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScrappableImpl extends Scrappable {
  _ScrappableImpl({
    _i1.UuidValue? id,
    required DateTime createdAt,
    required String name,
    required String description,
    String? scrappingRules,
    String? testScrappingRules,
    required bool isActive,
    required int targetRequestId,
    _i2.ScrappableRequest? targetRequest,
    required int referenceTestDataId,
    _i3.ReferenceTestData? referenceTestData,
  }) : super._(
          id: id,
          createdAt: createdAt,
          name: name,
          description: description,
          scrappingRules: scrappingRules,
          testScrappingRules: testScrappingRules,
          isActive: isActive,
          targetRequestId: targetRequestId,
          targetRequest: targetRequest,
          referenceTestDataId: referenceTestDataId,
          referenceTestData: referenceTestData,
        );

  /// Returns a shallow copy of this [Scrappable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Scrappable copyWith({
    _i1.UuidValue? id,
    DateTime? createdAt,
    String? name,
    String? description,
    Object? scrappingRules = _Undefined,
    Object? testScrappingRules = _Undefined,
    bool? isActive,
    int? targetRequestId,
    Object? targetRequest = _Undefined,
    int? referenceTestDataId,
    Object? referenceTestData = _Undefined,
  }) {
    return Scrappable(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      description: description ?? this.description,
      scrappingRules:
          scrappingRules is String? ? scrappingRules : this.scrappingRules,
      testScrappingRules: testScrappingRules is String?
          ? testScrappingRules
          : this.testScrappingRules,
      isActive: isActive ?? this.isActive,
      targetRequestId: targetRequestId ?? this.targetRequestId,
      targetRequest: targetRequest is _i2.ScrappableRequest?
          ? targetRequest
          : this.targetRequest?.copyWith(),
      referenceTestDataId: referenceTestDataId ?? this.referenceTestDataId,
      referenceTestData: referenceTestData is _i3.ReferenceTestData?
          ? referenceTestData
          : this.referenceTestData?.copyWith(),
    );
  }
}

class ScrappableTable extends _i1.Table<_i1.UuidValue> {
  ScrappableTable({super.tableRelation}) : super(tableName: 'scrappable') {
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    scrappingRules = _i1.ColumnString(
      'scrappingRules',
      this,
    );
    testScrappingRules = _i1.ColumnString(
      'testScrappingRules',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
    targetRequestId = _i1.ColumnInt(
      'targetRequestId',
      this,
    );
    referenceTestDataId = _i1.ColumnInt(
      'referenceTestDataId',
      this,
    );
  }

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnString scrappingRules;

  late final _i1.ColumnString testScrappingRules;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnInt targetRequestId;

  _i2.ScrappableRequestTable? _targetRequest;

  late final _i1.ColumnInt referenceTestDataId;

  _i3.ReferenceTestDataTable? _referenceTestData;

  _i2.ScrappableRequestTable get targetRequest {
    if (_targetRequest != null) return _targetRequest!;
    _targetRequest = _i1.createRelationTable(
      relationFieldName: 'targetRequest',
      field: Scrappable.t.targetRequestId,
      foreignField: _i2.ScrappableRequest.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ScrappableRequestTable(tableRelation: foreignTableRelation),
    );
    return _targetRequest!;
  }

  _i3.ReferenceTestDataTable get referenceTestData {
    if (_referenceTestData != null) return _referenceTestData!;
    _referenceTestData = _i1.createRelationTable(
      relationFieldName: 'referenceTestData',
      field: Scrappable.t.referenceTestDataId,
      foreignField: _i3.ReferenceTestData.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ReferenceTestDataTable(tableRelation: foreignTableRelation),
    );
    return _referenceTestData!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        createdAt,
        name,
        description,
        scrappingRules,
        testScrappingRules,
        isActive,
        targetRequestId,
        referenceTestDataId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'targetRequest') {
      return targetRequest;
    }
    if (relationField == 'referenceTestData') {
      return referenceTestData;
    }
    return null;
  }
}

class ScrappableInclude extends _i1.IncludeObject {
  ScrappableInclude._({
    _i2.ScrappableRequestInclude? targetRequest,
    _i3.ReferenceTestDataInclude? referenceTestData,
  }) {
    _targetRequest = targetRequest;
    _referenceTestData = referenceTestData;
  }

  _i2.ScrappableRequestInclude? _targetRequest;

  _i3.ReferenceTestDataInclude? _referenceTestData;

  @override
  Map<String, _i1.Include?> get includes => {
        'targetRequest': _targetRequest,
        'referenceTestData': _referenceTestData,
      };

  @override
  _i1.Table<_i1.UuidValue> get table => Scrappable.t;
}

class ScrappableIncludeList extends _i1.IncludeList {
  ScrappableIncludeList._({
    _i1.WhereExpressionBuilder<ScrappableTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Scrappable.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => Scrappable.t;
}

class ScrappableRepository {
  const ScrappableRepository._();

  final attachRow = const ScrappableAttachRowRepository._();

  /// Returns a list of [Scrappable]s matching the given query parameters.
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
  Future<List<Scrappable>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappableTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableTable>? orderByList,
    _i1.Transaction? transaction,
    ScrappableInclude? include,
  }) async {
    return session.db.find<Scrappable>(
      where: where?.call(Scrappable.t),
      orderBy: orderBy?.call(Scrappable.t),
      orderByList: orderByList?.call(Scrappable.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Scrappable] matching the given query parameters.
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
  Future<Scrappable?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableTable>? where,
    int? offset,
    _i1.OrderByBuilder<ScrappableTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableTable>? orderByList,
    _i1.Transaction? transaction,
    ScrappableInclude? include,
  }) async {
    return session.db.findFirstRow<Scrappable>(
      where: where?.call(Scrappable.t),
      orderBy: orderBy?.call(Scrappable.t),
      orderByList: orderByList?.call(Scrappable.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Scrappable] by its [id] or null if no such row exists.
  Future<Scrappable?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    ScrappableInclude? include,
  }) async {
    return session.db.findById<Scrappable>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Scrappable]s in the list and returns the inserted rows.
  ///
  /// The returned [Scrappable]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Scrappable>> insert(
    _i1.Session session,
    List<Scrappable> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Scrappable>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Scrappable] and returns the inserted row.
  ///
  /// The returned [Scrappable] will have its `id` field set.
  Future<Scrappable> insertRow(
    _i1.Session session,
    Scrappable row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Scrappable>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Scrappable]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Scrappable>> update(
    _i1.Session session,
    List<Scrappable> rows, {
    _i1.ColumnSelections<ScrappableTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Scrappable>(
      rows,
      columns: columns?.call(Scrappable.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Scrappable]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Scrappable> updateRow(
    _i1.Session session,
    Scrappable row, {
    _i1.ColumnSelections<ScrappableTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Scrappable>(
      row,
      columns: columns?.call(Scrappable.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Scrappable]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Scrappable>> delete(
    _i1.Session session,
    List<Scrappable> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Scrappable>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Scrappable].
  Future<Scrappable> deleteRow(
    _i1.Session session,
    Scrappable row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Scrappable>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Scrappable>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ScrappableTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Scrappable>(
      where: where(Scrappable.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Scrappable>(
      where: where?.call(Scrappable.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ScrappableAttachRowRepository {
  const ScrappableAttachRowRepository._();

  /// Creates a relation between the given [Scrappable] and [ScrappableRequest]
  /// by setting the [Scrappable]'s foreign key `targetRequestId` to refer to the [ScrappableRequest].
  Future<void> targetRequest(
    _i1.Session session,
    Scrappable scrappable,
    _i2.ScrappableRequest targetRequest, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }
    if (targetRequest.id == null) {
      throw ArgumentError.notNull('targetRequest.id');
    }

    var $scrappable = scrappable.copyWith(targetRequestId: targetRequest.id);
    await session.db.updateRow<Scrappable>(
      $scrappable,
      columns: [Scrappable.t.targetRequestId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Scrappable] and [ReferenceTestData]
  /// by setting the [Scrappable]'s foreign key `referenceTestDataId` to refer to the [ReferenceTestData].
  Future<void> referenceTestData(
    _i1.Session session,
    Scrappable scrappable,
    _i3.ReferenceTestData referenceTestData, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }
    if (referenceTestData.id == null) {
      throw ArgumentError.notNull('referenceTestData.id');
    }

    var $scrappable =
        scrappable.copyWith(referenceTestDataId: referenceTestData.id);
    await session.db.updateRow<Scrappable>(
      $scrappable,
      columns: [Scrappable.t.referenceTestDataId],
      transaction: transaction,
    );
  }
}
