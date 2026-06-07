import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../data/models/pet_model.dart';
import 'bcs_score_card.dart';

class PetListCard extends StatelessWidget {
  final PetModel pet;
  final VoidCallback onTap;

  const PetListCard({super.key, required this.pet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final latest = pet.latestAnalysis;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(pet.speciesEmoji,
                    style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pet.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(
                    '${pet.breed?.name ?? 'Unknown'} · ${pet.genderLabel}',
                    style: const TextStyle(
                        color: AppColors.textMedium, fontSize: 12),
                  ),
                  if (latest != null) ...[
                    const SizedBox(height: 5),
                    _BcsDot(score: latest.bcsScore, category: latest.bcsCategory),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textLight, size: 22),
          ],
        ),
      ),
    );
  }
}

class _BcsDot extends StatelessWidget {
  final int score;
  final String category;
  const _BcsDot({required this.score, required this.category});

  @override
  Widget build(BuildContext context) {
    final color = BcsScoreCard.colorForScore(score);
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          'BCS $score · $category',
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
