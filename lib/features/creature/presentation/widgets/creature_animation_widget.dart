import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../domain/models/creature.dart';
import '../../domain/models/creature_type.dart';

/// The animation state of a creature.
enum CreatureAnimationState {
  idle,
  eating,
  sleeping,
  playing,
  fighting,
  dead,
}

/// Animated creature widget using CustomPainter.
/// Renders stylized vector creatures with state-specific animations.
class CreatureAnimationWidget extends StatefulWidget {
  final Creature creature;
  final double size;

  const CreatureAnimationWidget({
    super.key,
    required this.creature,
    this.size = 120,
  });

  @override
  State<CreatureAnimationWidget> createState() => _CreatureAnimationWidgetState();
}

class _CreatureAnimationWidgetState extends State<CreatureAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _secondaryController;
  late Animation<double> _primaryAnimation;
  late Animation<double> _secondaryAnimation;

  CreatureAnimationState get _animState {
    if (widget.creature.isDead) return CreatureAnimationState.dead;
    if (widget.creature.isSleeping) return CreatureAnimationState.sleeping;
    return CreatureAnimationState.idle;
  }

  @override
  void initState() {
    super.initState();
    _primaryController = AnimationController(
      vsync: this,
      duration: _getPrimaryDuration(),
    )..repeat(reverse: true);

    _secondaryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: false);

    _primaryAnimation = CurvedAnimation(
      parent: _primaryController,
      curve: Curves.easeInOut,
    );
    _secondaryAnimation = CurvedAnimation(
      parent: _secondaryController,
      curve: Curves.linear,
    );
  }

  Duration _getPrimaryDuration() {
    switch (_animState) {
      case CreatureAnimationState.sleeping:
        return const Duration(milliseconds: 2400);
      case CreatureAnimationState.dead:
        return const Duration(milliseconds: 3000);
      default:
        return const Duration(milliseconds: 1200);
    }
  }

  @override
  void didUpdateWidget(CreatureAnimationWidget old) {
    super.didUpdateWidget(old);
    if (_animState != _getAnimStateFrom(old.creature)) {
      _primaryController.duration = _getPrimaryDuration();
    }
  }

  CreatureAnimationState _getAnimStateFrom(Creature c) {
    if (c.isDead) return CreatureAnimationState.dead;
    if (c.isSleeping) return CreatureAnimationState.sleeping;
    return CreatureAnimationState.idle;
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_primaryAnimation, _secondaryAnimation]),
      builder: (context, _) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _CreaturePainter(
              typeId: widget.creature.type.id,
              category: widget.creature.type.category,
              stage: widget.creature.stage,
              animState: _animState,
              primaryAnim: _primaryAnimation.value,
              secondaryAnim: _secondaryAnimation.value,
              mood: widget.creature.mood,
            ),
          ),
        );
      },
    );
  }
}

class _CreaturePainter extends CustomPainter {
  final String typeId;
  final CreatureCategory category;
  final DevelopmentStage stage;
  final CreatureAnimationState animState;
  final double primaryAnim;   // 0.0–1.0, easeInOut back/forth
  final double secondaryAnim; // 0.0–1.0, continuous loop
  final CreatureMood mood;

  const _CreaturePainter({
    required this.typeId,
    required this.category,
    required this.stage,
    required this.animState,
    required this.primaryAnim,
    required this.secondaryAnim,
    required this.mood,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * _stageScale * 0.38;

    // Bob offset (idle/sleeping breathing)
    final bobY = _getBobOffset();
    final drawCenter = Offset(center.dx, center.dy + bobY);

    if (stage == DevelopmentStage.egg) {
      _drawEgg(canvas, drawCenter, baseRadius, size);
    } else {
      _drawCreature(canvas, drawCenter, baseRadius, size);
    }

    if (animState == CreatureAnimationState.sleeping) {
      _drawZzz(canvas, drawCenter, baseRadius);
    }
  }

  double get _stageScale {
    switch (stage) {
      case DevelopmentStage.egg:   return 0.75;
      case DevelopmentStage.baby:  return 0.65;
      case DevelopmentStage.child: return 0.80;
      case DevelopmentStage.teen:  return 0.90;
      case DevelopmentStage.adult: return 1.00;
    }
  }

  double _getBobOffset() {
    if (animState == CreatureAnimationState.sleeping) {
      return math.sin(primaryAnim * math.pi) * 4.0;
    }
    if (animState == CreatureAnimationState.dead) {
      return 6.0;
    }
    return math.sin(primaryAnim * math.pi) * 3.5;
  }

  // ─── Egg ───────────────────────────────────────────────────────────────────

  void _drawEgg(Canvas canvas, Offset center, double radius, Size size) {
    final eggColor = _primaryColor;
    final paint = Paint()..color = eggColor;
    final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.15);

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.85),
        width: radius * 1.4,
        height: radius * 0.35,
      ),
      shadowPaint,
    );

    // Egg body
    final eggPath = Path();
    eggPath.addOval(Rect.fromCenter(
      center: center,
      width: radius * 1.5,
      height: radius * 1.9,
    ));
    canvas.drawPath(eggPath, paint);

    // Egg shine
    final shinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.2, center.dy - radius * 0.3),
        width: radius * 0.4,
        height: radius * 0.25,
      ),
      shinePaint,
    );

    // Small cracks for near-hatching feel
    final crackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final crackPath = Path();
    crackPath.moveTo(center.dx - 4, center.dy - radius * 0.3);
    crackPath.lineTo(center.dx + 2, center.dy - radius * 0.1);
    crackPath.lineTo(center.dx - 3, center.dy + radius * 0.1);
    canvas.drawPath(crackPath, crackPaint);
  }

  // ─── Main creature ──────────────────────────────────────────────────────────

  void _drawCreature(Canvas canvas, Offset center, double radius, Size size) {
    // Shadow
    final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.15);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.9),
        width: radius * 1.7,
        height: radius * 0.4,
      ),
      shadowPaint,
    );

    // Draw unique appendages behind body
    _drawAppendagesBehind(canvas, center, radius);

    // Body
    _drawBody(canvas, center, radius);

    // Appendages in front
    _drawAppendagesFront(canvas, center, radius);

    // Face
    _drawFace(canvas, center, radius);
  }

  void _drawBody(Canvas canvas, Offset center, double radius) {
    final paint = Paint()..color = _primaryColor;
    final highlightPaint = Paint()..color = _secondaryColor;

    switch (typeId) {
      case 'slime':
      case 'ghost':
        _drawBlobBody(canvas, center, radius, paint);
      case 'golem':
        _drawRockyBody(canvas, center, radius, paint, highlightPaint);
      default:
        _drawRoundBody(canvas, center, radius, paint, highlightPaint);
    }
  }

  void _drawRoundBody(Canvas canvas, Offset center, double radius,
      Paint main, Paint highlight) {
    canvas.drawCircle(center, radius, main);
    // Belly highlight
    canvas.drawCircle(
      Offset(center.dx, center.dy + radius * 0.15),
      radius * 0.65,
      highlight,
    );
  }

  void _drawBlobBody(Canvas canvas, Offset center, double radius,
      Paint main) {
    final squish = 1.0 + primaryAnim * 0.08;
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 2.0 * squish,
        height: radius * 2.0 / squish,
      ),
      main,
    );
  }

  void _drawRockyBody(Canvas canvas, Offset center, double radius,
      Paint main, Paint highlight) {
    final path = Path();
    final r = radius;
    path.moveTo(center.dx, center.dy - r);
    path.lineTo(center.dx + r * 0.8, center.dy - r * 0.4);
    path.lineTo(center.dx + r * 0.9, center.dy + r * 0.5);
    path.lineTo(center.dx + r * 0.3, center.dy + r);
    path.lineTo(center.dx - r * 0.3, center.dy + r);
    path.lineTo(center.dx - r * 0.9, center.dy + r * 0.5);
    path.lineTo(center.dx - r * 0.8, center.dy - r * 0.4);
    path.close();
    canvas.drawPath(path, main);
    canvas.drawPath(path, Paint()..color = highlight..style = PaintingStyle.fill);
    canvas.drawCircle(center, radius * 0.55, Paint()..color = highlight);
  }

  void _drawAppendagesBehind(Canvas canvas, Offset center, double radius) {
    switch (typeId) {
      case 'cat':
      case 'shadow_cat':
        _drawCatTail(canvas, center, radius, behind: true);
      case 'fox':
        _drawFoxTail(canvas, center, radius);
      case 'bird':
        _drawWings(canvas, center, radius, behind: true);
      case 'dragon':
        _drawDragonWings(canvas, center, radius);
      case 'ghost':
        _drawGhostTail(canvas, center, radius);
      default:
        break;
    }
  }

  void _drawAppendagesFront(Canvas canvas, Offset center, double radius) {
    switch (typeId) {
      case 'cat':
      case 'shadow_cat':
        _drawEars(canvas, center, radius, pointy: true);
      case 'dog':
        _drawEars(canvas, center, radius, pointy: false);
      case 'rabbit':
        _drawRabbitEars(canvas, center, radius);
      case 'fox':
        _drawEars(canvas, center, radius, pointy: true);
      case 'goblin':
        _drawGoblinEars(canvas, center, radius);
      case 'bird':
        _drawWings(canvas, center, radius, behind: false);
      case 'elemental':
        _drawElementalAura(canvas, center, radius);
      default:
        break;
    }
  }

  // ─── Ears & appendages ─────────────────────────────────────────────────────

  void _drawEars(Canvas canvas, Offset center, double radius, {required bool pointy}) {
    final earPaint = Paint()..color = _primaryColor;
    final innerPaint = Paint()..color = _accentColor;
    final earW = radius * 0.45;
    final earH = radius * (pointy ? 0.7 : 0.5);
    final earY = center.dy - radius * 0.75;

    for (final side in [-1.0, 1.0]) {
      final ex = center.dx + side * radius * 0.55;
      if (pointy) {
        final path = Path()
          ..moveTo(ex - earW / 2, earY + earH)
          ..lineTo(ex, earY - earH * 0.5)
          ..lineTo(ex + earW / 2, earY + earH)
          ..close();
        canvas.drawPath(path, earPaint);
        final innerPath = Path()
          ..moveTo(ex - earW * 0.3, earY + earH * 0.6)
          ..lineTo(ex, earY - earH * 0.1)
          ..lineTo(ex + earW * 0.3, earY + earH * 0.6)
          ..close();
        canvas.drawPath(innerPath, innerPaint);
      } else {
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(ex, earY),
            width: earW,
            height: earH,
          ),
          earPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(ex, earY),
            width: earW * 0.6,
            height: earH * 0.65,
          ),
          innerPaint,
        );
      }
    }
  }

  void _drawRabbitEars(Canvas canvas, Offset center, double radius) {
    final earPaint = Paint()..color = _primaryColor;
    final innerPaint = Paint()..color = _accentColor;

    for (final side in [-1.0, 1.0]) {
      final ex = center.dx + side * radius * 0.42;
      final earRect = Rect.fromCenter(
        center: Offset(ex, center.dy - radius * 1.2),
        width: radius * 0.3,
        height: radius * 0.9,
      );
      canvas.drawOval(earRect, earPaint);
      canvas.drawOval(
        Rect.fromCenter(
          center: earRect.center,
          width: radius * 0.15,
          height: radius * 0.6,
        ),
        innerPaint,
      );
    }
  }

  void _drawGoblinEars(Canvas canvas, Offset center, double radius) {
    final paint = Paint()..color = _primaryColor;
    for (final side in [-1.0, 1.0]) {
      final path = Path()
        ..moveTo(center.dx + side * radius * 0.85, center.dy - radius * 0.1)
        ..lineTo(center.dx + side * radius * 1.4, center.dy - radius * 0.4)
        ..lineTo(center.dx + side * radius * 1.3, center.dy + radius * 0.2)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  void _drawCatTail(Canvas canvas, Offset center, double radius, {required bool behind}) {
    if (!behind) return;
    final tailPaint = Paint()
      ..color = _primaryColor
      ..strokeWidth = radius * 0.22
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final swing = math.sin(primaryAnim * math.pi) * 20;
    final path = Path()
      ..moveTo(center.dx - radius * 0.5, center.dy + radius * 0.6)
      ..quadraticBezierTo(
        center.dx - radius * 1.6,
        center.dy + radius * 0.3 + swing,
        center.dx - radius * 1.2,
        center.dy - radius * 0.4 + swing * 0.5,
      );
    canvas.drawPath(path, tailPaint);
  }

  void _drawFoxTail(Canvas canvas, Offset center, double radius) {
    final tailPaint = Paint()..color = _primaryColor;
    final tipPaint = Paint()..color = Colors.white;
    final swing = math.sin(primaryAnim * math.pi) * 18;
    final tipX = center.dx - radius * 1.3;
    final tipY = center.dy - radius * 0.3 + swing * 0.5;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(tipX, tipY),
        width: radius * 0.8,
        height: radius * 0.6,
      ),
      tailPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(tipX, tipY),
        width: radius * 0.45,
        height: radius * 0.35,
      ),
      tipPaint,
    );
  }

  void _drawWings(Canvas canvas, Offset center, double radius, {required bool behind}) {
    if (!behind) return;
    final wingPaint = Paint()..color = _primaryColor.withValues(alpha: 0.9);
    final flapAngle = primaryAnim * 0.4;

    for (final side in [-1.0, 1.0]) {
      canvas.save();
      canvas.translate(center.dx + side * radius * 0.7, center.dy);
      canvas.rotate(side * flapAngle);
      final path = Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(side * radius * 0.9, -radius * 0.7, side * radius * 1.1, radius * 0.2)
        ..quadraticBezierTo(side * radius * 0.5, radius * 0.3, 0, 0)
        ..close();
      canvas.drawPath(path, wingPaint);
      canvas.restore();
    }
  }

  void _drawDragonWings(Canvas canvas, Offset center, double radius) {
    final wingPaint = Paint()..color = _accentColor.withValues(alpha: 0.85);
    final flapAngle = primaryAnim * 0.35;

    for (final side in [-1.0, 1.0]) {
      canvas.save();
      canvas.translate(center.dx + side * radius * 0.5, center.dy - radius * 0.2);
      canvas.rotate(side * flapAngle);
      final path = Path()
        ..moveTo(0, 0)
        ..lineTo(side * radius * 1.3, -radius * 0.9)
        ..lineTo(side * radius * 1.5, -radius * 0.2)
        ..lineTo(side * radius * 1.1, radius * 0.4)
        ..close();
      canvas.drawPath(path, wingPaint);
      canvas.restore();
    }
  }

  void _drawGhostTail(Canvas canvas, Offset center, double radius) {
    final paint = Paint()..color = _primaryColor;
    final wave = math.sin(secondaryAnim * math.pi * 2) * 4;
    final path = Path();
    final bottom = center.dy + radius;
    path.moveTo(center.dx - radius, bottom);
    path.cubicTo(
      center.dx - radius * 0.5, bottom + radius * 0.5 + wave,
      center.dx, bottom + radius * 0.3 - wave,
      center.dx + radius * 0.5, bottom + radius * 0.5 + wave,
    );
    path.cubicTo(
      center.dx + radius * 0.7, bottom + radius * 0.3 - wave,
      center.dx + radius * 0.9, bottom + radius * 0.5,
      center.dx + radius, bottom,
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawElementalAura(Canvas canvas, Offset center, double radius) {
    final auraPaint = Paint()
      ..color = _primaryColor.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    final orbCount = 4;
    for (var i = 0; i < orbCount; i++) {
      final angle = secondaryAnim * math.pi * 2 + i * math.pi * 2 / orbCount;
      final orbCenter = Offset(
        center.dx + math.cos(angle) * radius * 1.15,
        center.dy + math.sin(angle) * radius * 0.9,
      );
      canvas.drawCircle(orbCenter, radius * 0.2, auraPaint);
      canvas.drawCircle(orbCenter, radius * 0.12, Paint()..color = _primaryColor);
    }
  }

  // ─── Face ──────────────────────────────────────────────────────────────────

  void _drawFace(Canvas canvas, Offset center, double radius) {
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = _eyeColor;
    final outlinePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    if (animState == CreatureAnimationState.dead) {
      _drawDeadFace(canvas, center, radius, outlinePaint);
      return;
    }

    final eyeY = center.dy - radius * 0.18;
    final eyeX = radius * 0.32;
    final eyeRadius = radius * 0.18;

    if (animState == CreatureAnimationState.sleeping) {
      // Closed eyes (arcs)
      for (final side in [-1.0, 1.0]) {
        final ex = center.dx + side * eyeX;
        final rect = Rect.fromCenter(
          center: Offset(ex, eyeY),
          width: eyeRadius * 2.2,
          height: eyeRadius * 2.2,
        );
        canvas.drawArc(rect, 0, math.pi, false, outlinePaint);
      }
    } else {
      // Open eyes
      for (final side in [-1.0, 1.0]) {
        final ex = center.dx + side * eyeX;
        canvas.drawCircle(Offset(ex, eyeY), eyeRadius, eyePaint);
        canvas.drawCircle(Offset(ex, eyeY), eyeRadius, outlinePaint);
        canvas.drawCircle(
          Offset(ex + eyeRadius * 0.2, eyeY + eyeRadius * 0.1),
          eyeRadius * 0.55,
          pupilPaint,
        );
        canvas.drawCircle(
          Offset(ex - eyeRadius * 0.15, eyeY - eyeRadius * 0.15),
          eyeRadius * 0.15,
          Paint()..color = Colors.white,
        );
      }
    }

    // Mouth / expression
    _drawMouth(canvas, center, radius, outlinePaint);

    // Ghost / elemental special eyes (glow)
    if (typeId == 'ghost' || typeId == 'elemental') {
      for (final side in [-1.0, 1.0]) {
        final ex = center.dx + side * eyeX;
        final glowPaint = Paint()
          ..color = _primaryColor.withValues(alpha: 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
        canvas.drawCircle(Offset(ex, eyeY), eyeRadius * 1.5, glowPaint);
      }
    }
  }

  void _drawMouth(Canvas canvas, Offset center, double radius, Paint outlinePaint) {
    final mouthY = center.dy + radius * 0.25;
    final mouthW = radius * 0.42;
    final rect = Rect.fromCenter(
      center: Offset(center.dx, mouthY),
      width: mouthW * 2,
      height: mouthW,
    );

    switch (mood) {
      case CreatureMood.happy:
      case CreatureMood.content:
        canvas.drawArc(rect, 0, math.pi, false, outlinePaint);
      case CreatureMood.neutral:
        canvas.drawLine(
          Offset(center.dx - mouthW * 0.6, mouthY),
          Offset(center.dx + mouthW * 0.6, mouthY),
          outlinePaint,
        );
      case CreatureMood.unhappy:
      case CreatureMood.miserable:
        canvas.drawArc(rect, math.pi, math.pi, false, outlinePaint);
    }
  }

  void _drawDeadFace(Canvas canvas, Offset center, double radius, Paint paint) {
    final eyeY = center.dy - radius * 0.18;
    final eyeX = radius * 0.32;
    final s = radius * 0.18;
    for (final side in [-1.0, 1.0]) {
      final ex = center.dx + side * eyeX;
      canvas.drawLine(Offset(ex - s, eyeY - s), Offset(ex + s, eyeY + s), paint);
      canvas.drawLine(Offset(ex + s, eyeY - s), Offset(ex - s, eyeY + s), paint);
    }
    // Flat mouth
    canvas.drawLine(
      Offset(center.dx - radius * 0.3, center.dy + radius * 0.3),
      Offset(center.dx + radius * 0.3, center.dy + radius * 0.3),
      paint,
    );
  }

  // ─── Sleeping Zzz ──────────────────────────────────────────────────────────

  void _drawZzz(Canvas canvas, Offset center, double radius) {
    final progress = secondaryAnim;
    final zCount = 3;

    for (var i = 0; i < zCount; i++) {
      final offset = ((progress + i / zCount) % 1.0);
      final alpha = (math.sin(offset * math.pi)).clamp(0.0, 1.0);
      if (alpha < 0.05) continue;

      final zSize = 8.0 + i * 4.0 + offset * 6;
      final zX = center.dx + radius * 0.8 + i * 6 + offset * 10;
      final zY = center.dy - radius * 0.6 - offset * (radius * 0.8) - i * 8;

      final paint = Paint()
        ..color = Colors.indigo.withValues(alpha: alpha * 0.85)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      // Draw "Z" shape
      canvas.drawLine(Offset(zX - zSize / 2, zY - zSize / 2), Offset(zX + zSize / 2, zY - zSize / 2), paint);
      canvas.drawLine(Offset(zX + zSize / 2, zY - zSize / 2), Offset(zX - zSize / 2, zY + zSize / 2), paint);
      canvas.drawLine(Offset(zX - zSize / 2, zY + zSize / 2), Offset(zX + zSize / 2, zY + zSize / 2), paint);
    }
  }

  // ─── Colors ────────────────────────────────────────────────────────────────

  Color get _primaryColor {
    switch (typeId) {
      case 'cat':         return const Color(0xFFE8A87C);
      case 'dog':         return const Color(0xFFB5834A);
      case 'dragon':      return const Color(0xFFE05252);
      case 'rabbit':      return const Color(0xFFE8D5C4);
      case 'fox':         return const Color(0xFFE07830);
      case 'bird':        return const Color(0xFF4A90D9);
      case 'slime':       return const Color(0xFF7BC67E);
      case 'goblin':      return const Color(0xFF8EBF7E);
      case 'ghost':       return const Color(0xFFD0D8F0);
      case 'elemental':   return const Color(0xFF9B59B6);
      case 'golem':       return const Color(0xFF8E9BAE);
      case 'shadow_cat':  return const Color(0xFF4A3560);
      default:            return const Color(0xFF9E9E9E);
    }
  }

  Color get _secondaryColor {
    switch (typeId) {
      case 'cat':         return const Color(0xFFF5C9A0);
      case 'dog':         return const Color(0xFFD4A06A);
      case 'dragon':      return const Color(0xFFFF8A65);
      case 'rabbit':      return const Color(0xFFF5EBE0);
      case 'fox':         return const Color(0xFFF5A040);
      case 'bird':        return const Color(0xFF7AB8E8);
      case 'slime':       return const Color(0xFFA8DCA8);
      case 'goblin':      return const Color(0xFFB5D4A5);
      case 'ghost':       return const Color(0xFFEEF2FF);
      case 'elemental':   return const Color(0xFFBE86D4);
      case 'golem':       return const Color(0xFFB0BCCA);
      case 'shadow_cat':  return const Color(0xFF6A5080);
      default:            return const Color(0xFFBDBDBD);
    }
  }

  Color get _accentColor {
    switch (typeId) {
      case 'cat':         return const Color(0xFFFFB0C0);
      case 'dog':         return const Color(0xFFFFD0A0);
      case 'dragon':      return const Color(0xFFFF5722);
      case 'rabbit':      return const Color(0xFFFFB0C0);
      case 'fox':         return const Color(0xFFFFFFFF);
      case 'bird':        return const Color(0xFFFFEB3B);
      case 'slime':       return const Color(0xFFCCFF90);
      case 'goblin':      return const Color(0xFFFFEB3B);
      case 'ghost':       return const Color(0xFFB0BEF8);
      case 'elemental':   return const Color(0xFFE040FB);
      case 'golem':       return const Color(0xFF78909C);
      case 'shadow_cat':  return const Color(0xFF9C27B0);
      default:            return const Color(0xFF757575);
    }
  }

  Color get _eyeColor {
    if (typeId == 'ghost' || typeId == 'elemental') return _accentColor;
    if (typeId == 'shadow_cat') return const Color(0xFFE040FB);
    if (category == CreatureCategory.monster) return const Color(0xFF5D4037);
    return const Color(0xFF37474F);
  }

  @override
  bool shouldRepaint(_CreaturePainter old) {
    return old.primaryAnim != primaryAnim ||
        old.secondaryAnim != secondaryAnim ||
        old.animState != animState ||
        old.mood != mood ||
        old.stage != stage;
  }
}
