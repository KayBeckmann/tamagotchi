import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/time_of_day_helper.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../domain/models/creature.dart';
import '../../domain/models/creature_type.dart';
import '../../domain/models/action_cooldown.dart';
import '../../domain/models/item.dart';
import '../../data/creature_repository.dart';
import '../providers/creature_provider.dart';
import '../widgets/cooldown_indicator.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // TODO: Get actual user ID from auth
  static const _userId = 'user_1';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creatureState = ref.watch(creatureListProvider(_userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mein Tamagotchi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined),
            tooltip: 'Inventar',
            onPressed: () => context.push('/inventory'),
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Kreatur wechseln',
            onPressed: () => _showCreatureSwitcher(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Profil',
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: switch (creatureState) {
        CreatureListLoading() => const Center(child: CircularProgressIndicator()),
        CreatureListError(message: final msg) => _buildErrorState(context, msg, ref),
        CreatureListLoaded(activeCreature: final creature, creatures: final all) =>
          creature != null
              ? _buildCreatureView(context, ref, creature)
              : _buildNoCreatureState(context, all.isEmpty),
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Fehler: $message'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => ref.read(creatureListProvider(_userId).notifier).loadCreatures(),
            child: const Text('Erneut versuchen'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoCreatureState(BuildContext context, bool noCreatures) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.egg_outlined,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              noCreatures
                  ? 'Noch keine Kreatur!'
                  : 'Keine aktive Kreatur',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              noCreatures
                  ? 'Erschaffe deine erste Kreatur und beginne dein Abenteuer!'
                  : 'Wähle eine deiner Kreaturen als aktive Kreatur aus.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go('/creature-selection'),
              icon: const Icon(Icons.add),
              label: Text(noCreatures ? 'Kreatur erschaffen' : 'Kreatur wählen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatureView(BuildContext context, WidgetRef ref, Creature creature) {
    final isWide = context.isWide;
    final cooldowns = ref.read(creatureRepositoryProvider).getAllCooldowns(creature.id);

    if (isWide) {
      // Tablet/Desktop: Two-column layout
      return SingleChildScrollView(
        padding: EdgeInsets.all(context.horizontalPadding),
        child: ConstrainedContent(
          maxWidth: 1200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column: Creature display and battle stats
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    _CreatureDisplayCard(creature: creature),
                    if (creature.stage == DevelopmentStage.teen ||
                        creature.stage == DevelopmentStage.adult) ...[
                      const SizedBox(height: 16),
                      _BattleStatsCard(creature: creature),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Right column: Status, cooldowns, and actions
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    if (creature.hasCriticalStat)
                      _CriticalStatBanner(creature: creature),
                    _StatusCard(creature: creature),
                    const SizedBox(height: 16),
                    _CooldownDisplay(cooldowns: cooldowns),
                    _ActionsCard(
                      creature: creature,
                      cooldowns: cooldowns,
                      onFeed: () => _showFeedDialog(context, ref, creature),
                      onPlay: () => _performAction(context, ref, creature, 'play'),
                      onSleep: () => _performAction(context, ref, creature, creature.isSleeping ? 'wake' : 'sleep'),
                      onClean: () => _performAction(context, ref, creature, 'clean'),
                      onTrain: () => _showTrainDialog(context, ref, creature),
                      onMedicine: () => _showMedicineDialog(context, ref, creature),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Mobile: Single-column layout
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Creature display area
          _CreatureDisplayCard(creature: creature),
          const SizedBox(height: 16),

          // Warning banner for critical stats
          if (creature.hasCriticalStat)
            _CriticalStatBanner(creature: creature),

          // Stat bars
          _StatusCard(creature: creature),
          const SizedBox(height: 16),

          // Cooldown display
          _CooldownDisplay(cooldowns: cooldowns),

          // Action buttons
          _ActionsCard(
            creature: creature,
            cooldowns: cooldowns,
            onFeed: () => _showFeedDialog(context, ref, creature),
            onPlay: () => _performAction(context, ref, creature, 'play'),
            onSleep: () => _performAction(context, ref, creature, creature.isSleeping ? 'wake' : 'sleep'),
            onClean: () => _performAction(context, ref, creature, 'clean'),
            onTrain: () => _showTrainDialog(context, ref, creature),
            onMedicine: () => _showMedicineDialog(context, ref, creature),
          ),
          const SizedBox(height: 16),

          // Battle stats (if teen or adult)
          if (creature.stage == DevelopmentStage.teen ||
              creature.stage == DevelopmentStage.adult)
            _BattleStatsCard(creature: creature),
        ],
      ),
    );
  }

  void _showCreatureSwitcher(BuildContext context, WidgetRef ref) {
    final state = ref.read(creatureListProvider(_userId));
    if (state is! CreatureListLoaded) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => _CreatureSwitcherSheet(
        creatures: state.creatures,
        activeId: state.activeCreature?.id,
        onSelect: (id) {
          ref.read(creatureListProvider(_userId).notifier).setActiveCreature(id);
          Navigator.pop(context);
        },
        onCreateNew: () {
          Navigator.pop(context);
          context.go('/creature-selection');
        },
      ),
    );
  }

  void _showFeedDialog(BuildContext context, WidgetRef ref, Creature creature) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _FeedDialog(
        onFeed: (hungerGain, weightGain) async {
          Navigator.pop(context);
          await ref.read(creatureRepositoryProvider).feedCreature(
            creature.id,
            hungerGain,
            weightGain,
          );
          ref.read(creatureListProvider(_userId).notifier).loadCreatures();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${creature.name} wurde gefüttert!')),
            );
          }
        },
      ),
    );
  }

  void _showTrainDialog(BuildContext context, WidgetRef ref, Creature creature) {
    if (!creature.canTrain) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nicht genug Energie zum Trainieren!')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => _TrainDialog(
        creature: creature,
        onTrain: (statType) async {
          Navigator.pop(context);
          try {
            await ref.read(creatureRepositoryProvider).trainCreature(creature.id, statType);
            ref.read(creatureListProvider(_userId).notifier).loadCreatures();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${creature.name} hat trainiert!')),
              );
            }
          } on CooldownException catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          }
        },
      ),
    );
  }

  void _showMedicineDialog(BuildContext context, WidgetRef ref, Creature creature) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _MedicineDialog(
        userId: creature.userId,
        onGiveMedicine: (itemId) async {
          Navigator.pop(context);
          try {
            await ref.read(creatureRepositoryProvider).giveMedicine(creature.id, itemId);
            ref.read(creatureListProvider(_userId).notifier).loadCreatures();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${creature.name} fühlt sich besser!')),
              );
            }
          } on CooldownException catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fehler: $e')),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _performAction(BuildContext context, WidgetRef ref, Creature creature, String action) async {
    final repo = ref.read(creatureRepositoryProvider);

    try {
      switch (action) {
        case 'play':
          await repo.playWithCreature(creature.id);
          break;
        case 'sleep':
          await repo.sleepCreature(creature.id);
          break;
        case 'wake':
          await repo.wakeCreature(creature.id);
          break;
        case 'clean':
          await repo.cleanCreature(creature.id);
          break;
      }
      ref.read(creatureListProvider(_userId).notifier).loadCreatures();

      if (context.mounted) {
        final message = switch (action) {
          'play' => '${creature.name} hat gespielt!',
          'sleep' => '${creature.name} schläft jetzt.',
          'wake' => '${creature.name} ist aufgewacht!',
          'clean' => '${creature.name} ist jetzt sauber!',
          _ => 'Aktion ausgeführt!',
        };
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e')),
        );
      }
    }
  }
}

class _CreatureDisplayCard extends StatelessWidget {
  final Creature creature;

  const _CreatureDisplayCard({required this.creature});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = creature.type.category == CreatureCategory.animal
        ? Colors.green
        : Colors.purple;
    final dayPeriod = TimeOfDayHelper.getCurrentPeriod();
    final backgroundColors = TimeOfDayHelper.getBackgroundGradient(dayPeriod);
    final isDark = TimeOfDayHelper.isDark(dayPeriod);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        height: 240,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: backgroundColors,
          ),
        ),
        child: Stack(
          children: [
            // Time indicator
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      TimeOfDayHelper.getTimeIcon(dayPeriod),
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      TimeOfDayHelper.getGreeting(dayPeriod),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sleeping overlay
            if (creature.isSleeping)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.4),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bedtime, size: 48, color: Colors.white),
                        SizedBox(height: 8),
                        Text('Zzz...', style: TextStyle(color: Colors.white, fontSize: 24)),
                      ],
                    ),
                  ),
                ),
              ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Creature sprite placeholder
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.white : categoryColor).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: (isDark ? Colors.white : categoryColor).withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      _getCreatureIcon(creature.type.id),
                      size: 60,
                      color: isDark ? Colors.white : categoryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    creature.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Chip(
                        label: Text(creature.stage.displayName),
                        avatar: const Icon(Icons.trending_up, size: 16),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Colors.black.withValues(alpha: 0.2),
                        labelStyle: TextStyle(color: textColor),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text('Tag ${creature.ageInDays}'),
                        avatar: const Icon(Icons.calendar_today, size: 16),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Colors.black.withValues(alpha: 0.2),
                        labelStyle: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                  Text(
                    _getMoodText(creature.mood),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.white70 : _getMoodColor(creature.mood),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCreatureIcon(String id) {
    switch (id) {
      case 'cat': return Icons.pets;
      case 'dog': return Icons.pets;
      case 'dragon': return Icons.local_fire_department;
      case 'rabbit': return Icons.cruelty_free;
      case 'fox': return Icons.pets;
      case 'bird': return Icons.flutter_dash;
      case 'slime': return Icons.bubble_chart;
      case 'goblin': return Icons.face;
      case 'ghost': return Icons.nights_stay;
      case 'elemental': return Icons.auto_awesome;
      case 'golem': return Icons.landscape;
      case 'shadow_cat': return Icons.dark_mode;
      default: return Icons.help_outline;
    }
  }

  String _getMoodText(CreatureMood mood) {
    switch (mood) {
      case CreatureMood.happy: return 'Sehr glücklich';
      case CreatureMood.content: return 'Zufrieden';
      case CreatureMood.neutral: return 'Normal';
      case CreatureMood.unhappy: return 'Unglücklich';
      case CreatureMood.miserable: return 'Sehr unglücklich';
    }
  }

  Color _getMoodColor(CreatureMood mood) {
    switch (mood) {
      case CreatureMood.happy: return Colors.green;
      case CreatureMood.content: return Colors.lightGreen;
      case CreatureMood.neutral: return Colors.grey;
      case CreatureMood.unhappy: return Colors.orange;
      case CreatureMood.miserable: return Colors.red;
    }
  }
}

class _CriticalStatBanner extends StatelessWidget {
  final Creature creature;

  const _CriticalStatBanner({required this.creature});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final criticalStat = creature.mostCriticalStat;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: theme.colorScheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getWarningText(criticalStat),
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }

  String _getWarningText(String? stat) {
    switch (stat) {
      case 'health': return 'Deine Kreatur braucht Medizin!';
      case 'hunger': return 'Deine Kreatur hat Hunger!';
      case 'happiness': return 'Deine Kreatur ist traurig!';
      case 'energy': return 'Deine Kreatur ist erschöpft!';
      case 'cleanliness': return 'Deine Kreatur muss gewaschen werden!';
      default: return 'Deine Kreatur braucht Aufmerksamkeit!';
    }
  }
}

class _StatusCard extends StatelessWidget {
  final Creature creature;

  const _StatusCard({required this.creature});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _StatBar(label: 'Hunger', value: creature.hunger / 100, color: Colors.orange, icon: Icons.restaurant),
            const SizedBox(height: 8),
            _StatBar(label: 'Glück', value: creature.happiness / 100, color: Colors.pink, icon: Icons.favorite),
            const SizedBox(height: 8),
            _StatBar(label: 'Energie', value: creature.energy / 100, color: Colors.amber, icon: Icons.bolt),
            const SizedBox(height: 8),
            _StatBar(label: 'Gesundheit', value: creature.health / 100, color: Colors.green, icon: Icons.health_and_safety),
            const SizedBox(height: 8),
            _StatBar(label: 'Sauberkeit', value: creature.cleanliness / 100, color: Colors.blue, icon: Icons.water_drop),
          ],
        ),
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;

  const _StatBar({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCritical = value < 0.2;

    return Row(
      children: [
        Icon(icon, size: 20, color: isCritical ? Colors.red : color),
        const SizedBox(width: 8),
        SizedBox(
          width: 90,
          child: Text(label, style: theme.textTheme.bodyMedium),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor: (isCritical ? Colors.red : color).withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(isCritical ? Colors.red : color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Text(
            '${(value * 100).round()}%',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isCritical ? Colors.red : null,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _ActionsCard extends StatelessWidget {
  final Creature creature;
  final Map<ActionType, Duration?> cooldowns;
  final VoidCallback onFeed;
  final VoidCallback onPlay;
  final VoidCallback onSleep;
  final VoidCallback onClean;
  final VoidCallback onTrain;
  final VoidCallback onMedicine;

  const _ActionsCard({
    required this.creature,
    required this.cooldowns,
    required this.onFeed,
    required this.onPlay,
    required this.onSleep,
    required this.onClean,
    required this.onTrain,
    required this.onMedicine,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canInteract = !creature.isDead && !creature.isStunned;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aktionen',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildActionWithCooldown(
                  ActionType.feed,
                  _ActionButton(
                    icon: Icons.restaurant,
                    label: 'Füttern',
                    color: Colors.orange,
                    onPressed: canInteract && !creature.isSleeping ? onFeed : null,
                  ),
                ),
                _buildActionWithCooldown(
                  ActionType.play,
                  _ActionButton(
                    icon: Icons.sports_esports,
                    label: 'Spielen',
                    color: Colors.pink,
                    onPressed: canInteract && !creature.isSleeping && creature.energy >= 10 ? onPlay : null,
                  ),
                ),
                _ActionButton(
                  icon: creature.isSleeping ? Icons.wb_sunny : Icons.bedtime,
                  label: creature.isSleeping ? 'Aufwecken' : 'Schlafen',
                  color: Colors.indigo,
                  onPressed: canInteract ? onSleep : null,
                ),
                _buildActionWithCooldown(
                  ActionType.clean,
                  _ActionButton(
                    icon: Icons.shower,
                    label: 'Waschen',
                    color: Colors.blue,
                    onPressed: canInteract && !creature.isSleeping ? onClean : null,
                  ),
                ),
                if (creature.canTrain)
                  _buildActionWithCooldown(
                    ActionType.train,
                    _ActionButton(
                      icon: Icons.fitness_center,
                      label: 'Trainieren',
                      color: Colors.green,
                      onPressed: creature.energy >= 20 ? onTrain : null,
                    ),
                  ),
                _buildActionWithCooldown(
                  ActionType.medicine,
                  _ActionButton(
                    icon: Icons.medical_services,
                    label: 'Medizin',
                    color: Colors.red,
                    onPressed: canInteract && !creature.isSleeping ? onMedicine : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionWithCooldown(ActionType action, Widget child) {
    final remaining = cooldowns[action];
    if (remaining == null || remaining.inSeconds <= 0) {
      return child;
    }
    return CooldownIndicator(
      remainingTime: remaining,
      action: action,
      child: child,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filled(
          onPressed: onPressed,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: isDisabled
                ? Colors.grey.withValues(alpha: 0.3)
                : color.withValues(alpha: 0.15),
            foregroundColor: isDisabled ? Colors.grey : color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isDisabled ? Colors.grey : null,
          ),
        ),
      ],
    );
  }
}

class _BattleStatsCard extends StatelessWidget {
  final Creature creature;

  const _BattleStatsCard({required this.creature});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sports_mma, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Kampfwerte',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _BattleStat(
                  icon: Icons.flash_on,
                  label: 'Angriff',
                  value: creature.totalAttack,
                  color: Colors.red,
                ),
                _BattleStat(
                  icon: Icons.shield,
                  label: 'Verteidigung',
                  value: creature.totalDefense,
                  color: Colors.blue,
                ),
                _BattleStat(
                  icon: Icons.speed,
                  label: 'Speed',
                  value: creature.totalSpeed,
                  color: Colors.green,
                ),
                _BattleStat(
                  icon: Icons.local_fire_department,
                  label: 'Power',
                  value: creature.combatPower,
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BattleStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  const _BattleStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}

class _CreatureSwitcherSheet extends StatelessWidget {
  final List<Creature> creatures;
  final String? activeId;
  final ValueChanged<String> onSelect;
  final VoidCallback onCreateNew;

  const _CreatureSwitcherSheet({
    required this.creatures,
    this.activeId,
    required this.onSelect,
    required this.onCreateNew,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kreatur wählen',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...creatures.map((creature) => ListTile(
            leading: CircleAvatar(
              backgroundColor: creature.type.category == CreatureCategory.animal
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.purple.withValues(alpha: 0.2),
              child: const Icon(Icons.pets),
            ),
            title: Text(creature.name),
            subtitle: Text('${creature.type.name} · ${creature.stage.displayName}'),
            trailing: creature.id == activeId
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null,
            onTap: () => onSelect(creature.id),
          )),
          if (creatures.length < 5)
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.add)),
              title: const Text('Neue Kreatur erschaffen'),
              onTap: onCreateNew,
            ),
        ],
      ),
    );
  }
}

class _FeedDialog extends StatelessWidget {
  final void Function(int hungerGain, int weightGain) onFeed;

  const _FeedDialog({required this.onFeed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Füttern',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.brown, child: Icon(Icons.set_meal, color: Colors.white)),
            title: const Text('Normales Futter'),
            subtitle: const Text('+10 Hunger, +2 Gewicht'),
            onTap: () => onFeed(10, 2),
          ),
          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.star, color: Colors.white)),
            title: const Text('Premium-Futter'),
            subtitle: const Text('+20 Hunger, +5 Glück, +1 Gewicht'),
            onTap: () => onFeed(20, 1),
          ),
          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.pink, child: Icon(Icons.cake, color: Colors.white)),
            title: const Text('Snack'),
            subtitle: const Text('+5 Hunger, +10 Glück, +5 Gewicht'),
            onTap: () => onFeed(5, 5),
          ),
        ],
      ),
    );
  }
}

class _TrainDialog extends StatelessWidget {
  final Creature creature;
  final void Function(String statType) onTrain;

  const _TrainDialog({required this.creature, required this.onTrain});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Training (-20 Energie)',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.red, child: Icon(Icons.flash_on, color: Colors.white)),
            title: const Text('Angriff trainieren'),
            subtitle: Text('Aktuell: ${creature.totalAttack} (+${creature.trainedAttack})'),
            onTap: () => onTrain('attack'),
          ),
          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.shield, color: Colors.white)),
            title: const Text('Verteidigung trainieren'),
            subtitle: Text('Aktuell: ${creature.totalDefense} (+${creature.trainedDefense})'),
            onTap: () => onTrain('defense'),
          ),
          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.speed, color: Colors.white)),
            title: const Text('Geschwindigkeit trainieren'),
            subtitle: Text('Aktuell: ${creature.totalSpeed} (+${creature.trainedSpeed})'),
            onTap: () => onTrain('speed'),
          ),
        ],
      ),
    );
  }
}

class _CooldownDisplay extends StatelessWidget {
  final Map<ActionType, Duration?> cooldowns;

  const _CooldownDisplay({required this.cooldowns});

  @override
  Widget build(BuildContext context) {
    final activeCooldowns = cooldowns.entries
        .where((e) => e.value != null && e.value!.inSeconds > 0)
        .toList();

    if (activeCooldowns.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CooldownStatusRow(cooldowns: cooldowns),
    );
  }
}

class _MedicineDialog extends StatelessWidget {
  final String userId;
  final void Function(String itemId) onGiveMedicine;

  const _MedicineDialog({
    required this.userId,
    required this.onGiveMedicine,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final medicineItems = ItemCatalog.getByCategory(ItemCategory.medicine);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medical_services, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                'Medizin geben',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Wähle eine Medizin aus deinem Inventar:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ...medicineItems.map((item) => ListTile(
            leading: CircleAvatar(
              backgroundColor: _getMedicineColor(item.id),
              child: const Icon(Icons.healing, color: Colors.white),
            ),
            title: Text(item.name),
            subtitle: Text(_getMedicineEffectText(item)),
            trailing: Text(
              '${item.priceSatoshis} sats',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            onTap: () => onGiveMedicine(item.id),
          )),
          const SizedBox(height: 8),
          Text(
            'Hinweis: Du brauchst die Medizin im Inventar.',
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Color _getMedicineColor(String id) {
    switch (id) {
      case 'medicine_basic':
        return Colors.green;
      case 'medicine_advanced':
        return Colors.blue;
      case 'medicine_cure_all':
        return Colors.purple;
      case 'medicine_energy':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  String _getMedicineEffectText(Item item) {
    final effects = <String>[];
    if (item.healthEffect > 0) effects.add('+${item.healthEffect} Gesundheit');
    if (item.happinessEffect > 0) effects.add('+${item.happinessEffect} Glück');
    if (item.energyEffect > 0) effects.add('+${item.energyEffect} Energie');
    return effects.join(', ');
  }
}
