import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/battle.dart';
import '../../../creature/domain/models/creature.dart';
import '../../../creature/domain/models/creature_type.dart';
import '../../../wallet/data/wallet_repository.dart';

class ArenaRepository {
  final WalletRepository _walletRepository;
  final _random = Random();

  ArenaRepository(this._walletRepository);

  Future<BattleParticipant> findOpponent(int playerLevel) async {
    // Simulate matchmaking
    await Future.delayed(const Duration(seconds: 2));
    
    // Create a random opponent based on player level
    final level = (playerLevel + _random.nextInt(3) - 1).clamp(1, 100);
    final creatureType = CreatureCatalog.all[_random.nextInt(CreatureCatalog.all.length)];
    
    return BattleParticipant(
      id: 'cpu_${_random.nextInt(1000)}',
      name: 'Gegner ${_random.nextInt(100)}',
      creatureId: 'cpu_creature',
      creatureName: '${creatureType.name}_CPU',
      creatureTypeId: creatureType.id,
      level: level,
      maxHp: 100 + (level * 10),
      currentHp: 100 + (level * 10),
      attack: creatureType.baseAttack + (level * 2),
      defense: creatureType.baseDefense + (level * 2),
      speed: creatureType.baseSpeed + (level * 2),
    );
  }

  BattleTurn executeTurn(
    BattleParticipant attacker, 
    BattleParticipant defender, 
    BattleAction action,
    int turnNumber,
  ) {
    int damage = 0;
    String message = '';
    bool isCritical = false;
    bool isMissed = false;

    // Reset defense/dodge from previous turn if it was defender's turn
    // (In our simplified logic, it's one action per turn)
    
    switch (action) {
      case BattleAction.attack:
        final result = _calculateDamage(attacker, defender);
        damage = result.damage;
        isCritical = result.isCritical;
        isMissed = result.isMissed;
        
        if (isMissed) {
          message = '${attacker.creatureName} greift an, aber verfehlt!';
        } else {
          message = '${attacker.creatureName} trifft ${defender.creatureName} für $damage Schaden!';
          if (isCritical) message += ' Ein kritischer Treffer!';
          defender.currentHp = (defender.currentHp - damage).clamp(0, defender.maxHp);
        }
        break;
        
      case BattleAction.special:
        // Special attack: higher damage but chance to miss
        final baseDamage = (attacker.attack * 1.5).round();
        final hitChance = 0.7 + (attacker.speed / 500);
        
        if (_random.nextDouble() > hitChance) {
          isMissed = true;
          message = '${attacker.creatureName} versucht einen Spezialangriff, aber verfehlt!';
        } else {
          damage = (baseDamage * (0.9 + _random.nextDouble() * 0.2)).round();
          message = '${attacker.creatureName} entfesselt einen Spezialangriff! $damage Schaden!';
          defender.currentHp = (defender.currentHp - damage).clamp(0, defender.maxHp);
        }
        break;
        
      case BattleAction.defend:
        attacker.isDefending = true;
        message = '${attacker.creatureName} bereitet sich auf Verteidigung vor!';
        break;
        
      case BattleAction.dodge:
        attacker.isDodging = true;
        message = '${attacker.creatureName} versucht auszuweichen!';
        break;
    }

    return BattleTurn(
      turnNumber: turnNumber,
      attackerId: attacker.id,
      defenderId: defender.id,
      action: action,
      damage: damage,
      logMessage: message,
      isCritical: isCritical,
      isMissed: isMissed,
    );
  }

  ({int damage, bool isCritical, bool isMissed}) _calculateDamage(
    BattleParticipant attacker, 
    BattleParticipant defender,
  ) {
    // 1. Check if missed
    final hitChance = 0.9 + (attacker.speed / 1000) - (defender.isDodging ? 0.3 : 0);
    if (_random.nextDouble() > hitChance) {
      return (damage: 0, isCritical: false, isMissed: true);
    }

    // 2. Base damage
    double damage = attacker.attack.toDouble();
    
    // 3. Defense reduction
    double defFactor = defender.defense.toDouble() * (defender.isDefending ? 2.0 : 1.0);
    damage = damage * (100 / (100 + defFactor));
    
    // 4. Random variance (0.85 - 1.15)
    damage = damage * (0.85 + _random.nextDouble() * 0.3);
    
    // 5. Critical hit (10% chance)
    bool isCritical = _random.nextDouble() < 0.1;
    if (isCritical) damage *= 1.5;

    return (damage: damage.round(), isCritical: isCritical, isMissed: false);
  }

  Future<BattleResult> finalizeBattle(
    String userId, 
    String opponentId, 
    bool isWinner, 
    List<BattleTurn> history,
  ) async {
    final xpGained = isWinner ? 50 : 10;
    final satsGained = isWinner ? 500 : 100;

    if (satsGained > 0) {
      await _walletRepository.addSatoshi(userId, satsGained, isWinner ? 'Arena-Sieg' : 'Arena-Teilnahme');
    }

    return BattleResult(
      winnerId: isWinner ? userId : opponentId,
      loserId: isWinner ? opponentId : userId,
      xpGained: xpGained,
      satoshisGained: satsGained,
      history: history,
    );
  }
}

final arenaRepositoryProvider = Provider<ArenaRepository>((ref) {
  final walletRepo = ref.watch(walletRepositoryProvider);
  return ArenaRepository(walletRepo);
});
