/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A creature owned by a user (their Tamagotchi).
abstract class Creature implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
