import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../data/models/pet_model.dart';
import '../../routes/app_pages.dart';
import 'pets_controller.dart';

class PetsView extends GetView<PetsController> {
  const PetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hewan Peliharaan')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.pets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🐾', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                const Text('Belum ada hewan peliharaan.',
                    style: TextStyle(color: AppColors.textMedium)),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.toNamed(Routes.analysis),
                  child: const Text('Analisis sekarang'),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.loadPets,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.pets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _PetCard(
              pet: controller.pets[i],
              onTap: () =>
                  Get.toNamed(Routes.petDetail, arguments: controller.pets[i]),
              onDelete: () => controller.confirmDelete(controller.pets[i]),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.toNamed(Routes.analysis),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final PetModel pet;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _PetCard({
    required this.pet,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(pet.speciesEmoji,
                    style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pet.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(
                    '${pet.breed?.name ?? 'Unknown'} • ${pet.genderLabel}',
                    style: const TextStyle(
                        color: AppColors.textMedium, fontSize: 13),
                  ),
                  if (pet.analyses.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _BcsBadge(score: pet.analyses.first.bcsScore,
                        category: pet.analyses.first.bcsCategory),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _BcsBadge extends StatelessWidget {
  final int score;
  final String category;
  const _BcsBadge({required this.score, required this.category});

  Color get _color {
    switch (score) {
      case 3: return AppColors.success;
      case 1:
      case 2: return const Color(0xFF2196F3);
      default: return const Color(0xFFFF9800);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'BCS $score • $category',
        style: TextStyle(
          fontSize: 11,
          color: _color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
