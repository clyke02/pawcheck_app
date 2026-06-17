import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class BcsScoreCard extends StatelessWidget {
  final int score;
  final String category;
  final double weightKg;
  final double idealWeightUsed;
  final Widget? headerWidget;
  final bool heroMode;

  const BcsScoreCard({
    super.key,
    required this.score,
    required this.category,
    required this.weightKg,
    required this.idealWeightUsed,
    this.headerWidget,
    this.heroMode = false,
  });

  static Color colorForScore(int score) {
    switch (score) {
      case 1: return const Color(0xFFE53935);
      case 2: return const Color(0xFFFF7043);
      case 3: return AppColors.success;
      case 4: return const Color(0xFFFF7043);
      case 5: return const Color(0xFFE53935);
      default: return AppColors.textMedium;
    }
  }

  static String emojiForScore(int score) {
    switch (score) {
      case 1: return '😟';
      case 2: return '😕';
      case 3: return '😊';
      case 4: return '😅';
      case 5: return '😰';
      default: return '❓';
    }
  }

  static Color _darkColorForScore(int score) {
    switch (score) {
      case 1: return const Color(0xFFB71C1C);
      case 2: return const Color(0xFFBF360C);
      case 3: return const Color(0xFF1B5E20);
      case 4: return const Color(0xFFBF360C);
      case 5: return const Color(0xFFB71C1C);
      default: return const Color(0xFF424242);
    }
  }

  Color get _color => colorForScore(score);
  Color get _darkColor => _darkColorForScore(score);

  BorderRadius get _borderRadius => heroMode
      ? const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        )
      : BorderRadius.circular(24);

  @override
  Widget build(BuildContext context) {
    final diff = weightKg - idealWeightUsed;
    final diffAbs = diff.abs();
    final String diffLabel;
    final Color diffColor;
    if (diff.abs() <= 0.05) {
      diffLabel = 'Berat badan ideal ✓';
      diffColor = AppColors.success;
    } else if (diff > 0) {
      diffLabel = '+${diffAbs.toStringAsFixed(1)} kg dari berat ideal (kelebihan)';
      diffColor = _color;
    } else {
      diffLabel = '-${diffAbs.toStringAsFixed(1)} kg dari berat ideal (kekurangan)';
      diffColor = _color;
    }

    final shadow = heroMode
        ? BoxShadow(
            color: _color.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 6),
          )
        : BoxShadow(
            color: _color.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 8),
          );

    return Container(
      decoration: BoxDecoration(
        borderRadius: _borderRadius,
        boxShadow: [shadow],
      ),
      child: ClipRRect(
        borderRadius: _borderRadius,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                  24, heroMode ? 0 : 24, 24, 22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_color, _darkColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (headerWidget != null) headerWidget!,
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Skor BCS',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.72),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '$score',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 68,
                                    fontWeight: FontWeight.w900,
                                    height: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    '/5',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1.5),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _WhiteScaleBar(activeScore: score, activeColor: _color),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _WeightStat(
                          label: 'Berat Aktual',
                          value: '${weightKg.toStringAsFixed(1)} kg',
                          color: _color,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 42,
                        color: Colors.grey.withValues(alpha: 0.18),
                      ),
                      Expanded(
                        child: _WeightStat(
                          label: 'Berat Ideal',
                          value: '${idealWeightUsed.toStringAsFixed(1)} kg',
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: diffColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      diffLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: diffColor,
                      ),
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
}

class _WeightStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _WeightStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMedium,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        Text(value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }
}

class _WhiteScaleBar extends StatelessWidget {
  final int activeScore;
  final Color activeColor;
  const _WhiteScaleBar({required this.activeScore, required this.activeColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final isActive = (i + 1) == activeScore;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 4 ? 5 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isActive ? 42 : 30,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    color: isActive
                        ? activeColor
                        : Colors.white.withValues(alpha: 0.8),
                    fontWeight:
                        isActive ? FontWeight.w900 : FontWeight.w500,
                    fontSize: isActive ? 16 : 12,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
