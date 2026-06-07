import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class BcsScoreCard extends StatelessWidget {
  final int score;
  final String category;
  final double rer;
  final double mer;

  const BcsScoreCard({
    super.key,
    required this.score,
    required this.category,
    required this.rer,
    required this.mer,
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

  Color get _color => colorForScore(score);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          // Score + emoji
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emojiForScore(score),
                  style: const TextStyle(fontSize: 44)),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BCS $score/5',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: _color),
                  ),
                  Text(
                    category,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _color),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Scale bar
          _ScaleBar(activeScore: score),
          const SizedBox(height: 16),
          // RER / MER
          Row(
            children: [
              Expanded(
                child: _MetricChip(
                  label: 'RER',
                  value: '${rer.toStringAsFixed(0)} kkal',
                  tooltip: 'Resting Energy Requirement',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricChip(
                  label: 'MER',
                  value: '${mer.toStringAsFixed(0)} kkal',
                  tooltip: 'Maintenance Energy Requirement',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScaleBar extends StatelessWidget {
  final int activeScore;
  const _ScaleBar({required this.activeScore});

  static const _colors = [
    Color(0xFFE53935),
    Color(0xFFFF7043),
    AppColors.success,
    Color(0xFFFF7043),
    Color(0xFFE53935),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final isActive = (i + 1) == activeScore;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 4 ? 4 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isActive ? 36 : 28,
              decoration: BoxDecoration(
                color: isActive
                    ? _colors[i]
                    : _colors[i].withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : _colors[i].withValues(alpha: 0.7),
                    fontWeight:
                        isActive ? FontWeight.w800 : FontWeight.w500,
                    fontSize: isActive ? 14 : 12,
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

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;
  final String tooltip;

  const _MetricChip({
    required this.label,
    required this.value,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          Text(tooltip,
              style: const TextStyle(
                  fontSize: 9, color: AppColors.textLight),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
