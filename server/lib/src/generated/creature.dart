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

/// A creature owned by a user (their Tamagotchi).
abstract class Creature
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Creature._({
    this.id,
    required this.userId,
    required this.creatureTypeId,
    required this.name,
    required this.hunger,
    required this.happiness,
    required this.energy,
    required this.health,
    required this.cleanliness,
    required this.weight,
    required this.attack,
    required this.defense,
    required this.speed,
    required this.maxHp,
    required this.evolutionStage,
    required this.isActive,
    required this.isAlive,
    required this.isStunned,
    this.stunUntil,
    required this.createdAt,
    required this.lastStatUpdate,
    this.lastFedAt,
    this.lastPlayedAt,
    this.lastTrainedAt,
  });

  factory Creature({
    int? id,
    required int userId,
    required int creatureTypeId,
    required String name,
    required int hunger,
    required int happiness,
    required int energy,
    required int health,
    required int cleanliness,
    required double weight,
    required int attack,
    required int defense,
    required int speed,
    required int maxHp,
    required String evolutionStage,
    required bool isActive,
    required bool isAlive,
    required bool isStunned,
    DateTime? stunUntil,
    required DateTime createdAt,
    required DateTime lastStatUpdate,
    DateTime? lastFedAt,
    DateTime? lastPlayedAt,
    DateTime? lastTrainedAt,
  }) = _CreatureImpl;

  factory Creature.fromJson(Map<String, dynamic> jsonSerialization) {
    return Creature(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      creatureTypeId: jsonSerialization['creatureTypeId'] as int,
      name: jsonSerialization['name'] as String,
      hunger: jsonSerialization['hunger'] as int,
      happiness: jsonSerialization['happiness'] as int,
      energy: jsonSerialization['energy'] as int,
      health: jsonSerialization['health'] as int,
      cleanliness: jsonSerialization['cleanliness'] as int,
      weight: (jsonSerialization['weight'] as num).toDouble(),
      attack: jsonSerialization['attack'] as int,
      defense: jsonSerialization['defense'] as int,
      speed: jsonSerialization['speed'] as int,
      maxHp: jsonSerialization['maxHp'] as int,
      evolutionStage: jsonSerialization['evolutionStage'] as String,
      isActive: jsonSerialization['isActive'] as bool,
      isAlive: jsonSerialization['isAlive'] as bool,
      isStunned: jsonSerialization['isStunned'] as bool,
      stunUntil: jsonSerialization['stunUntil'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['stunUntil']),
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      lastStatUpdate: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['lastStatUpdate']),
      lastFedAt: jsonSerialization['lastFedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastFedAt']),
      lastPlayedAt: jsonSerialization['lastPlayedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastPlayedAt']),
      lastTrainedAt: jsonSerialization['lastTrainedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastTrainedAt']),
    );
  }

  static final t = CreatureTable();

  static const db = CreatureRepository._();

  @override
  int? id;

  /// The user who owns this creature.
  int userId;

  /// The type/species of this creature.
  int creatureTypeId;

  /// Name given by the user.
  String name;

  /// Current hunger level (0-100).
  int hunger;

  /// Current happiness level (0-100).
  int happiness;

  /// Current energy level (0-100).
  int energy;

  /// Current health level (0-100).
  int health;

  /// Current cleanliness level (0-100).
  int cleanliness;

  /// Current weight.
  double weight;

  /// Attack stat (base + training bonus).
  int attack;

  /// Defense stat (base + training bonus).
  int defense;

  /// Speed stat (base + training bonus).
  int speed;

  /// Max battle HP.
  int maxHp;

  /// Evolution stage: egg, baby, child, teen, adult.
  String evolutionStage;

  /// Whether this is the user's active creature.
  bool isActive;

  /// Whether the creature is alive.
  bool isAlive;

  /// Whether the creature is stunned (from tournament loss).
  bool isStunned;

  /// When stun wears off.
  DateTime? stunUntil;

  /// Timestamp when the creature was created (for age calculation).
  DateTime createdAt;

  /// Last time stats were decayed server-side.
  DateTime lastStatUpdate;

  /// Last time the creature was fed.
  DateTime? lastFedAt;

  /// Last time the creature was played with.
  DateTime? lastPlayedAt;

  /// Last time the creature was trained.
  DateTime? lastTrainedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Creature]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Creature copyWith({
    int? id,
    int? userId,
    int? creatureTypeId,
    String? name,
    int? hunger,
    int? happiness,
    int? energy,
    int? health,
    int? cleanliness,
    double? weight,
    int? attack,
    int? defense,
    int? speed,
    int? maxHp,
    String? evolutionStage,
    bool? isActive,
    bool? isAlive,
    bool? isStunned,
    DateTime? stunUntil,
    DateTime? createdAt,
    DateTime? lastStatUpdate,
    DateTime? lastFedAt,
    DateTime? lastPlayedAt,
    DateTime? lastTrainedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'creatureTypeId': creatureTypeId,
      'name': name,
      'hunger': hunger,
      'happiness': happiness,
      'energy': energy,
      'health': health,
      'cleanliness': cleanliness,
      'weight': weight,
      'attack': attack,
      'defense': defense,
      'speed': speed,
      'maxHp': maxHp,
      'evolutionStage': evolutionStage,
      'isActive': isActive,
      'isAlive': isAlive,
      'isStunned': isStunned,
      if (stunUntil != null) 'stunUntil': stunUntil?.toJson(),
      'createdAt': createdAt.toJson(),
      'lastStatUpdate': lastStatUpdate.toJson(),
      if (lastFedAt != null) 'lastFedAt': lastFedAt?.toJson(),
      if (lastPlayedAt != null) 'lastPlayedAt': lastPlayedAt?.toJson(),
      if (lastTrainedAt != null) 'lastTrainedAt': lastTrainedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'creatureTypeId': creatureTypeId,
      'name': name,
      'hunger': hunger,
      'happiness': happiness,
      'energy': energy,
      'health': health,
      'cleanliness': cleanliness,
      'weight': weight,
      'attack': attack,
      'defense': defense,
      'speed': speed,
      'maxHp': maxHp,
      'evolutionStage': evolutionStage,
      'isActive': isActive,
      'isAlive': isAlive,
      'isStunned': isStunned,
      if (stunUntil != null) 'stunUntil': stunUntil?.toJson(),
      'createdAt': createdAt.toJson(),
      'lastStatUpdate': lastStatUpdate.toJson(),
      if (lastFedAt != null) 'lastFedAt': lastFedAt?.toJson(),
      if (lastPlayedAt != null) 'lastPlayedAt': lastPlayedAt?.toJson(),
      if (lastTrainedAt != null) 'lastTrainedAt': lastTrainedAt?.toJson(),
    };
  }

  static CreatureInclude include() {
    return CreatureInclude._();
  }

  static CreatureIncludeList includeList({
    _i1.WhereExpressionBuilder<CreatureTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CreatureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreatureTable>? orderByList,
    CreatureInclude? include,
  }) {
    return CreatureIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Creature.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Creature.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CreatureImpl extends Creature {
  _CreatureImpl({
    int? id,
    required int userId,
    required int creatureTypeId,
    required String name,
    required int hunger,
    required int happiness,
    required int energy,
    required int health,
    required int cleanliness,
    required double weight,
    required int attack,
    required int defense,
    required int speed,
    required int maxHp,
    required String evolutionStage,
    required bool isActive,
    required bool isAlive,
    required bool isStunned,
    DateTime? stunUntil,
    required DateTime createdAt,
    required DateTime lastStatUpdate,
    DateTime? lastFedAt,
    DateTime? lastPlayedAt,
    DateTime? lastTrainedAt,
  }) : super._(
          id: id,
          userId: userId,
          creatureTypeId: creatureTypeId,
          name: name,
          hunger: hunger,
          happiness: happiness,
          energy: energy,
          health: health,
          cleanliness: cleanliness,
          weight: weight,
          attack: attack,
          defense: defense,
          speed: speed,
          maxHp: maxHp,
          evolutionStage: evolutionStage,
          isActive: isActive,
          isAlive: isAlive,
          isStunned: isStunned,
          stunUntil: stunUntil,
          createdAt: createdAt,
          lastStatUpdate: lastStatUpdate,
          lastFedAt: lastFedAt,
          lastPlayedAt: lastPlayedAt,
          lastTrainedAt: lastTrainedAt,
        );

  /// Returns a shallow copy of this [Creature]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Creature copyWith({
    Object? id = _Undefined,
    int? userId,
    int? creatureTypeId,
    String? name,
    int? hunger,
    int? happiness,
    int? energy,
    int? health,
    int? cleanliness,
    double? weight,
    int? attack,
    int? defense,
    int? speed,
    int? maxHp,
    String? evolutionStage,
    bool? isActive,
    bool? isAlive,
    bool? isStunned,
    Object? stunUntil = _Undefined,
    DateTime? createdAt,
    DateTime? lastStatUpdate,
    Object? lastFedAt = _Undefined,
    Object? lastPlayedAt = _Undefined,
    Object? lastTrainedAt = _Undefined,
  }) {
    return Creature(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      creatureTypeId: creatureTypeId ?? this.creatureTypeId,
      name: name ?? this.name,
      hunger: hunger ?? this.hunger,
      happiness: happiness ?? this.happiness,
      energy: energy ?? this.energy,
      health: health ?? this.health,
      cleanliness: cleanliness ?? this.cleanliness,
      weight: weight ?? this.weight,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
      speed: speed ?? this.speed,
      maxHp: maxHp ?? this.maxHp,
      evolutionStage: evolutionStage ?? this.evolutionStage,
      isActive: isActive ?? this.isActive,
      isAlive: isAlive ?? this.isAlive,
      isStunned: isStunned ?? this.isStunned,
      stunUntil: stunUntil is DateTime? ? stunUntil : this.stunUntil,
      createdAt: createdAt ?? this.createdAt,
      lastStatUpdate: lastStatUpdate ?? this.lastStatUpdate,
      lastFedAt: lastFedAt is DateTime? ? lastFedAt : this.lastFedAt,
      lastPlayedAt:
          lastPlayedAt is DateTime? ? lastPlayedAt : this.lastPlayedAt,
      lastTrainedAt:
          lastTrainedAt is DateTime? ? lastTrainedAt : this.lastTrainedAt,
    );
  }
}

class CreatureTable extends _i1.Table<int?> {
  CreatureTable({super.tableRelation}) : super(tableName: 'creatures') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    creatureTypeId = _i1.ColumnInt(
      'creatureTypeId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    hunger = _i1.ColumnInt(
      'hunger',
      this,
    );
    happiness = _i1.ColumnInt(
      'happiness',
      this,
    );
    energy = _i1.ColumnInt(
      'energy',
      this,
    );
    health = _i1.ColumnInt(
      'health',
      this,
    );
    cleanliness = _i1.ColumnInt(
      'cleanliness',
      this,
    );
    weight = _i1.ColumnDouble(
      'weight',
      this,
    );
    attack = _i1.ColumnInt(
      'attack',
      this,
    );
    defense = _i1.ColumnInt(
      'defense',
      this,
    );
    speed = _i1.ColumnInt(
      'speed',
      this,
    );
    maxHp = _i1.ColumnInt(
      'maxHp',
      this,
    );
    evolutionStage = _i1.ColumnString(
      'evolutionStage',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
    isAlive = _i1.ColumnBool(
      'isAlive',
      this,
    );
    isStunned = _i1.ColumnBool(
      'isStunned',
      this,
    );
    stunUntil = _i1.ColumnDateTime(
      'stunUntil',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    lastStatUpdate = _i1.ColumnDateTime(
      'lastStatUpdate',
      this,
    );
    lastFedAt = _i1.ColumnDateTime(
      'lastFedAt',
      this,
    );
    lastPlayedAt = _i1.ColumnDateTime(
      'lastPlayedAt',
      this,
    );
    lastTrainedAt = _i1.ColumnDateTime(
      'lastTrainedAt',
      this,
    );
  }

  /// The user who owns this creature.
  late final _i1.ColumnInt userId;

  /// The type/species of this creature.
  late final _i1.ColumnInt creatureTypeId;

  /// Name given by the user.
  late final _i1.ColumnString name;

  /// Current hunger level (0-100).
  late final _i1.ColumnInt hunger;

  /// Current happiness level (0-100).
  late final _i1.ColumnInt happiness;

  /// Current energy level (0-100).
  late final _i1.ColumnInt energy;

  /// Current health level (0-100).
  late final _i1.ColumnInt health;

  /// Current cleanliness level (0-100).
  late final _i1.ColumnInt cleanliness;

  /// Current weight.
  late final _i1.ColumnDouble weight;

  /// Attack stat (base + training bonus).
  late final _i1.ColumnInt attack;

  /// Defense stat (base + training bonus).
  late final _i1.ColumnInt defense;

  /// Speed stat (base + training bonus).
  late final _i1.ColumnInt speed;

  /// Max battle HP.
  late final _i1.ColumnInt maxHp;

  /// Evolution stage: egg, baby, child, teen, adult.
  late final _i1.ColumnString evolutionStage;

  /// Whether this is the user's active creature.
  late final _i1.ColumnBool isActive;

  /// Whether the creature is alive.
  late final _i1.ColumnBool isAlive;

  /// Whether the creature is stunned (from tournament loss).
  late final _i1.ColumnBool isStunned;

  /// When stun wears off.
  late final _i1.ColumnDateTime stunUntil;

  /// Timestamp when the creature was created (for age calculation).
  late final _i1.ColumnDateTime createdAt;

  /// Last time stats were decayed server-side.
  late final _i1.ColumnDateTime lastStatUpdate;

  /// Last time the creature was fed.
  late final _i1.ColumnDateTime lastFedAt;

  /// Last time the creature was played with.
  late final _i1.ColumnDateTime lastPlayedAt;

  /// Last time the creature was trained.
  late final _i1.ColumnDateTime lastTrainedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        creatureTypeId,
        name,
        hunger,
        happiness,
        energy,
        health,
        cleanliness,
        weight,
        attack,
        defense,
        speed,
        maxHp,
        evolutionStage,
        isActive,
        isAlive,
        isStunned,
        stunUntil,
        createdAt,
        lastStatUpdate,
        lastFedAt,
        lastPlayedAt,
        lastTrainedAt,
      ];
}

class CreatureInclude extends _i1.IncludeObject {
  CreatureInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Creature.t;
}

class CreatureIncludeList extends _i1.IncludeList {
  CreatureIncludeList._({
    _i1.WhereExpressionBuilder<CreatureTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Creature.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Creature.t;
}

class CreatureRepository {
  const CreatureRepository._();

  /// Returns a list of [Creature]s matching the given query parameters.
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
  Future<List<Creature>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreatureTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CreatureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreatureTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Creature>(
      where: where?.call(Creature.t),
      orderBy: orderBy?.call(Creature.t),
      orderByList: orderByList?.call(Creature.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Creature] matching the given query parameters.
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
  Future<Creature?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreatureTable>? where,
    int? offset,
    _i1.OrderByBuilder<CreatureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreatureTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Creature>(
      where: where?.call(Creature.t),
      orderBy: orderBy?.call(Creature.t),
      orderByList: orderByList?.call(Creature.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Creature] by its [id] or null if no such row exists.
  Future<Creature?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Creature>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Creature]s in the list and returns the inserted rows.
  ///
  /// The returned [Creature]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Creature>> insert(
    _i1.Session session,
    List<Creature> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Creature>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Creature] and returns the inserted row.
  ///
  /// The returned [Creature] will have its `id` field set.
  Future<Creature> insertRow(
    _i1.Session session,
    Creature row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Creature>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Creature]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Creature>> update(
    _i1.Session session,
    List<Creature> rows, {
    _i1.ColumnSelections<CreatureTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Creature>(
      rows,
      columns: columns?.call(Creature.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Creature]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Creature> updateRow(
    _i1.Session session,
    Creature row, {
    _i1.ColumnSelections<CreatureTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Creature>(
      row,
      columns: columns?.call(Creature.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Creature]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Creature>> delete(
    _i1.Session session,
    List<Creature> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Creature>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Creature].
  Future<Creature> deleteRow(
    _i1.Session session,
    Creature row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Creature>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Creature>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CreatureTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Creature>(
      where: where(Creature.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreatureTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Creature>(
      where: where?.call(Creature.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
