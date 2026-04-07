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

/// A user's participation in a tournament.
abstract class TournamentParticipant implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
