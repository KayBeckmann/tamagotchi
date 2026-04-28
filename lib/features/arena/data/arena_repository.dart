import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../creature/domain/models/creature.dart';
import '../../creature/domain/models/creature_type.dart';

/// Simulated battle history entry.
class BattleHistoryEntry {
  final String battleId;
  final String opponentName;
  final String opponentCreatureName;
  final bool playerWon;
  final int xpGained;
  final int satoshisGained;
  final int eloChange;
  final DateTime battleDate;
  final int totalRounds;

  const BattleHistoryEntry({
    required this.battleId,
    required this.opponentName,
    required this.opponentCreatureName,
    required this.playerWon,
    required this.xpGained,
    required this.satoshisGained,
    required this.eloChange,
    required this.battleDate,
    required this.totalRounds,
  });
}

/// Arena repository – handles matchmaking simulation and battle history.
class ArenaRepository {
  final _uuid = const Uuid();
  final _rng = Random();

  // In-memory battle history
  final List<BattleHistoryEntry> _history = [];

  // Simulated opponent names and creature types
  static const _opponentNames = [
    'DragonMaster',
    'CryptoCat',
    'NightHunter',
    'ShadowWolf',
    'StarFighter',
    'LightningBolt',
    'IceQueen',
    'FireKing',
    'ThunderBird',
    'MysticFox',
  ];

  /// Simulate finding a matchmaking opponent (returns after delay).
  Future<Creature> findOpponent({
    required Creature playerCreature,
    required int playerElo,
  }) async {
    // Simulate network search time
    final waitSeconds = 2 + _rng.nextInt(4);
    await Future.delayed(Duration(seconds: waitSeconds));

    // Pick a random opponent creature type
    final allTypes = CreatureCatalog.all;
    final opponentType = allTypes[_rng.nextInt(allTypes.length)];

    // Create opponent creature with stats near player's combat power
    final baseHp = max(50, opponentType.baseHealth * 10);

    return Creature(
      id: _uuid.v4(),
      userId: 'opponent_${_rng.nextInt(10000)}',
      type: opponentType,
      name: '${opponentType.name}_${_rng.nextInt(999)}',
      isActive: true,
      stage: playerCreature.stage,
      ageInDays: playerCreature.ageInDays,
      birthDate: playerCreature.birthDate,
      hunger: 60 + _rng.nextInt(40),
      happiness: 60 + _rng.nextInt(40),
      energy: 60 + _rng.nextInt(40),
      health: 60 + _rng.nextInt(40),
      cleanliness: 60 + _rng.nextInt(40),
      weight: 5.0 + _rng.nextInt(10),
      trainedAttack: _rng.nextInt(10),
      trainedDefense: _rng.nextInt(10),
      trainedSpeed: _rng.nextInt(10),
      maxBattleHp: baseHp,
      currentBattleHp: baseHp,
      isSleeping: false,
      isSick: false,
      isStunned: false,
      lastInteractionAt: DateTime.now(),
      lastStatusUpdateAt: DateTime.now(),
      createdAt: DateTime.now().subtract(
        Duration(days: playerCreature.ageInDays),
      ),
    );
  }

  /// Get a random opponent name.
  String randomOpponentName() =>
      _opponentNames[_rng.nextInt(_opponentNames.length)];

  /// Save a completed battle to history.
  Future<void> saveBattleResult(BattleHistoryEntry entry) async {
    _history.insert(0, entry);
    // Keep only last 50 battles
    if (_history.length > 50) _history.removeLast();
  }

  /// Get battle history for a user.
  Future<List<BattleHistoryEntry>> getBattleHistory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_history);
  }

  String generateBattleId() => _uuid.v4();
}

final arenaRepositoryProvider = Provider<ArenaRepository>((ref) {
  return ArenaRepository();
});
