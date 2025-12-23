/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../entities/ip_validation/ip_block_reason.dart' as _i2;
import 'package:zenscrap_server/src/generated/protocol.dart' as _i3;

abstract class IpValidationCache
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  IpValidationCache._({
    this.id,
    required this.ipAddress,
    required this.updatedAt,
    required this.isLegitimate,
    this.blockReason,
    this.blockReasonEnums,
    required this.isVpn,
    required this.isProxy,
    required this.isTor,
    required this.isDatacenter,
    required this.isAbuser,
    required this.isCrawler,
    required this.isMobile,
    this.companyName,
    this.companyType,
    this.countryCode,
    this.city,
  });

  factory IpValidationCache({
    int? id,
    required String ipAddress,
    required DateTime updatedAt,
    required bool isLegitimate,
    String? blockReason,
    List<_i2.IpBlockReason>? blockReasonEnums,
    required bool isVpn,
    required bool isProxy,
    required bool isTor,
    required bool isDatacenter,
    required bool isAbuser,
    required bool isCrawler,
    required bool isMobile,
    String? companyName,
    String? companyType,
    String? countryCode,
    String? city,
  }) = _IpValidationCacheImpl;

  factory IpValidationCache.fromJson(Map<String, dynamic> jsonSerialization) {
    return IpValidationCache(
      id: jsonSerialization['id'] as int?,
      ipAddress: jsonSerialization['ipAddress'] as String,
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      isLegitimate: jsonSerialization['isLegitimate'] as bool,
      blockReason: jsonSerialization['blockReason'] as String?,
      blockReasonEnums: jsonSerialization['blockReasonEnums'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.IpBlockReason>>(
              jsonSerialization['blockReasonEnums'],
            ),
      isVpn: jsonSerialization['isVpn'] as bool,
      isProxy: jsonSerialization['isProxy'] as bool,
      isTor: jsonSerialization['isTor'] as bool,
      isDatacenter: jsonSerialization['isDatacenter'] as bool,
      isAbuser: jsonSerialization['isAbuser'] as bool,
      isCrawler: jsonSerialization['isCrawler'] as bool,
      isMobile: jsonSerialization['isMobile'] as bool,
      companyName: jsonSerialization['companyName'] as String?,
      companyType: jsonSerialization['companyType'] as String?,
      countryCode: jsonSerialization['countryCode'] as String?,
      city: jsonSerialization['city'] as String?,
    );
  }

  static final t = IpValidationCacheTable();

  static const db = IpValidationCacheRepository._();

  @override
  int? id;

  String ipAddress;

  DateTime updatedAt;

  bool isLegitimate;

  String? blockReason;

  List<_i2.IpBlockReason>? blockReasonEnums;

  bool isVpn;

  bool isProxy;

  bool isTor;

  bool isDatacenter;

  bool isAbuser;

  bool isCrawler;

  bool isMobile;

  String? companyName;

  String? companyType;

  String? countryCode;

  String? city;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [IpValidationCache]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IpValidationCache copyWith({
    int? id,
    String? ipAddress,
    DateTime? updatedAt,
    bool? isLegitimate,
    String? blockReason,
    List<_i2.IpBlockReason>? blockReasonEnums,
    bool? isVpn,
    bool? isProxy,
    bool? isTor,
    bool? isDatacenter,
    bool? isAbuser,
    bool? isCrawler,
    bool? isMobile,
    String? companyName,
    String? companyType,
    String? countryCode,
    String? city,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IpValidationCache',
      if (id != null) 'id': id,
      'ipAddress': ipAddress,
      'updatedAt': updatedAt.toJson(),
      'isLegitimate': isLegitimate,
      if (blockReason != null) 'blockReason': blockReason,
      if (blockReasonEnums != null)
        'blockReasonEnums': blockReasonEnums?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'isVpn': isVpn,
      'isProxy': isProxy,
      'isTor': isTor,
      'isDatacenter': isDatacenter,
      'isAbuser': isAbuser,
      'isCrawler': isCrawler,
      'isMobile': isMobile,
      if (companyName != null) 'companyName': companyName,
      if (companyType != null) 'companyType': companyType,
      if (countryCode != null) 'countryCode': countryCode,
      if (city != null) 'city': city,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IpValidationCache',
      if (id != null) 'id': id,
      'ipAddress': ipAddress,
      'updatedAt': updatedAt.toJson(),
      'isLegitimate': isLegitimate,
      if (blockReason != null) 'blockReason': blockReason,
      if (blockReasonEnums != null)
        'blockReasonEnums': blockReasonEnums?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'isVpn': isVpn,
      'isProxy': isProxy,
      'isTor': isTor,
      'isDatacenter': isDatacenter,
      'isAbuser': isAbuser,
      'isCrawler': isCrawler,
      'isMobile': isMobile,
      if (companyName != null) 'companyName': companyName,
      if (companyType != null) 'companyType': companyType,
      if (countryCode != null) 'countryCode': countryCode,
      if (city != null) 'city': city,
    };
  }

  static IpValidationCacheInclude include() {
    return IpValidationCacheInclude._();
  }

  static IpValidationCacheIncludeList includeList({
    _i1.WhereExpressionBuilder<IpValidationCacheTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IpValidationCacheTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IpValidationCacheTable>? orderByList,
    IpValidationCacheInclude? include,
  }) {
    return IpValidationCacheIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IpValidationCache.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(IpValidationCache.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IpValidationCacheImpl extends IpValidationCache {
  _IpValidationCacheImpl({
    int? id,
    required String ipAddress,
    required DateTime updatedAt,
    required bool isLegitimate,
    String? blockReason,
    List<_i2.IpBlockReason>? blockReasonEnums,
    required bool isVpn,
    required bool isProxy,
    required bool isTor,
    required bool isDatacenter,
    required bool isAbuser,
    required bool isCrawler,
    required bool isMobile,
    String? companyName,
    String? companyType,
    String? countryCode,
    String? city,
  }) : super._(
         id: id,
         ipAddress: ipAddress,
         updatedAt: updatedAt,
         isLegitimate: isLegitimate,
         blockReason: blockReason,
         blockReasonEnums: blockReasonEnums,
         isVpn: isVpn,
         isProxy: isProxy,
         isTor: isTor,
         isDatacenter: isDatacenter,
         isAbuser: isAbuser,
         isCrawler: isCrawler,
         isMobile: isMobile,
         companyName: companyName,
         companyType: companyType,
         countryCode: countryCode,
         city: city,
       );

  /// Returns a shallow copy of this [IpValidationCache]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IpValidationCache copyWith({
    Object? id = _Undefined,
    String? ipAddress,
    DateTime? updatedAt,
    bool? isLegitimate,
    Object? blockReason = _Undefined,
    Object? blockReasonEnums = _Undefined,
    bool? isVpn,
    bool? isProxy,
    bool? isTor,
    bool? isDatacenter,
    bool? isAbuser,
    bool? isCrawler,
    bool? isMobile,
    Object? companyName = _Undefined,
    Object? companyType = _Undefined,
    Object? countryCode = _Undefined,
    Object? city = _Undefined,
  }) {
    return IpValidationCache(
      id: id is int? ? id : this.id,
      ipAddress: ipAddress ?? this.ipAddress,
      updatedAt: updatedAt ?? this.updatedAt,
      isLegitimate: isLegitimate ?? this.isLegitimate,
      blockReason: blockReason is String? ? blockReason : this.blockReason,
      blockReasonEnums: blockReasonEnums is List<_i2.IpBlockReason>?
          ? blockReasonEnums
          : this.blockReasonEnums?.map((e0) => e0).toList(),
      isVpn: isVpn ?? this.isVpn,
      isProxy: isProxy ?? this.isProxy,
      isTor: isTor ?? this.isTor,
      isDatacenter: isDatacenter ?? this.isDatacenter,
      isAbuser: isAbuser ?? this.isAbuser,
      isCrawler: isCrawler ?? this.isCrawler,
      isMobile: isMobile ?? this.isMobile,
      companyName: companyName is String? ? companyName : this.companyName,
      companyType: companyType is String? ? companyType : this.companyType,
      countryCode: countryCode is String? ? countryCode : this.countryCode,
      city: city is String? ? city : this.city,
    );
  }
}

class IpValidationCacheUpdateTable
    extends _i1.UpdateTable<IpValidationCacheTable> {
  IpValidationCacheUpdateTable(super.table);

  _i1.ColumnValue<String, String> ipAddress(String value) => _i1.ColumnValue(
    table.ipAddress,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );

  _i1.ColumnValue<bool, bool> isLegitimate(bool value) => _i1.ColumnValue(
    table.isLegitimate,
    value,
  );

  _i1.ColumnValue<String, String> blockReason(String? value) => _i1.ColumnValue(
    table.blockReason,
    value,
  );

  _i1.ColumnValue<List<_i2.IpBlockReason>, List<_i2.IpBlockReason>>
  blockReasonEnums(List<_i2.IpBlockReason>? value) => _i1.ColumnValue(
    table.blockReasonEnums,
    value,
  );

  _i1.ColumnValue<bool, bool> isVpn(bool value) => _i1.ColumnValue(
    table.isVpn,
    value,
  );

  _i1.ColumnValue<bool, bool> isProxy(bool value) => _i1.ColumnValue(
    table.isProxy,
    value,
  );

  _i1.ColumnValue<bool, bool> isTor(bool value) => _i1.ColumnValue(
    table.isTor,
    value,
  );

  _i1.ColumnValue<bool, bool> isDatacenter(bool value) => _i1.ColumnValue(
    table.isDatacenter,
    value,
  );

  _i1.ColumnValue<bool, bool> isAbuser(bool value) => _i1.ColumnValue(
    table.isAbuser,
    value,
  );

  _i1.ColumnValue<bool, bool> isCrawler(bool value) => _i1.ColumnValue(
    table.isCrawler,
    value,
  );

  _i1.ColumnValue<bool, bool> isMobile(bool value) => _i1.ColumnValue(
    table.isMobile,
    value,
  );

  _i1.ColumnValue<String, String> companyName(String? value) => _i1.ColumnValue(
    table.companyName,
    value,
  );

  _i1.ColumnValue<String, String> companyType(String? value) => _i1.ColumnValue(
    table.companyType,
    value,
  );

  _i1.ColumnValue<String, String> countryCode(String? value) => _i1.ColumnValue(
    table.countryCode,
    value,
  );

  _i1.ColumnValue<String, String> city(String? value) => _i1.ColumnValue(
    table.city,
    value,
  );
}

class IpValidationCacheTable extends _i1.Table<int?> {
  IpValidationCacheTable({super.tableRelation})
    : super(tableName: 'ip_validation_cache') {
    updateTable = IpValidationCacheUpdateTable(this);
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
    isLegitimate = _i1.ColumnBool(
      'isLegitimate',
      this,
    );
    blockReason = _i1.ColumnString(
      'blockReason',
      this,
    );
    blockReasonEnums = _i1.ColumnSerializable<List<_i2.IpBlockReason>>(
      'blockReasonEnums',
      this,
    );
    isVpn = _i1.ColumnBool(
      'isVpn',
      this,
    );
    isProxy = _i1.ColumnBool(
      'isProxy',
      this,
    );
    isTor = _i1.ColumnBool(
      'isTor',
      this,
    );
    isDatacenter = _i1.ColumnBool(
      'isDatacenter',
      this,
    );
    isAbuser = _i1.ColumnBool(
      'isAbuser',
      this,
    );
    isCrawler = _i1.ColumnBool(
      'isCrawler',
      this,
    );
    isMobile = _i1.ColumnBool(
      'isMobile',
      this,
    );
    companyName = _i1.ColumnString(
      'companyName',
      this,
    );
    companyType = _i1.ColumnString(
      'companyType',
      this,
    );
    countryCode = _i1.ColumnString(
      'countryCode',
      this,
    );
    city = _i1.ColumnString(
      'city',
      this,
    );
  }

  late final IpValidationCacheUpdateTable updateTable;

  late final _i1.ColumnString ipAddress;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnBool isLegitimate;

  late final _i1.ColumnString blockReason;

  late final _i1.ColumnSerializable<List<_i2.IpBlockReason>> blockReasonEnums;

  late final _i1.ColumnBool isVpn;

  late final _i1.ColumnBool isProxy;

  late final _i1.ColumnBool isTor;

  late final _i1.ColumnBool isDatacenter;

  late final _i1.ColumnBool isAbuser;

  late final _i1.ColumnBool isCrawler;

  late final _i1.ColumnBool isMobile;

  late final _i1.ColumnString companyName;

  late final _i1.ColumnString companyType;

  late final _i1.ColumnString countryCode;

  late final _i1.ColumnString city;

  @override
  List<_i1.Column> get columns => [
    id,
    ipAddress,
    updatedAt,
    isLegitimate,
    blockReason,
    blockReasonEnums,
    isVpn,
    isProxy,
    isTor,
    isDatacenter,
    isAbuser,
    isCrawler,
    isMobile,
    companyName,
    companyType,
    countryCode,
    city,
  ];
}

class IpValidationCacheInclude extends _i1.IncludeObject {
  IpValidationCacheInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => IpValidationCache.t;
}

class IpValidationCacheIncludeList extends _i1.IncludeList {
  IpValidationCacheIncludeList._({
    _i1.WhereExpressionBuilder<IpValidationCacheTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IpValidationCache.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => IpValidationCache.t;
}

class IpValidationCacheRepository {
  const IpValidationCacheRepository._();

  /// Returns a list of [IpValidationCache]s matching the given query parameters.
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
  Future<List<IpValidationCache>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IpValidationCacheTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IpValidationCacheTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IpValidationCacheTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<IpValidationCache>(
      where: where?.call(IpValidationCache.t),
      orderBy: orderBy?.call(IpValidationCache.t),
      orderByList: orderByList?.call(IpValidationCache.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [IpValidationCache] matching the given query parameters.
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
  Future<IpValidationCache?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IpValidationCacheTable>? where,
    int? offset,
    _i1.OrderByBuilder<IpValidationCacheTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IpValidationCacheTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<IpValidationCache>(
      where: where?.call(IpValidationCache.t),
      orderBy: orderBy?.call(IpValidationCache.t),
      orderByList: orderByList?.call(IpValidationCache.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [IpValidationCache] by its [id] or null if no such row exists.
  Future<IpValidationCache?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<IpValidationCache>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [IpValidationCache]s in the list and returns the inserted rows.
  ///
  /// The returned [IpValidationCache]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<IpValidationCache>> insert(
    _i1.Session session,
    List<IpValidationCache> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<IpValidationCache>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [IpValidationCache] and returns the inserted row.
  ///
  /// The returned [IpValidationCache] will have its `id` field set.
  Future<IpValidationCache> insertRow(
    _i1.Session session,
    IpValidationCache row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<IpValidationCache>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [IpValidationCache]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<IpValidationCache>> update(
    _i1.Session session,
    List<IpValidationCache> rows, {
    _i1.ColumnSelections<IpValidationCacheTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<IpValidationCache>(
      rows,
      columns: columns?.call(IpValidationCache.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IpValidationCache]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IpValidationCache> updateRow(
    _i1.Session session,
    IpValidationCache row, {
    _i1.ColumnSelections<IpValidationCacheTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<IpValidationCache>(
      row,
      columns: columns?.call(IpValidationCache.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IpValidationCache] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<IpValidationCache?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<IpValidationCacheUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<IpValidationCache>(
      id,
      columnValues: columnValues(IpValidationCache.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [IpValidationCache]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<IpValidationCache>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<IpValidationCacheUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<IpValidationCacheTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IpValidationCacheTable>? orderBy,
    _i1.OrderByListBuilder<IpValidationCacheTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<IpValidationCache>(
      columnValues: columnValues(IpValidationCache.t.updateTable),
      where: where(IpValidationCache.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IpValidationCache.t),
      orderByList: orderByList?.call(IpValidationCache.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [IpValidationCache]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<IpValidationCache>> delete(
    _i1.Session session,
    List<IpValidationCache> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<IpValidationCache>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [IpValidationCache].
  Future<IpValidationCache> deleteRow(
    _i1.Session session,
    IpValidationCache row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IpValidationCache>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<IpValidationCache>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<IpValidationCacheTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<IpValidationCache>(
      where: where(IpValidationCache.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IpValidationCacheTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<IpValidationCache>(
      where: where?.call(IpValidationCache.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
