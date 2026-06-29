import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/constants.dart';
import '../../../data/models/pet_model.dart';
import '../../../widgets/bcs_score_card.dart';
import '../../../widgets/paw_button.dart';
import '../../../widgets/paw_error_widget.dart';
import '../../../widgets/paw_loading_widget.dart';
import '../controllers/pets_controller.dart';

class PetsView extends GetView<PetsController> {
  const PetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Obx(() => _Header(
                name: controller.userName.value,
                onLogout: controller.logout,
              )),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.pets.isEmpty) {
                return const PawLoadingWidget(
                    message: 'Memuat hewan peliharaan...');
              }
              if (controller.errorMessage.value.isNotEmpty &&
                  controller.pets.isEmpty) {
                return PawErrorWidget(
                  message: controller.errorMessage.value,
                  onRetry: controller.loadPets,
                );
              }
              if (controller.pets.isEmpty) {
                return _EmptyState(onAdd: controller.goAddPet);
              }
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: controller.loadPets,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: controller.pets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final pet = controller.pets[i];
                    return Dismissible(
                      key: Key('pet_${pet.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.delete_rounded,
                            color: AppColors.error),
                      ),
                      confirmDismiss: (_) => _confirmDelete(pet.name),
                      onDismissed: (_) => controller.deletePet(pet.id),
                      child: _PetCard(
                        pet: pet,
                        onTap: () => controller.goDetail(pet),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() => controller.pets.isEmpty
          ? const SizedBox.shrink()
          : FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textDark,
              onPressed: controller.goAddPet,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tambah Hewan',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            )),
    );
  }

  Future<bool?> _confirmDelete(String name) => Get.dialog<bool>(
        Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.error, size: 26),
                ),
                const SizedBox(height: 14),
                const Text('Hapus Hewan?',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(
                  'Hapus $name? Semua riwayat analisis juga akan ikut terhapus dan tidak bisa dikembalikan.',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textMedium, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(result: false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          side: const BorderSide(
                              color: Color(0xFFE0E0E0), width: 1.5),
                        ),
                        child: const Text('Batal',
                            style: TextStyle(
                                color: AppColors.textMedium,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(result: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Hapus',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

class _Header extends StatelessWidget {
  final String name;
  final VoidCallback onLogout;
  const _Header({required this.name, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand row
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.pets, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'PawCheck',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout_rounded),
                  color: AppColors.textMedium,
                  tooltip: 'Keluar',
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Greeting
            const Text(
              'Selamat Datang,',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              name.isEmpty ? 'Pengguna' : name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.pets_rounded,
                  size: 46, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            const Text('Belum ada hewan peliharaan',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            const SizedBox(height: 6),
            const Text(
              'Tambahkan hewan peliharaanmu untuk mulai memantau kondisinya.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textMedium),
            ),
            const SizedBox(height: 24),
            PawButton(
              label: 'Tambah Hewan Peliharaan',
              icon: Icons.add_rounded,
              onTap: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final PetModel pet;
  final VoidCallback onTap;
  const _PetCard({required this.pet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final latest = pet.latestAnalysis;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
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
            _Avatar(pet: pet),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pet.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text('${pet.breed?.name ?? 'Unknown'} · ${pet.genderLabel}',
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.textMedium)),
                  const SizedBox(height: 2),
                  Text('${pet.currentAgeLabel} · ${pet.neuterLabel}',
                      style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textMedium.withValues(alpha: 0.8))),
                ],
              ),
            ),
            if (latest != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: BcsScoreCard.colorForScore(latest.bcsScore)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('BCS ${latest.bcsScore}',
                    style: TextStyle(
                        color: BcsScoreCard.colorForScore(latest.bcsScore),
                        fontWeight: FontWeight.w800,
                        fontSize: 12)),
              ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textLight, size: 22),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final PetModel pet;
  const _Avatar({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: (pet.imageUrl != null && pet.imageUrl!.isNotEmpty)
          ? Image.network(
              AppConstants.fileUrl(pet.imageUrl!),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _emoji(),
            )
          : _emoji(),
    );
  }

  Widget _emoji() => Center(
        child: Text(pet.speciesEmoji, style: const TextStyle(fontSize: 28)),
      );
}
