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

/// Record of a battle between two creatures.
abstract class BattleRecord implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
