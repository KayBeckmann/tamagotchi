import 'package:equatable/equatable.dart';
import '../../../creature/domain/models/creature.dart';

/// Status of the matchmaking queue.
enum MatchmakingStatus {
  idle,
  searching,
  found,
  cancelled,
}

/// Information about a matched opponent (simplified for client).
class OpponentInfo extends Equatable {
  final String userId;
  final String username;
  final int eloRating;
  final Creature creature;

  const OpponentInfo({
    required this.userId,
    required this.username,
    required this.eloRating,
    required this.creature,
  });

  @override
  List<Object?> get props => [userId];
}

/// State of the matchmaking process.
class MatchmakingState extends Equatable {
  final MatchmakingStatus status;
  final Duration searchDuration;
  final OpponentInfo? opponent;
  final String? errorMessage;

  const MatchmakingState({
    this.status = MatchmakingStatus.idle,
    this.searchDuration = Duration.zero,
    this.opponent,
    this.errorMessage,
  });

  MatchmakingState copyWith({
    MatchmakingStatus? status,
    Duration? searchDuration,
    OpponentInfo? opponent,
    String? errorMessage,
  }) {
    return MatchmakingState(
      status: status ?? this.status,
      searchDuration: searchDuration ?? this.searchDuration,
      opponent: opponent ?? this.opponent,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, searchDuration, opponent];
}
