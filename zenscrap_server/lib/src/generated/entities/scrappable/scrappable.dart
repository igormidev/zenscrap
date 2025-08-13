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
import '../../entities/scrappable/scrappable_target_request.dart' as _i2;
import '../../entities/scrappable/reference_test_data.dart' as _i3;

abstract class Scrappable
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Scrappable._({
    this.id,
    required this.name,
    required this.description,
    required this.scrappingRules,
    required this.isActive,
    this.targetRequest,
    required this.targetRequestId,
    required this.testData,
  });

  factory Scrappable({
    int? id,
    required String name,
    required String description,
    required String scrappingRules,
    required bool isActive,
    _i2.ScrappableTargetRequestStructure? targetRequest,
    required int targetRequestId,
    required _i3.ReferenceTestData testData,
  }) = _ScrappableImpl;

  factory Scrappable.fromJson(Map<String, dynamic> jsonSerialization) {
    return Scrappable(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      scrappingRules: jsonSerialization['scrappingRules'] as String,
      isActive: jsonSerialization['isActive'] as bool,
      targetRequest: jsonSerialization['targetRequest'] == null
          ? null
          : _i2.ScrappableTargetRequestStructure.fromJson(
              (jsonSerialization['targetRequest'] as Map<String, dynamic>)),
      targetRequestId: jsonSerialization['targetRequestId'] as int,
      testData: _i3.ReferenceTestData.fromJson(
          (jsonSerialization['testData'] as Map<String, dynamic>)),
    );
  }

  static final t = ScrappableTable();

  static const db = ScrappableRepository._();

  @override
  int? id;

  String name;

  String description;

  String scrappingRules;

  bool isActive;

  _i2.ScrappableTargetRequestStructure? targetRequest;

  int targetRequestId;

  _i3.ReferenceTestData testData;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Scrappable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Scrappable copyWith({
    int? id,
    String? name,
    String? description,
    String? scrappingRules,
    bool? isActive,
    _i2.ScrappableTargetRequestStructure? targetRequest,
    int? targetRequestId,
    _i3.ReferenceTestData? testData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'scrappingRules': scrappingRules,
      'isActive': isActive,
      if (targetRequest != null) 'targetRequest': targetRequest?.toJson(),
      'targetRequestId': targetRequestId,
      'testData': testData.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'scrappingRules': scrappingRules,
      'isActive': isActive,
      if (targetRequest != null)
        'targetRequest': targetRequest?.toJsonForProtocol(),
      'targetRequestId': targetRequestId,
      'testData': testData.toJsonForProtocol(),
    };
  }

  static ScrappableInclude include(
      {_i2.ScrappableTargetRequestStructureInclude? targetRequest}) {
    return ScrappableInclude._(targetRequest: targetRequest);
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
    int? id,
    required String name,
    required String description,
    required String scrappingRules,
    required bool isActive,
    _i2.ScrappableTargetRequestStructure? targetRequest,
    required int targetRequestId,
    required _i3.ReferenceTestData testData,
  }) : super._(
          id: id,
          name: name,
          description: description,
          scrappingRules: scrappingRules,
          isActive: isActive,
          targetRequest: targetRequest,
          targetRequestId: targetRequestId,
          testData: testData,
        );

  /// Returns a shallow copy of this [Scrappable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Scrappable copyWith({
    Object? id = _Undefined,
    String? name,
    String? description,
    String? scrappingRules,
    bool? isActive,
    Object? targetRequest = _Undefined,
    int? targetRequestId,
    _i3.ReferenceTestData? testData,
  }) {
    return Scrappable(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      scrappingRules: scrappingRules ?? this.scrappingRules,
      isActive: isActive ?? this.isActive,
      targetRequest: targetRequest is _i2.ScrappableTargetRequestStructure?
          ? targetRequest
          : this.targetRequest?.copyWith(),
      targetRequestId: targetRequestId ?? this.targetRequestId,
      testData: testData ?? this.testData.copyWith(),
    );
  }
}

class ScrappableTable extends _i1.Table<int?> {
  ScrappableTable({super.tableRelation}) : super(tableName: 'scrappable') {
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
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
    targetRequestId = _i1.ColumnInt(
      'targetRequestId',
      this,
    );
    testData = _i1.ColumnSerializable(
      'testData',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnString scrappingRules;

  late final _i1.ColumnBool isActive;

  _i2.ScrappableTargetRequestStructureTable? _targetRequest;

  late final _i1.ColumnInt targetRequestId;

  late final _i1.ColumnSerializable testData;

  _i2.ScrappableTargetRequestStructureTable get targetRequest {
    if (_targetRequest != null) return _targetRequest!;
    _targetRequest = _i1.createRelationTable(
      relationFieldName: 'targetRequest',
      field: Scrappable.t.targetRequestId,
      foreignField: _i2.ScrappableTargetRequestStructure.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ScrappableTargetRequestStructureTable(
              tableRelation: foreignTableRelation),
    );
    return _targetRequest!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        description,
        scrappingRules,
        isActive,
        targetRequestId,
        testData,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'targetRequest') {
      return targetRequest;
    }
    return null;
  }
}

class ScrappableInclude extends _i1.IncludeObject {
  ScrappableInclude._(
      {_i2.ScrappableTargetRequestStructureInclude? targetRequest}) {
    _targetRequest = targetRequest;
  }

  _i2.ScrappableTargetRequestStructureInclude? _targetRequest;

  @override
  Map<String, _i1.Include?> get includes => {'targetRequest': _targetRequest};

  @override
  _i1.Table<int?> get table => Scrappable.t;
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
  _i1.Table<int?> get table => Scrappable.t;
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
    int id, {
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

  /// Creates a relation between the given [Scrappable] and [ScrappableTargetRequestStructure]
  /// by setting the [Scrappable]'s foreign key `targetRequestId` to refer to the [ScrappableTargetRequestStructure].
  Future<void> targetRequest(
    _i1.Session session,
    Scrappable scrappable,
    _i2.ScrappableTargetRequestStructure targetRequest, {
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
}
