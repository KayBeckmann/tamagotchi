import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../domain/models/creature.dart';
import '../../domain/models/creature_type.dart';

class CreatureSprite extends StatefulWidget {
  final Creature creature;
  final double size;
  final Color? color;

  const CreatureSprite({
    super.key,
    required this.creature,
    this.size = 100,
    this.color,
  });

  @override
  State<CreatureSprite> createState() => _CreatureSpriteState();
}

class _CreatureSpriteState extends State<CreatureSprite>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _rotateAnimation = Tween<double>(begin: -0.02, end: 0.02).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = widget.creature.type.category == CreatureCategory.animal
        ? Colors.green
        : Colors.purple;
    
    final displayColor = widget.color ?? categoryColor;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: _buildCreature(displayColor),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCreature(Color color) {
    if (widget.creature.isDead) {
      return Icon(
        Icons.cloud_outlined,
        size: widget.size,
        color: Colors.grey,
      );
    }

    if (widget.creature.isSleeping) {
      return Icon(
        _getCreatureIcon(widget.creature.type.id),
        size: widget.size,
        color: color.withValues(alpha: 0.5),
      );
    }

    // Shadow below creature
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          bottom: 0,
          child: Container(
            width: widget.size * 0.6,
            height: widget.size * 0.1,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
              borderRadius: BorderRadius.all(
                Radius.elliptical(widget.size * 0.3, widget.size * 0.05),
              ),
            ),
          ),
        ),
        Icon(
          _getCreatureIcon(widget.creature.type.id),
          size: widget.size,
          color: color,
        ),
        if (widget.creature.isSick)
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.sick,
              size: widget.size * 0.3,
              color: Colors.green,
            ),
          ),
      ],
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
}
