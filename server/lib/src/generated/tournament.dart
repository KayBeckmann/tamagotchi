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

/// A tournament where creatures battle for Bitcoin prizes.
abstract class Tournament
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Tournament._({
    this.id,
    required this.name,
    required this.format,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.entryFeeSat,
    required this.prizePoolSat,
    required this.feePercent,
    required this.status,
    this.winnerUserId,
    required this.roundTimeMinutes,
    required this.currentRound,
    required this.registrationEndsAt,
    required this.startsAt,
    required this.createdAt,
  });

  factory Tournament({
    int? id,
    required String name,
    required String format,
    required int maxParticipants,
    required int currentParticipants,
    required int entryFeeSat,
    required int prizePoolSat,
    required double feePercent,
    required String status,
    int? winnerUserId,
    required int roundTimeMinutes,
    required int currentRound,
    required DateTime registrationEndsAt,
    required DateTime startsAt,
    required DateTime createdAt,
  }) = _TournamentImpl;

  factory Tournament.fromJson(Map<String, dynamic> jsonSerialization) {
    return Tournament(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      format: jsonSerialization['format'] as String,
      maxParticipants: jsonSerialization['maxParticipants'] as int,
      currentParticipants: jsonSerialization['currentParticipants'] as int,
      entryFeeSat: jsonSerialization['entryFeeSat'] as int,
      prizePoolSat: jsonSerialization['prizePoolSat'] as int,
      feePercent: (jsonSerialization['feePercent'] as num).toDouble(),
      status: jsonSerialization['status'] as String,
      winnerUserId: jsonSerialization['winnerUserId'] as int?,
      roundTimeMinutes: jsonSerialization['roundTimeMinutes'] as int,
      currentRound: jsonSerialization['currentRound'] as int,
      registrationEndsAt: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['registrationEndsAt']),
      startsAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startsAt']),
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = TournamentTable();

  static const db = TournamentRepository._();

  @override
  int? id;

  /// Tournament name.
  String name;

  /// Tournament format: single_elimination, double_elimination, round_robin.
  String format;

  /// Maximum number of participants.
  int maxParticipants;

  /// Current number of registered participants.
  int currentParticipants;

  /// Entry fee in Satoshis.
  int entryFeeSat;

  /// Total prize pool in Satoshis.
  int prizePoolSat;

  /// Platform fee percentage (0.0 - 1.0).
  double feePercent;

  /// Status: registration, active, completed, cancelled.
  String status;

  /// ID of the winning user.
  int? winnerUserId;

  /// Time window per round in minutes.
  int roundTimeMinutes;

  /// Current round number.
  int currentRound;

  /// Registration deadline.
  DateTime registrationEndsAt;

  /// Tournament start time.
  DateTime startsAt;

  /// Tournament creation time.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Tournament]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Tournament copyWith({
    int? id,
    String? name,
    String? format,
    int? maxParticipants,
    int? currentParticipants,
    int? entryFeeSat,
    int? prizePoolSat,
    double? feePercent,
    String? status,
    int? winnerUserId,
    int? roundTimeMinutes,
    int? currentRound,
    DateTime? registrationEndsAt,
    DateTime? startsAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'format': format,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'entryFeeSat': entryFeeSat,
      'prizePoolSat': prizePoolSat,
      'feePercent': feePercent,
      'status': status,
      if (winnerUserId != null) 'winnerUserId': winnerUserId,
      'roundTimeMinutes': roundTimeMinutes,
      'currentRound': currentRound,
      'registrationEndsAt': registrationEndsAt.toJson(),
      'startsAt': startsAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'format': format,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'entryFeeSat': entryFeeSat,
      'prizePoolSat': prizePoolSat,
      'feePercent': feePercent,
      'status': status,
      if (winnerUserId != null) 'winnerUserId': winnerUserId,
      'roundTimeMinutes': roundTimeMinutes,
      'currentRound': currentRound,
      'registrationEndsAt': registrationEndsAt.toJson(),
      'startsAt': startsAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static TournamentInclude include() {
    return TournamentInclude._();
  }

  static TournamentIncludeList includeList({
    _i1.WhereExpressionBuilder<TournamentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TournamentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TournamentTable>? orderByList,
    TournamentInclude? include,
  }) {
    return TournamentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Tournament.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Tournament.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TournamentImpl extends Tournament {
  _TournamentImpl({
    int? id,
    required String name,
    required String format,
    required int maxParticipants,
    required int currentParticipants,
    required int entryFeeSat,
    required int prizePoolSat,
    required double feePercent,
    required String status,
    int? winnerUserId,
    required int roundTimeMinutes,
    required int currentRound,
    required DateTime registrationEndsAt,
    required DateTime startsAt,
    required DateTime createdAt,
  }) : super._(
          id: id,
          name: name,
          format: format,
          maxParticipants: maxParticipants,
          currentParticipants: currentParticipants,
          entryFeeSat: entryFeeSat,
          prizePoolSat: prizePoolSat,
          feePercent: feePercent,
          status: status,
          winnerUserId: winnerUserId,
          roundTimeMinutes: roundTimeMinutes,
          currentRound: currentRound,
          registrationEndsAt: registrationEndsAt,
          startsAt: startsAt,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [Tournament]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Tournament copyWith({
    Object? id = _Undefined,
    String? name,
    String? format,
    int? maxParticipants,
    int? currentParticipants,
    int? entryFeeSat,
    int? prizePoolSat,
    double? feePercent,
    String? status,
    Object? winnerUserId = _Undefined,
    int? roundTimeMinutes,
    int? currentRound,
    DateTime? registrationEndsAt,
    DateTime? startsAt,
    DateTime? createdAt,
  }) {
    return Tournament(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      format: format ?? this.format,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      entryFeeSat: entryFeeSat ?? this.entryFeeSat,
      prizePoolSat: prizePoolSat ?? this.prizePoolSat,
      feePercent: feePercent ?? this.feePercent,
      status: status ?? this.status,
      winnerUserId: winnerUserId is int? ? winnerUserId : this.winnerUserId,
      roundTimeMinutes: roundTimeMinutes ?? this.roundTimeMinutes,
      currentRound: currentRound ?? this.currentRound,
      registrationEndsAt: registrationEndsAt ?? this.registrationEndsAt,
      startsAt: startsAt ?? this.startsAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TournamentTable extends _i1.Table<int?> {
  TournamentTable({super.tableRelation}) : super(tableName: 'tournaments') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    format = _i1.ColumnString(
      'format',
      this,
    );
    maxParticipants = _i1.ColumnInt(
      'maxParticipants',
      this,
    );
    currentParticipants = _i1.ColumnInt(
      'currentParticipants',
      this,
    );
    entryFeeSat = _i1.ColumnInt(
      'entryFeeSat',
      this,
    );
    prizePoolSat = _i1.ColumnInt(
      'prizePoolSat',
      this,
    );
    feePercent = _i1.ColumnDouble(
      'feePercent',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    winnerUserId = _i1.ColumnInt(
      'winnerUserId',
      this,
    );
    roundTimeMinutes = _i1.ColumnInt(
      'roundTimeMinutes',
      this,
    );
    currentRound = _i1.ColumnInt(
      'currentRound',
      this,
    );
    registrationEndsAt = _i1.ColumnDateTime(
      'registrationEndsAt',
      this,
    );
    startsAt = _i1.ColumnDateTime(
      'startsAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  /// Tournament name.
  late final _i1.ColumnString name;

  /// Tournament format: single_elimination, double_elimination, round_robin.
  late final _i1.ColumnString format;

  /// Maximum number of participants.
  late final _i1.ColumnInt maxParticipants;

  /// Current number of registered participants.
  late final _i1.ColumnInt currentParticipants;

  /// Entry fee in Satoshis.
  late final _i1.ColumnInt entryFeeSat;

  /// Total prize pool in Satoshis.
  late final _i1.ColumnInt prizePoolSat;

  /// Platform fee percentage (0.0 - 1.0).
  late final _i1.ColumnDouble feePercent;

  /// Status: registration, active, completed, cancelled.
  late final _i1.ColumnString status;

  /// ID of the winning user.
  late final _i1.ColumnInt winnerUserId;

  /// Time window per round in minutes.
  late final _i1.ColumnInt roundTimeMinutes;

  /// Current round number.
  late final _i1.ColumnInt currentRound;

  /// Registration deadline.
  late final _i1.ColumnDateTime registrationEndsAt;

  /// Tournament start time.
  late final _i1.ColumnDateTime startsAt;

  /// Tournament creation time.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        format,
        maxParticipants,
        currentParticipants,
        entryFeeSat,
        prizePoolSat,
        feePercent,
        status,
        winnerUserId,
        roundTimeMinutes,
        currentRound,
        registrationEndsAt,
        startsAt,
        createdAt,
      ];
}

class TournamentInclude extends _i1.IncludeObject {
  TournamentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Tournament.t;
}

class TournamentIncludeList extends _i1.IncludeList {
  TournamentIncludeList._({
    _i1.WhereExpressionBuilder<TournamentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Tournament.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Tournament.t;
}

class TournamentRepository {
  const TournamentRepository._();

  /// Returns a list of [Tournament]s matching the given query parameters.
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
  Future<List<Tournament>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TournamentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TournamentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TournamentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Tournament>(
      where: where?.call(Tournament.t),
      orderBy: orderBy?.call(Tournament.t),
      orderByList: orderByList?.call(Tournament.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Tournament] matching the given query parameters.
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
  Future<Tournament?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TournamentTable>? where,
    int? offset,
    _i1.OrderByBuilder<TournamentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TournamentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Tournament>(
      where: where?.call(Tournament.t),
      orderBy: orderBy?.call(Tournament.t),
      orderByList: orderByList?.call(Tournament.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Tournament] by its [id] or null if no such row exists.
  Future<Tournament?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Tournament>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Tournament]s in the list and returns the inserted rows.
  ///
  /// The returned [Tournament]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Tournament>> insert(
    _i1.Session session,
    List<Tournament> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Tournament>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Tournament] and returns the inserted row.
  ///
  /// The returned [Tournament] will have its `id` field set.
  Future<Tournament> insertRow(
    _i1.Session session,
    Tournament row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Tournament>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Tournament]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Tournament>> update(
    _i1.Session session,
    List<Tournament> rows, {
    _i1.ColumnSelections<TournamentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Tournament>(
      rows,
      columns: columns?.call(Tournament.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Tournament]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Tournament> updateRow(
    _i1.Session session,
    Tournament row, {
    _i1.ColumnSelections<TournamentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Tournament>(
      row,
      columns: columns?.call(Tournament.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Tournament]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Tournament>> delete(
    _i1.Session session,
    List<Tournament> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Tournament>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Tournament].
  Future<Tournament> deleteRow(
    _i1.Session session,
    Tournament row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Tournament>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Tournament>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TournamentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Tournament>(
      where: where(Tournament.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TournamentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Tournament>(
      where: where?.call(Tournament.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
