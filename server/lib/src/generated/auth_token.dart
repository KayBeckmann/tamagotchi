/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Stores refresh tokens for user sessions.
abstract class AuthToken
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AuthToken._({
    this.id,
    required this.userId,
    required this.tokenHash,
    required this.expiresAt,
    this.deviceInfo,
    required this.createdAt,
  });

  factory AuthToken({
    int? id,
    required int userId,
    required String tokenHash,
    required DateTime expiresAt,
    String? deviceInfo,
    required DateTime createdAt,
  }) = _AuthTokenImpl;

  factory AuthToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthToken(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      tokenHash: jsonSerialization['tokenHash'] as String,
      expiresAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      deviceInfo: jsonSerialization['deviceInfo'] as String?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = AuthTokenTable();

  static const db = AuthTokenRepository._();

  @override
  int? id;

  /// Reference to the user who owns this token.
  int userId;

  /// The hashed refresh token string.
  String tokenHash;

  /// When the refresh token expires.
  DateTime expiresAt;

  /// Device or client identifier.
  String? deviceInfo;

  /// Timestamp when the token was created.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AuthToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthToken copyWith({
    int? id,
    int? userId,
    String? tokenHash,
    DateTime? expiresAt,
    String? deviceInfo,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'tokenHash': tokenHash,
      'expiresAt': expiresAt.toJson(),
      if (deviceInfo != null) 'deviceInfo': deviceInfo,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'tokenHash': tokenHash,
      'expiresAt': expiresAt.toJson(),
      if (deviceInfo != null) 'deviceInfo': deviceInfo,
      'createdAt': createdAt.toJson(),
    };
  }

  static AuthTokenInclude include() {
    return AuthTokenInclude._();
  }

  static AuthTokenIncludeList includeList({
    _i1.WhereExpressionBuilder<AuthTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthTokenTable>? orderByList,
    AuthTokenInclude? include,
  }) {
    return AuthTokenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthToken.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AuthToken.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthTokenImpl extends AuthToken {
  _AuthTokenImpl({
    int? id,
    required int userId,
    required String tokenHash,
    required DateTime expiresAt,
    String? deviceInfo,
    required DateTime createdAt,
  }) : super._(
          id: id,
          userId: userId,
          tokenHash: tokenHash,
          expiresAt: expiresAt,
          deviceInfo: deviceInfo,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [AuthToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthToken copyWith({
    Object? id = _Undefined,
    int? userId,
    String? tokenHash,
    DateTime? expiresAt,
    Object? deviceInfo = _Undefined,
    DateTime? createdAt,
  }) {
    return AuthToken(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      tokenHash: tokenHash ?? this.tokenHash,
      expiresAt: expiresAt ?? this.expiresAt,
      deviceInfo: deviceInfo is String? ? deviceInfo : this.deviceInfo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AuthTokenTable extends _i1.Table<int?> {
  AuthTokenTable({super.tableRelation}) : super(tableName: 'auth_tokens') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    tokenHash = _i1.ColumnString(
      'tokenHash',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    deviceInfo = _i1.ColumnString(
      'deviceInfo',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  /// Reference to the user who owns this token.
  late final _i1.ColumnInt userId;

  /// The hashed refresh token string.
  late final _i1.ColumnString tokenHash;

  /// When the refresh token expires.
  late final _i1.ColumnDateTime expiresAt;

  /// Device or client identifier.
  late final _i1.ColumnString deviceInfo;

  /// Timestamp when the token was created.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        tokenHash,
        expiresAt,
        deviceInfo,
        createdAt,
      ];
}

class AuthTokenInclude extends _i1.IncludeObject {
  AuthTokenInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AuthToken.t;
}

class AuthTokenIncludeList extends _i1.IncludeList {
  AuthTokenIncludeList._({
    _i1.WhereExpressionBuilder<AuthTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AuthToken.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AuthToken.t;
}

class AuthTokenRepository {
  const AuthTokenRepository._();

  /// Returns a list of [AuthToken]s matching the given query parameters.
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
  Future<List<AuthToken>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AuthToken>(
      where: where?.call(AuthToken.t),
      orderBy: orderBy?.call(AuthToken.t),
      orderByList: orderByList?.call(AuthToken.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AuthToken] matching the given query parameters.
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
  Future<AuthToken?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthTokenTable>? where,
    int? offset,
    _i1.OrderByBuilder<AuthTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AuthToken>(
      where: where?.call(AuthToken.t),
      orderBy: orderBy?.call(AuthToken.t),
      orderByList: orderByList?.call(AuthToken.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AuthToken] by its [id] or null if no such row exists.
  Future<AuthToken?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AuthToken>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AuthToken]s in the list and returns the inserted rows.
  ///
  /// The returned [AuthToken]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AuthToken>> insert(
    _i1.Session session,
    List<AuthToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AuthToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AuthToken] and returns the inserted row.
  ///
  /// The returned [AuthToken] will have its `id` field set.
  Future<AuthToken> insertRow(
    _i1.Session session,
    AuthToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuthToken>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AuthToken]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AuthToken>> update(
    _i1.Session session,
    List<AuthToken> rows, {
    _i1.ColumnSelections<AuthTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AuthToken>(
      rows,
      columns: columns?.call(AuthToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuthToken]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuthToken> updateRow(
    _i1.Session session,
    AuthToken row, {
    _i1.ColumnSelections<AuthTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuthToken>(
      row,
      columns: columns?.call(AuthToken.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AuthToken]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AuthToken>> delete(
    _i1.Session session,
    List<AuthToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AuthToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AuthToken].
  Future<AuthToken> deleteRow(
    _i1.Session session,
    AuthToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuthToken>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AuthToken>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AuthTokenTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AuthToken>(
      where: where(AuthToken.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthTokenTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AuthToken>(
      where: where?.call(AuthToken.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
