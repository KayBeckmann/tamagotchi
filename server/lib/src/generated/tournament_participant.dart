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

/// A user's participation in a tournament.
abstract class TournamentParticipant
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TournamentParticipant._({
    this.id,
    required this.tournamentId,
    required this.userId,
    required this.creatureId,
    required this.seed,
    required this.isEliminated,
    this.placement,
    required this.satoshisWon,
    required this.createdAt,
  });

  factory TournamentParticipant({
    int? id,
    required int tournamentId,
    required int userId,
    required int creatureId,
    required int seed,
    required bool isEliminated,
    int? placement,
    required int satoshisWon,
    required DateTime createdAt,
  }) = _TournamentParticipantImpl;

  factory TournamentParticipant.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return TournamentParticipant(
      id: jsonSerialization['id'] as int?,
      tournamentId: jsonSerialization['tournamentId'] as int,
      userId: jsonSerialization['userId'] as int,
      creatureId: jsonSerialization['creatureId'] as int,
      seed: jsonSerialization['seed'] as int,
      isEliminated: jsonSerialization['isEliminated'] as bool,
      placement: jsonSerialization['placement'] as int?,
      satoshisWon: jsonSerialization['satoshisWon'] as int,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = TournamentParticipantTable();

  static const db = TournamentParticipantRepository._();

  @override
  int? id;

  /// Reference to the tournament.
  int tournamentId;

  /// Reference to the participating user.
  int userId;

  /// Reference to the creature used in the tournament.
  int creatureId;

  /// Seed/position in the bracket.
  int seed;

  /// Whether the participant has been eliminated.
  bool isEliminated;

  /// Final placement (1st, 2nd, etc.).
  int? placement;

  /// Satoshis won in this tournament.
  int satoshisWon;

  /// Timestamp of registration.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TournamentParticipant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TournamentParticipant copyWith({
    int? id,
    int? tournamentId,
    int? userId,
    int? creatureId,
    int? seed,
    bool? isEliminated,
    int? placement,
    int? satoshisWon,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'tournamentId': tournamentId,
      'userId': userId,
      'creatureId': creatureId,
      'seed': seed,
      'isEliminated': isEliminated,
      if (placement != null) 'placement': placement,
      'satoshisWon': satoshisWon,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'tournamentId': tournamentId,
      'userId': userId,
      'creatureId': creatureId,
      'seed': seed,
      'isEliminated': isEliminated,
      if (placement != null) 'placement': placement,
      'satoshisWon': satoshisWon,
      'createdAt': createdAt.toJson(),
    };
  }

  static TournamentParticipantInclude include() {
    return TournamentParticipantInclude._();
  }

  static TournamentParticipantIncludeList includeList({
    _i1.WhereExpressionBuilder<TournamentParticipantTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TournamentParticipantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TournamentParticipantTable>? orderByList,
    TournamentParticipantInclude? include,
  }) {
    return TournamentParticipantIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TournamentParticipant.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TournamentParticipant.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TournamentParticipantImpl extends TournamentParticipant {
  _TournamentParticipantImpl({
    int? id,
    required int tournamentId,
    required int userId,
    required int creatureId,
    required int seed,
    required bool isEliminated,
    int? placement,
    required int satoshisWon,
    required DateTime createdAt,
  }) : super._(
          id: id,
          tournamentId: tournamentId,
          userId: userId,
          creatureId: creatureId,
          seed: seed,
          isEliminated: isEliminated,
          placement: placement,
          satoshisWon: satoshisWon,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [TournamentParticipant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TournamentParticipant copyWith({
    Object? id = _Undefined,
    int? tournamentId,
    int? userId,
    int? creatureId,
    int? seed,
    bool? isEliminated,
    Object? placement = _Undefined,
    int? satoshisWon,
    DateTime? createdAt,
  }) {
    return TournamentParticipant(
      id: id is int? ? id : this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      userId: userId ?? this.userId,
      creatureId: creatureId ?? this.creatureId,
      seed: seed ?? this.seed,
      isEliminated: isEliminated ?? this.isEliminated,
      placement: placement is int? ? placement : this.placement,
      satoshisWon: satoshisWon ?? this.satoshisWon,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TournamentParticipantTable extends _i1.Table<int?> {
  TournamentParticipantTable({super.tableRelation})
      : super(tableName: 'tournament_participants') {
    tournamentId = _i1.ColumnInt(
      'tournamentId',
      this,
    );
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    creatureId = _i1.ColumnInt(
      'creatureId',
      this,
    );
    seed = _i1.ColumnInt(
      'seed',
      this,
    );
    isEliminated = _i1.ColumnBool(
      'isEliminated',
      this,
    );
    placement = _i1.ColumnInt(
      'placement',
      this,
    );
    satoshisWon = _i1.ColumnInt(
      'satoshisWon',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  /// Reference to the tournament.
  late final _i1.ColumnInt tournamentId;

  /// Reference to the participating user.
  late final _i1.ColumnInt userId;

  /// Reference to the creature used in the tournament.
  late final _i1.ColumnInt creatureId;

  /// Seed/position in the bracket.
  late final _i1.ColumnInt seed;

  /// Whether the participant has been eliminated.
  late final _i1.ColumnBool isEliminated;

  /// Final placement (1st, 2nd, etc.).
  late final _i1.ColumnInt placement;

  /// Satoshis won in this tournament.
  late final _i1.ColumnInt satoshisWon;

  /// Timestamp of registration.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
        id,
        tournamentId,
        userId,
        creatureId,
        seed,
        isEliminated,
        placement,
        satoshisWon,
        createdAt,
      ];
}

class TournamentParticipantInclude extends _i1.IncludeObject {
  TournamentParticipantInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TournamentParticipant.t;
}

class TournamentParticipantIncludeList extends _i1.IncludeList {
  TournamentParticipantIncludeList._({
    _i1.WhereExpressionBuilder<TournamentParticipantTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TournamentParticipant.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TournamentParticipant.t;
}

class TournamentParticipantRepository {
  const TournamentParticipantRepository._();

  /// Returns a list of [TournamentParticipant]s matching the given query parameters.
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
  Future<List<TournamentParticipant>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TournamentParticipantTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TournamentParticipantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TournamentParticipantTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TournamentParticipant>(
      where: where?.call(TournamentParticipant.t),
      orderBy: orderBy?.call(TournamentParticipant.t),
      orderByList: orderByList?.call(TournamentParticipant.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TournamentParticipant] matching the given query parameters.
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
  Future<TournamentParticipant?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TournamentParticipantTable>? where,
    int? offset,
    _i1.OrderByBuilder<TournamentParticipantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TournamentParticipantTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TournamentParticipant>(
      where: where?.call(TournamentParticipant.t),
      orderBy: orderBy?.call(TournamentParticipant.t),
      orderByList: orderByList?.call(TournamentParticipant.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TournamentParticipant] by its [id] or null if no such row exists.
  Future<TournamentParticipant?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TournamentParticipant>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TournamentParticipant]s in the list and returns the inserted rows.
  ///
  /// The returned [TournamentParticipant]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TournamentParticipant>> insert(
    _i1.Session session,
    List<TournamentParticipant> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TournamentParticipant>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TournamentParticipant] and returns the inserted row.
  ///
  /// The returned [TournamentParticipant] will have its `id` field set.
  Future<TournamentParticipant> insertRow(
    _i1.Session session,
    TournamentParticipant row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TournamentParticipant>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TournamentParticipant]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TournamentParticipant>> update(
    _i1.Session session,
    List<TournamentParticipant> rows, {
    _i1.ColumnSelections<TournamentParticipantTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TournamentParticipant>(
      rows,
      columns: columns?.call(TournamentParticipant.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TournamentParticipant]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TournamentParticipant> updateRow(
    _i1.Session session,
    TournamentParticipant row, {
    _i1.ColumnSelections<TournamentParticipantTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TournamentParticipant>(
      row,
      columns: columns?.call(TournamentParticipant.t),
      transaction: transaction,
    );
  }

  /// Deletes all [TournamentParticipant]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TournamentParticipant>> delete(
    _i1.Session session,
    List<TournamentParticipant> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TournamentParticipant>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TournamentParticipant].
  Future<TournamentParticipant> deleteRow(
    _i1.Session session,
    TournamentParticipant row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TournamentParticipant>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TournamentParticipant>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TournamentParticipantTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TournamentParticipant>(
      where: where(TournamentParticipant.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TournamentParticipantTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TournamentParticipant>(
      where: where?.call(TournamentParticipant.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
