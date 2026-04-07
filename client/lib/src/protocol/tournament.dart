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

/// A tournament where creatures battle for Bitcoin prizes.
abstract class Tournament implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
