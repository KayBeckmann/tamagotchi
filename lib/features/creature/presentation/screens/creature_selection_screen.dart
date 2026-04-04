import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/creature_type.dart';
import '../providers/creature_provider.dart';

class CreatureSelectionScreen extends ConsumerWidget {
  const CreatureSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final availableTypes = ref.watch(availableCreatureTypesProvider);
    final creationState = ref.watch(creatureCreationProvider);

    // Group by category
    final animals = availableTypes.where((t) => t.category == CreatureCategory.animal).toList();
    final monsters = availableTypes.where((t) => t.category == CreatureCategory.monster).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wähle deine Kreatur'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          if (creationState.isCreating)
            const LinearProgressIndicator(),

          Expanded(
            child: CustomScrollView(
              slivers: [
                // Info header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welche Kreatur soll dich begleiten?',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Jede Kreatur hat einzigartige Fähigkeiten und Stärken.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Animals section
                SliverToBoxAdapter(
                  child: _SectionHeader(
                    title: 'Tiere',
                    icon: Icons.pets,
                    count: animals.length,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _CreatureTypeCard(
                        creatureType: animals[index],
                        isSelected: creationState.selectedType?.id == animals[index].id,
                        onTap: () => _selectType(ref, animals[index]),
                      ),
                      childCount: animals.length,
                    ),
                  ),
                ),

                // Monsters section
                SliverToBoxAdapter(
                  child: _SectionHeader(
                    title: 'Monster',
                    icon: Icons.whatshot,
                    count: monsters.length,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _CreatureTypeCard(
                        creatureType: monsters[index],
                        isSelected: creationState.selectedType?.id == monsters[index].id,
                        onTap: () => _selectType(ref, monsters[index]),
                      ),
                      childCount: monsters.length,
                    ),
                  ),
                ),

                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
          ),
        ],
      ),
      // Bottom sheet for name input when type is selected
      bottomSheet: creationState.selectedType != null
          ? _CreationBottomSheet(
              selectedType: creationState.selectedType!,
              name: creationState.name,
              isCreating: creationState.isCreating,
              error: creationState.error,
              onNameChanged: (name) => ref.read(creatureCreationProvider.notifier).setName(name),
              onCancel: () => ref.read(creatureCreationProvider.notifier).reset(),
              onCreate: () => _createCreature(context, ref, creationState),
            )
          : null,
    );
  }

  void _selectType(WidgetRef ref, CreatureType type) {
    ref.read(creatureCreationProvider.notifier).selectType(type);
  }

  Future<void> _createCreature(BuildContext context, WidgetRef ref, CreatureCreationState state) async {
    if (!state.isValid) return;

    final notifier = ref.read(creatureCreationProvider.notifier);
    notifier.setCreating(true);

    try {
      // TODO: Get actual user ID
      const userId = 'user_1';
      await ref.read(creatureListProvider(userId).notifier).createCreature(
        typeId: state.selectedType!.id,
        name: state.name,
      );

      notifier.reset();
      if (context.mounted) {
        context.go('/');
      }
    } catch (e) {
      notifier.setError(e.toString());
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatureTypeCard extends StatelessWidget {
  final CreatureType creatureType;
  final bool isSelected;
  final VoidCallback onTap;

  const _CreatureTypeCard({
    required this.creatureType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = creatureType.category == CreatureCategory.animal
        ? Colors.green
        : Colors.purple;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Creature icon placeholder
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      _getCreatureIcon(creatureType.id),
                      size: 48,
                      color: categoryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Name
              Text(
                creatureType.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),

              // Stats preview
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StatChip(icon: Icons.flash_on, value: creatureType.baseAttack, color: Colors.red),
                  const SizedBox(width: 4),
                  _StatChip(icon: Icons.shield, value: creatureType.baseDefense, color: Colors.blue),
                  const SizedBox(width: 4),
                  _StatChip(icon: Icons.speed, value: creatureType.baseSpeed, color: Colors.green),
                ],
              ),
              const SizedBox(height: 4),

              // Description
              Text(
                creatureType.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCreatureIcon(String id) {
    switch (id) {
      case 'cat':
        return Icons.pets;
      case 'dog':
        return Icons.pets;
      case 'dragon':
        return Icons.local_fire_department;
      case 'rabbit':
        return Icons.cruelty_free;
      case 'fox':
        return Icons.pets;
      case 'bird':
        return Icons.flutter_dash;
      case 'slime':
        return Icons.bubble_chart;
      case 'goblin':
        return Icons.face;
      case 'ghost':
        return Icons.nights_stay;
      case 'elemental':
        return Icons.auto_awesome;
      case 'golem':
        return Icons.landscape;
      case 'shadow_cat':
        return Icons.dark_mode;
      default:
        return Icons.help_outline;
    }
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final int value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 2),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _CreationBottomSheet extends StatelessWidget {
  final CreatureType selectedType;
  final String name;
  final bool isCreating;
  final String? error;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onCancel;
  final VoidCallback onCreate;

  const _CreationBottomSheet({
    required this.selectedType,
    required this.name,
    required this.isCreating,
    this.error,
    required this.onNameChanged,
    required this.onCancel,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${selectedType.name} benennen',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onCancel,
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (error != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                error!,
                style: TextStyle(color: theme.colorScheme.onErrorContainer),
              ),
            ),
            const SizedBox(height: 8),
          ],

          TextField(
            onChanged: onNameChanged,
            enabled: !isCreating,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Name deiner Kreatur',
              hintText: 'z.B. Fluffy',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.edit),
              helperText: '2-20 Zeichen',
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: name.length >= 2 && !isCreating ? onCreate : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: isCreating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Kreatur erschaffen'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
