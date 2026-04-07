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

/// Record of a battle between two creatures.
abstract class BattleRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  BattleRecord._({
    this.id,
    required this.attackerUserId,
    required this.defenderUserId,
    required this.attackerCreatureId,
    required this.defenderCreatureId,
    this.winnerUserId,
    required this.battleType,
    this.tournamentId,
    required this.rounds,
    required this.attackerXpGained,
    required this.defenderXpGained,
    required this.satoshisAwarded,
    this.battleLog,
    required this.createdAt,
  });

  factory BattleRecord({
    int? id,
    required int attackerUserId,
    required int defenderUserId,
    required int attackerCreatureId,
    required int defenderCreatureId,
    int? winnerUserId,
    required String battleType,
    int? tournamentId,
    required int rounds,
    required int attackerXpGained,
    required int defenderXpGained,
    required int satoshisAwarded,
    String? battleLog,
    required DateTime createdAt,
  }) = _BattleRecordImpl;

  factory BattleRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return BattleRecord(
      id: jsonSerialization['id'] as int?,
      attackerUserId: jsonSerialization['attackerUserId'] as int,
      defenderUserId: jsonSerialization['defenderUserId'] as int,
      attackerCreatureId: jsonSerialization['attackerCreatureId'] as int,
      defenderCreatureId: jsonSerialization['defenderCreatureId'] as int,
      winnerUserId: jsonSerialization['winnerUserId'] as int?,
      battleType: jsonSerialization['battleType'] as String,
      tournamentId: jsonSerialization['tournamentId'] as int?,
      rounds: jsonSerialization['rounds'] as int,
      attackerXpGained: jsonSerialization['attackerXpGained'] as int,
      defenderXpGained: jsonSerialization['defenderXpGained'] as int,
      satoshisAwarded: jsonSerialization['satoshisAwarded'] as int,
      battleLog: jsonSerialization['battleLog'] as String?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = BattleRecordTable();

  static const db = BattleRecordRepository._();

  @override
  int? id;

  /// The attacking/initiating user.
  int attackerUserId;

  /// The defending user.
  int defenderUserId;

  /// The attacking creature.
  int attackerCreatureId;

  /// The defending creature.
  int defenderCreatureId;

  /// ID of the winning user (null for draw).
  int? winnerUserId;

  /// Type: 'arena' or 'tournament'.
  String battleType;

  /// Tournament ID if this was a tournament battle.
  int? tournamentId;

  /// Total rounds fought.
  int rounds;

  /// XP awarded to attacker.
  int attackerXpGained;

  /// XP awarded to defender.
  int defenderXpGained;

  /// Satoshis awarded to winner.
  int satoshisAwarded;

  /// JSON log of the battle.
  String? battleLog;

  /// Timestamp of the battle.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [BattleRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BattleRecord copyWith({
    int? id,
    int? attackerUserId,
    int? defenderUserId,
    int? attackerCreatureId,
    int? defenderCreatureId,
    int? winnerUserId,
    String? battleType,
    int? tournamentId,
    int? rounds,
    int? attackerXpGained,
    int? defenderXpGained,
    int? satoshisAwarded,
    String? battleLog,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'attackerUserId': attackerUserId,
      'defenderUserId': defenderUserId,
      'attackerCreatureId': attackerCreatureId,
      'defenderCreatureId': defenderCreatureId,
      if (winnerUserId != null) 'winnerUserId': winnerUserId,
      'battleType': battleType,
      if (tournamentId != null) 'tournamentId': tournamentId,
      'rounds': rounds,
      'attackerXpGained': attackerXpGained,
      'defenderXpGained': defenderXpGained,
      'satoshisAwarded': satoshisAwarded,
      if (battleLog != null) 'battleLog': battleLog,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'attackerUserId': attackerUserId,
      'defenderUserId': defenderUserId,
      'attackerCreatureId': attackerCreatureId,
      'defenderCreatureId': defenderCreatureId,
      if (winnerUserId != null) 'winnerUserId': winnerUserId,
      'battleType': battleType,
      if (tournamentId != null) 'tournamentId': tournamentId,
      'rounds': rounds,
      'attackerXpGained': attackerXpGained,
      'defenderXpGained': defenderXpGained,
      'satoshisAwarded': satoshisAwarded,
      if (battleLog != null) 'battleLog': battleLog,
      'createdAt': createdAt.toJson(),
    };
  }

  static BattleRecordInclude include() {
    return BattleRecordInclude._();
  }

  static BattleRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<BattleRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BattleRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BattleRecordTable>? orderByList,
    BattleRecordInclude? include,
  }) {
    return BattleRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BattleRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BattleRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BattleRecordImpl extends BattleRecord {
  _BattleRecordImpl({
    int? id,
    required int attackerUserId,
    required int defenderUserId,
    required int attackerCreatureId,
    required int defenderCreatureId,
    int? winnerUserId,
    required String battleType,
    int? tournamentId,
    required int rounds,
    required int attackerXpGained,
    required int defenderXpGained,
    required int satoshisAwarded,
    String? battleLog,
    required DateTime createdAt,
  }) : super._(
          id: id,
          attackerUserId: attackerUserId,
          defenderUserId: defenderUserId,
          attackerCreatureId: attackerCreatureId,
          defenderCreatureId: defenderCreatureId,
          winnerUserId: winnerUserId,
          battleType: battleType,
          tournamentId: tournamentId,
          rounds: rounds,
          attackerXpGained: attackerXpGained,
          defenderXpGained: defenderXpGained,
          satoshisAwarded: satoshisAwarded,
          battleLog: battleLog,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [BattleRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BattleRecord copyWith({
    Object? id = _Undefined,
    int? attackerUserId,
    int? defenderUserId,
    int? attackerCreatureId,
    int? defenderCreatureId,
    Object? winnerUserId = _Undefined,
    String? battleType,
    Object? tournamentId = _Undefined,
    int? rounds,
    int? attackerXpGained,
    int? defenderXpGained,
    int? satoshisAwarded,
    Object? battleLog = _Undefined,
    DateTime? createdAt,
  }) {
    return BattleRecord(
      id: id is int? ? id : this.id,
      attackerUserId: attackerUserId ?? this.attackerUserId,
      defenderUserId: defenderUserId ?? this.defenderUserId,
      attackerCreatureId: attackerCreatureId ?? this.attackerCreatureId,
      defenderCreatureId: defenderCreatureId ?? this.defenderCreatureId,
      winnerUserId: winnerUserId is int? ? winnerUserId : this.winnerUserId,
      battleType: battleType ?? this.battleType,
      tournamentId: tournamentId is int? ? tournamentId : this.tournamentId,
      rounds: rounds ?? this.rounds,
      attackerXpGained: attackerXpGained ?? this.attackerXpGained,
      defenderXpGained: defenderXpGained ?? this.defenderXpGained,
      satoshisAwarded: satoshisAwarded ?? this.satoshisAwarded,
      battleLog: battleLog is String? ? battleLog : this.battleLog,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class BattleRecordTable extends _i1.Table<int?> {
  BattleRecordTable({super.tableRelation})
      : super(tableName: 'battle_records') {
    attackerUserId = _i1.ColumnInt(
      'attackerUserId',
      this,
    );
    defenderUserId = _i1.ColumnInt(
      'defenderUserId',
      this,
    );
    attackerCreatureId = _i1.ColumnInt(
      'attackerCreatureId',
      this,
    );
    defenderCreatureId = _i1.ColumnInt(
      'defenderCreatureId',
      this,
    );
    winnerUserId = _i1.ColumnInt(
      'winnerUserId',
      this,
    );
    battleType = _i1.ColumnString(
      'battleType',
      this,
    );
    tournamentId = _i1.ColumnInt(
      'tournamentId',
      this,
    );
    rounds = _i1.ColumnInt(
      'rounds',
      this,
    );
    attackerXpGained = _i1.ColumnInt(
      'attackerXpGained',
      this,
    );
    defenderXpGained = _i1.ColumnInt(
      'defenderXpGained',
      this,
    );
    satoshisAwarded = _i1.ColumnInt(
      'satoshisAwarded',
      this,
    );
    battleLog = _i1.ColumnString(
      'battleLog',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  /// The attacking/initiating user.
  late final _i1.ColumnInt attackerUserId;

  /// The defending user.
  late final _i1.ColumnInt defenderUserId;

  /// The attacking creature.
  late final _i1.ColumnInt attackerCreatureId;

  /// The defending creature.
  late final _i1.ColumnInt defenderCreatureId;

  /// ID of the winning user (null for draw).
  late final _i1.ColumnInt winnerUserId;

  /// Type: 'arena' or 'tournament'.
  late final _i1.ColumnString battleType;

  /// Tournament ID if this was a tournament battle.
  late final _i1.ColumnInt tournamentId;

  /// Total rounds fought.
  late final _i1.ColumnInt rounds;

  /// XP awarded to attacker.
  late final _i1.ColumnInt attackerXpGained;

  /// XP awarded to defender.
  late final _i1.ColumnInt defenderXpGained;

  /// Satoshis awarded to winner.
  late final _i1.ColumnInt satoshisAwarded;

  /// JSON log of the battle.
  late final _i1.ColumnString battleLog;

  /// Timestamp of the battle.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
        id,
        attackerUserId,
        defenderUserId,
        attackerCreatureId,
        defenderCreatureId,
        winnerUserId,
        battleType,
        tournamentId,
        rounds,
        attackerXpGained,
        defenderXpGained,
        satoshisAwarded,
        battleLog,
        createdAt,
      ];
}

class BattleRecordInclude extends _i1.IncludeObject {
  BattleRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BattleRecord.t;
}

class BattleRecordIncludeList extends _i1.IncludeList {
  BattleRecordIncludeList._({
    _i1.WhereExpressionBuilder<BattleRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BattleRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BattleRecord.t;
}

class BattleRecordRepository {
  const BattleRecordRepository._();

  /// Returns a list of [BattleRecord]s matching the given query parameters.
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
  Future<List<BattleRecord>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BattleRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BattleRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BattleRecordTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BattleRecord>(
      where: where?.call(BattleRecord.t),
      orderBy: orderBy?.call(BattleRecord.t),
      orderByList: orderByList?.call(BattleRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BattleRecord] matching the given query parameters.
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
  Future<BattleRecord?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BattleRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<BattleRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BattleRecordTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BattleRecord>(
      where: where?.call(BattleRecord.t),
      orderBy: orderBy?.call(BattleRecord.t),
      orderByList: orderByList?.call(BattleRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BattleRecord] by its [id] or null if no such row exists.
  Future<BattleRecord?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BattleRecord>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BattleRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [BattleRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BattleRecord>> insert(
    _i1.Session session,
    List<BattleRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BattleRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BattleRecord] and returns the inserted row.
  ///
  /// The returned [BattleRecord] will have its `id` field set.
  Future<BattleRecord> insertRow(
    _i1.Session session,
    BattleRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BattleRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BattleRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BattleRecord>> update(
    _i1.Session session,
    List<BattleRecord> rows, {
    _i1.ColumnSelections<BattleRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BattleRecord>(
      rows,
      columns: columns?.call(BattleRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BattleRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BattleRecord> updateRow(
    _i1.Session session,
    BattleRecord row, {
    _i1.ColumnSelections<BattleRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BattleRecord>(
      row,
      columns: columns?.call(BattleRecord.t),
      transaction: transaction,
    );
  }

  /// Deletes all [BattleRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BattleRecord>> delete(
    _i1.Session session,
    List<BattleRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BattleRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BattleRecord].
  Future<BattleRecord> deleteRow(
    _i1.Session session,
    BattleRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BattleRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BattleRecord>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BattleRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BattleRecord>(
      where: where(BattleRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BattleRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BattleRecord>(
      where: where?.call(BattleRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
