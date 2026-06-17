import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../data/models/analysis_model.dart';
import 'bcs_score_card.dart';

class AnalysisHistoryCard extends StatelessWidget {
  final AnalysisModel analysis;
  final VoidCallback? onTap;

  const AnalysisHistoryCard({
    super.key,
    required this.analysis,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = BcsScoreCard.colorForScore(analysis.bcsScore);
    final darkColor = _darkColor(analysis.bcsScore);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.055),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Score badge
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, darkColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${analysis.bcsScore}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  Text(
                    '/5',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'BCS ${analysis.bcsScore}',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: color,
                        ),
                      ),
                      Text(
                        '  ·  ${analysis.bcsCategory}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${analysis.weightKg} kg  ·  MER ${analysis.mer.toStringAsFixed(0)} kkal/hari',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMedium,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    analysis.timeAgo,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textMedium.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right_rounded, color: color, size: 22),
          ],
        ),
      ),
    );
  }

  static Color _darkColor(int score) {
    switch (score) {
      case 1: return const Color(0xFFB71C1C);
      case 2: return const Color(0xFFBF360C);
      case 3: return const Color(0xFF2E7D32);
      case 4: return const Color(0xFFBF360C);
      case 5: return const Color(0xFFB71C1C);
      default: return const Color(0xFF424242);
    }
  }
}
