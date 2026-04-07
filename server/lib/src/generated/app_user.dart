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

/// A registered user of the Tamagotchi app.
abstract class AppUser
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AppUser._({
    this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.xp,
    required this.level,
    required this.eloRating,
    required this.walletBalanceSat,
    required this.totalWins,
    required this.totalLosses,
    required this.isActive,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory AppUser({
    int? id,
    required String username,
    required String email,
    required String passwordHash,
    required int xp,
    required int level,
    required int eloRating,
    required int walletBalanceSat,
    required int totalWins,
    required int totalLosses,
    required bool isActive,
    required DateTime createdAt,
    DateTime? lastLoginAt,
  }) = _AppUserImpl;

  factory AppUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUser(
      id: jsonSerialization['id'] as int?,
      username: jsonSerialization['username'] as String,
      email: jsonSerialization['email'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
      xp: jsonSerialization['xp'] as int,
      level: jsonSerialization['level'] as int,
      eloRating: jsonSerialization['eloRating'] as int,
      walletBalanceSat: jsonSerialization['walletBalanceSat'] as int,
      totalWins: jsonSerialization['totalWins'] as int,
      totalLosses: jsonSerialization['totalLosses'] as int,
      isActive: jsonSerialization['isActive'] as bool,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      lastLoginAt: jsonSerialization['lastLoginAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastLoginAt']),
    );
  }

  static final t = AppUserTable();

  static const db = AppUserRepository._();

  @override
  int? id;

  /// Unique username chosen by the user.
  String username;

  /// Email address for login and notifications.
  String email;

  /// BCrypt-hashed password.
  String passwordHash;

  /// User experience points earned through battles and tournaments.
  int xp;

  /// User level calculated from XP.
  int level;

  /// ELO rating for arena matchmaking.
  int eloRating;

  /// Wallet balance in Satoshis.
  int walletBalanceSat;

  /// Total arena wins.
  int totalWins;

  /// Total arena losses.
  int totalLosses;

  /// Whether the account is active.
  bool isActive;

  /// Timestamp of account creation.
  DateTime createdAt;

  /// Timestamp of last login.
  DateTime? lastLoginAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppUser copyWith({
    int? id,
    String? username,
    String? email,
    String? passwordHash,
    int? xp,
    int? level,
    int? eloRating,
    int? walletBalanceSat,
    int? totalWins,
    int? totalLosses,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'email': email,
      'passwordHash': passwordHash,
      'xp': xp,
      'level': level,
      'eloRating': eloRating,
      'walletBalanceSat': walletBalanceSat,
      'totalWins': totalWins,
      'totalLosses': totalLosses,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'email': email,
      'passwordHash': passwordHash,
      'xp': xp,
      'level': level,
      'eloRating': eloRating,
      'walletBalanceSat': walletBalanceSat,
      'totalWins': totalWins,
      'totalLosses': totalLosses,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
    };
  }

  static AppUserInclude include() {
    return AppUserInclude._();
  }

  static AppUserIncludeList includeList({
    _i1.WhereExpressionBuilder<AppUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppUserTable>? orderByList,
    AppUserInclude? include,
  }) {
    return AppUserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppUser.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AppUser.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppUserImpl extends AppUser {
  _AppUserImpl({
    int? id,
    required String username,
    required String email,
    required String passwordHash,
    required int xp,
    required int level,
    required int eloRating,
    required int walletBalanceSat,
    required int totalWins,
    required int totalLosses,
    required bool isActive,
    required DateTime createdAt,
    DateTime? lastLoginAt,
  }) : super._(
          id: id,
          username: username,
          email: email,
          passwordHash: passwordHash,
          xp: xp,
          level: level,
          eloRating: eloRating,
          walletBalanceSat: walletBalanceSat,
          totalWins: totalWins,
          totalLosses: totalLosses,
          isActive: isActive,
          createdAt: createdAt,
          lastLoginAt: lastLoginAt,
        );

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppUser copyWith({
    Object? id = _Undefined,
    String? username,
    String? email,
    String? passwordHash,
    int? xp,
    int? level,
    int? eloRating,
    int? walletBalanceSat,
    int? totalWins,
    int? totalLosses,
    bool? isActive,
    DateTime? createdAt,
    Object? lastLoginAt = _Undefined,
  }) {
    return AppUser(
      id: id is int? ? id : this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      eloRating: eloRating ?? this.eloRating,
      walletBalanceSat: walletBalanceSat ?? this.walletBalanceSat,
      totalWins: totalWins ?? this.totalWins,
      totalLosses: totalLosses ?? this.totalLosses,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt is DateTime? ? lastLoginAt : this.lastLoginAt,
    );
  }
}

class AppUserTable extends _i1.Table<int?> {
  AppUserTable({super.tableRelation}) : super(tableName: 'app_users') {
    username = _i1.ColumnString(
      'username',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    passwordHash = _i1.ColumnString(
      'passwordHash',
      this,
    );
    xp = _i1.ColumnInt(
      'xp',
      this,
    );
    level = _i1.ColumnInt(
      'level',
      this,
    );
    eloRating = _i1.ColumnInt(
      'eloRating',
      this,
    );
    walletBalanceSat = _i1.ColumnInt(
      'walletBalanceSat',
      this,
    );
    totalWins = _i1.ColumnInt(
      'totalWins',
      this,
    );
    totalLosses = _i1.ColumnInt(
      'totalLosses',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    lastLoginAt = _i1.ColumnDateTime(
      'lastLoginAt',
      this,
    );
  }

  /// Unique username chosen by the user.
  late final _i1.ColumnString username;

  /// Email address for login and notifications.
  late final _i1.ColumnString email;

  /// BCrypt-hashed password.
  late final _i1.ColumnString passwordHash;

  /// User experience points earned through battles and tournaments.
  late final _i1.ColumnInt xp;

  /// User level calculated from XP.
  late final _i1.ColumnInt level;

  /// ELO rating for arena matchmaking.
  late final _i1.ColumnInt eloRating;

  /// Wallet balance in Satoshis.
  late final _i1.ColumnInt walletBalanceSat;

  /// Total arena wins.
  late final _i1.ColumnInt totalWins;

  /// Total arena losses.
  late final _i1.ColumnInt totalLosses;

  /// Whether the account is active.
  late final _i1.ColumnBool isActive;

  /// Timestamp of account creation.
  late final _i1.ColumnDateTime createdAt;

  /// Timestamp of last login.
  late final _i1.ColumnDateTime lastLoginAt;

  @override
  List<_i1.Column> get columns => [
        id,
        username,
        email,
        passwordHash,
        xp,
        level,
        eloRating,
        walletBalanceSat,
        totalWins,
        totalLosses,
        isActive,
        createdAt,
        lastLoginAt,
      ];
}

class AppUserInclude extends _i1.IncludeObject {
  AppUserInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AppUser.t;
}

class AppUserIncludeList extends _i1.IncludeList {
  AppUserIncludeList._({
    _i1.WhereExpressionBuilder<AppUserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppUser.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AppUser.t;
}

class AppUserRepository {
  const AppUserRepository._();

  /// Returns a list of [AppUser]s matching the given query parameters.
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
  Future<List<AppUser>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppUserTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AppUser>(
      where: where?.call(AppUser.t),
      orderBy: orderBy?.call(AppUser.t),
      orderByList: orderByList?.call(AppUser.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AppUser] matching the given query parameters.
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
  Future<AppUser?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppUserTable>? where,
    int? offset,
    _i1.OrderByBuilder<AppUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppUserTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AppUser>(
      where: where?.call(AppUser.t),
      orderBy: orderBy?.call(AppUser.t),
      orderByList: orderByList?.call(AppUser.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AppUser] by its [id] or null if no such row exists.
  Future<AppUser?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AppUser>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AppUser]s in the list and returns the inserted rows.
  ///
  /// The returned [AppUser]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AppUser>> insert(
    _i1.Session session,
    List<AppUser> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AppUser>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AppUser] and returns the inserted row.
  ///
  /// The returned [AppUser] will have its `id` field set.
  Future<AppUser> insertRow(
    _i1.Session session,
    AppUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppUser>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AppUser]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AppUser>> update(
    _i1.Session session,
    List<AppUser> rows, {
    _i1.ColumnSelections<AppUserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AppUser>(
      rows,
      columns: columns?.call(AppUser.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppUser]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppUser> updateRow(
    _i1.Session session,
    AppUser row, {
    _i1.ColumnSelections<AppUserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppUser>(
      row,
      columns: columns?.call(AppUser.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AppUser]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AppUser>> delete(
    _i1.Session session,
    List<AppUser> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AppUser>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AppUser].
  Future<AppUser> deleteRow(
    _i1.Session session,
    AppUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppUser>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AppUser>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AppUserTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AppUser>(
      where: where(AppUser.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppUserTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AppUser>(
      where: where?.call(AppUser.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
