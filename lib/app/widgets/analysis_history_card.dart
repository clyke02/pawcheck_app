import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../data/models/analysis_model.dart';
import 'bcs_score_card.dart';

class AnalysisHistoryCard extends StatelessWidget {
  final AnalysisModel analysis;
  final VoidCallback? onDelete;

  const AnalysisHistoryCard({
    super.key,
    required this.analysis,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = BcsScoreCard.colorForScore(analysis.bcsScore);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          // BCS color dot + emoji
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(analysis.bcsEmoji,
                  style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration:
                          BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'BCS ${analysis.bcsScore} · ${analysis.bcsCategory}',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: color),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${analysis.weightKg} kg · MER ${analysis.mer.toStringAsFixed(0)} kkal/hari',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMedium),
                ),
                const SizedBox(height: 2),
                Text(
                  analysis.timeAgo,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textLight),
                ),
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.textLight, size: 20),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
