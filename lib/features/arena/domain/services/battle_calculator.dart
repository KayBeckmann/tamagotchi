import 'dart:math';
import '../../../creature/domain/models/creature.dart';
import '../models/battle_action.dart';
import '../models/battle_state.dart';
import '../models/battle_turn.dart';

/// Pure battle calculation logic – no side effects, fully testable.
class BattleCalculator {
  static final _rng = Random();

  /// Calculate one full turn given both players' actions and current state.
  static BattleState resolveTurn(
    BattleState state,
    BattleActionType playerAction,
    BattleActionType opponentAction,
  ) {
    final round = state.currentRound + 1;

    // Resolve action effects
    final playerResult = _resolveAttack(
      attacker: state.playerCreature,
      defender: state.opponentCreature,
      action: playerAction,
      defenderIsDefending: state.opponentDefending,
      attackerHp: state.playerCurrentHp,
    );

    final opponentResult = _resolveAttack(
      attacker: state.opponentCreature,
      defender: state.playerCreature,
      action: opponentAction,
      defenderIsDefending: state.playerDefending,
      attackerHp: state.opponentCurrentHp,
    );

    // Dodge check: if defender chose dodge, 40% chance to avoid incoming damage
    final playerDodged =
        playerAction == BattleActionType.dodge && _rng.nextDouble() < 0.40;
    final opponentDodged =
        opponentAction == BattleActionType.dodge && _rng.nextDouble() < 0.40;

    // Apply damage (speed determines who goes first, but both attack)
    final playerFaster = state.playerCreature.totalSpeed >=
        state.opponentCreature.totalSpeed;

    int playerHp = state.playerCurrentHp;
    int opponentHp = state.opponentCurrentHp;

    // Compute actual damage taken
    final playerDamageTaken = opponentDodged ? 0 : opponentResult.damage;
    final opponentDamageTaken = playerDodged ? 0 : playerResult.damage;

    // Apply in speed order (for log only, both survive the round unless hp = 0)
    if (playerFaster) {
      opponentHp = max(0, opponentHp - opponentDamageTaken);
      playerHp = max(0, playerHp - playerDamageTaken);
    } else {
      playerHp = max(0, playerHp - playerDamageTaken);
      opponentHp = max(0, opponentHp - opponentDamageTaken);
    }

    // Update cooldowns
    int newPlayerCooldown = max(0, state.playerSpecialCooldown - 1);
    if (playerAction == BattleActionType.specialAttack) {
      newPlayerCooldown = state.playerCreature.type.specialAbilityCooldown;
    }

    // Build log message
    final log = _buildLog(
      round: round,
      playerCreatureName: state.playerCreature.name,
      opponentCreatureName: state.opponentCreature.name,
      playerAction: playerAction,
      opponentAction: opponentAction,
      playerDamageDealt: opponentDamageTaken,
      opponentDamageDealt: playerDamageTaken,
      playerDodged: playerDodged,
      opponentDodged: opponentDodged,
      playerCrit: playerResult.isCrit,
      opponentCrit: opponentResult.isCrit,
    );

    final turn = BattleTurn(
      roundNumber: round,
      playerAction: playerAction,
      opponentAction: opponentAction,
      playerDamageDealt: opponentDamageTaken,
      opponentDamageDealt: playerDamageTaken,
      playerHpAfter: playerHp,
      opponentHpAfter: opponentHp,
      playerDodged: playerDodged,
      opponentDodged: opponentDodged,
      playerCrit: playerResult.isCrit,
      opponentCrit: opponentResult.isCrit,
      logMessage: log,
      specialUsed: playerAction == BattleActionType.specialAttack,
    );

    // Check if battle is over
    final battleOver = playerHp <= 0 || opponentHp <= 0 || round >= state.maxRounds;

    BattleResult? result;
    int xpGained = 0;
    int satoshisGained = 0;
    int eloChange = 0;

    if (battleOver) {
      if (playerHp > opponentHp) {
        result = BattleResult.playerWon;
        xpGained = 50;
        satoshisGained = _rng.nextInt(500) + 100; // 100-600 sats
        eloChange = 25;
      } else if (opponentHp > playerHp) {
        result = BattleResult.playerLost;
        xpGained = 10;
        satoshisGained = _rng.nextInt(50) + 10; // 10-60 sats for participation
        eloChange = -20;
      } else {
        result = BattleResult.draw;
        xpGained = 25;
        satoshisGained = 50;
        eloChange = 0;
      }
    }

    return state.copyWith(
      status: battleOver ? BattleStatus.finished : BattleStatus.playerTurn,
      playerCurrentHp: playerHp,
      opponentCurrentHp: opponentHp,
      currentRound: round,
      playerSpecialCooldown: newPlayerCooldown,
      playerDefending: playerAction == BattleActionType.defend,
      opponentDefending: opponentAction == BattleActionType.defend,
      turns: [...state.turns, turn],
      result: result,
      xpGained: xpGained,
      satoshisGained: satoshisGained,
      playerEloChange: eloChange,
    );
  }

  /// Pick the AI opponent's action intelligently.
  static BattleActionType pickOpponentAction(BattleState state) {
    final opponentHpPercent = state.opponentCurrentHp / state.opponentCreature.maxBattleHp;
    final playerHpPercent = state.playerCurrentHp / state.playerCreature.maxBattleHp;
    final rand = _rng.nextDouble();

    // Low HP: more likely to defend or use special
    if (opponentHpPercent < 0.25) {
      if (rand < 0.30) return BattleActionType.defend;
      if (rand < 0.55) return BattleActionType.specialAttack;
      return BattleActionType.normalAttack;
    }

    // Player is low HP: go aggressive
    if (playerHpPercent < 0.25) {
      if (rand < 0.60) return BattleActionType.normalAttack;
      if (rand < 0.80) return BattleActionType.specialAttack;
      return BattleActionType.dodge;
    }

    // Default distribution
    if (rand < 0.45) return BattleActionType.normalAttack;
    if (rand < 0.65) return BattleActionType.specialAttack;
    if (rand < 0.80) return BattleActionType.defend;
    return BattleActionType.dodge;
  }

  /// Compute max battle HP for a creature (for fresh battle start).
  static int computeMaxBattleHp(Creature creature) {
    final base = creature.type.baseHealth * 10;
    final bonus = (creature.trainedDefense * 2).toInt();
    final stageMult = creature.stageMultiplier;
    return max(50, ((base + bonus) * stageMult).round());
  }

  // ---- private helpers ----

  static _AttackResult _resolveAttack({
    required Creature attacker,
    required Creature defender,
    required BattleActionType action,
    required bool defenderIsDefending,
    required int attackerHp,
  }) {
    if (action == BattleActionType.defend || action == BattleActionType.dodge) {
      return _AttackResult(damage: 0, isCrit: false);
    }

    double attackPower = action == BattleActionType.specialAttack
        ? attacker.totalAttack * 1.6
        : attacker.totalAttack.toDouble();

    // Status modifier: hungry/unhealthy creature deals less damage
    final statsPenalty =
        (attacker.hunger < 20 || attacker.health < 20) ? 0.75 : 1.0;
    attackPower *= statsPenalty;

    // Defense reduction
    double defModifier = defenderIsDefending ? 0.5 : 1.0;
    final effectiveDefense = defender.totalDefense * defModifier;
    double rawDamage = max(1.0, attackPower - effectiveDefense * 0.4);

    // Random factor ±15%
    final randomFactor = 0.85 + _rng.nextDouble() * 0.30;
    rawDamage *= randomFactor;

    // Critical hit: 10% chance (+50% damage)
    final isCrit = _rng.nextDouble() < 0.10;
    if (isCrit) rawDamage *= 1.5;

    return _AttackResult(damage: max(1, rawDamage.round()), isCrit: isCrit);
  }

  static String _buildLog({
    required int round,
    required String playerCreatureName,
    required String opponentCreatureName,
    required BattleActionType playerAction,
    required BattleActionType opponentAction,
    required int playerDamageDealt,
    required int opponentDamageDealt,
    required bool playerDodged,
    required bool opponentDodged,
    required bool playerCrit,
    required bool opponentCrit,
  }) {
    final buf = StringBuffer('Runde $round: ');

    // Player action
    switch (playerAction) {
      case BattleActionType.normalAttack:
        if (opponentDodged) {
          buf.write('$playerCreatureName greift an – $opponentCreatureName weicht aus!');
        } else {
          buf.write(
            '$playerCreatureName greift an und verursacht $playerDamageDealt Schaden'
            '${playerCrit ? " (KRITISCH!)" : ""}.',
          );
        }
      case BattleActionType.specialAttack:
        if (opponentDodged) {
          buf.write(
            '$playerCreatureName setzt Spezialangriff ein – $opponentCreatureName weicht aus!',
          );
        } else {
          buf.write(
            '$playerCreatureName setzt Spezialangriff ein: $playerDamageDealt Schaden'
            '${playerCrit ? " (KRITISCH!)" : ""}!',
          );
        }
      case BattleActionType.defend:
        buf.write('$playerCreatureName geht in Verteidigungsstellung.');
      case BattleActionType.dodge:
        buf.write(
          playerDodged
              ? '$playerCreatureName weicht erfolgreich aus!'
              : '$playerCreatureName versucht auszuweichen, schafft es aber nicht.',
        );
    }

    buf.write(' | ');

    // Opponent action
    switch (opponentAction) {
      case BattleActionType.normalAttack:
        if (playerDodged) {
          buf.write('$opponentCreatureName greift an – $playerCreatureName weicht aus!');
        } else {
          buf.write(
            '$opponentCreatureName greift an: $opponentDamageDealt Schaden'
            '${opponentCrit ? " (KRITISCH!)" : ""}.',
          );
        }
      case BattleActionType.specialAttack:
        if (playerDodged) {
          buf.write(
            '$opponentCreatureName setzt Spezialangriff ein – $playerCreatureName weicht aus!',
          );
        } else {
          buf.write(
            '$opponentCreatureName setzt Spezialangriff ein: $opponentDamageDealt Schaden'
            '${opponentCrit ? " (KRITISCH!)" : ""}!',
          );
        }
      case BattleActionType.defend:
        buf.write('$opponentCreatureName verteidigt sich.');
      case BattleActionType.dodge:
        buf.write(
          opponentDodged
              ? '$opponentCreatureName weicht erfolgreich aus!'
              : '$opponentCreatureName versucht auszuweichen, schafft es aber nicht.',
        );
    }

    return buf.toString();
  }
}

class _AttackResult {
  final int damage;
  final bool isCrit;
  const _AttackResult({required this.damage, required this.isCrit});
}
