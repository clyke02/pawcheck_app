import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../widgets/paw_button.dart';
import '../../../widgets/paw_text_field.dart';
import '../controllers/pet_form_controller.dart';

class PetFormView extends GetView<PetFormController> {
  const PetFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const _LoadingView();
        }
        return Column(
          children: [
            const _Header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => _PhotoCard(
                          image: controller.selectedImage.value,
                          onTap: controller.showImageSourceDialog,
                        )),
                    const SizedBox(height: 14),
                    _card(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PawTextField(
                          controller: controller.nameCtrl,
                          label: 'Nama Hewan',
                          prefixIcon: Icons.pets_rounded,
                        ),
                        const SizedBox(height: 16),
                        const _Label(icon: Icons.wc_rounded, text: 'Jenis Kelamin'),
                        const SizedBox(height: 8),
                        Obx(() => _GenderRow(
                              selected: controller.selectedGender.value,
                              onChanged: (v) => controller.selectedGender.value = v,
                            )),
                        const SizedBox(height: 16),
                        const _Label(
                            icon: Icons.medical_services_outlined,
                            text: 'Sudah Disterilkan?'),
                        const SizedBox(height: 8),
                        Obx(() => _PillRow(
                              left: 'Sudah',
                              right: 'Belum',
                              isLeft: controller.isNeutered.value,
                              onChanged: (l) => controller.isNeutered.value = l,
                            )),
                        const SizedBox(height: 16),
                        const _Label(icon: Icons.cake_outlined, text: 'Umur'),
                        const SizedBox(height: 8),
                        const _AgeSection(),
                      ],
                    )),
                    const SizedBox(height: 14),
                    Obx(() {
                      if (controller.errorMessage.value.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return _ErrorBox(message: controller.errorMessage.value);
                    }),
                    PawButton(
                      label: 'Tambah Hewan',
                      icon: Icons.add_rounded,
                      onTap: controller.submit,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: _cardDeco(),
        child: child,
      );
}

BoxDecoration _cardDeco() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.055),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ],
    );

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 48, 18),
          child: Row(
            children: [
              IconButton(
                onPressed: Get.back,
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textDark, size: 20),
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tambah Hewan',
                        style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                    SizedBox(height: 2),
                    Text('Daftarkan hewan peliharaanmu',
                        style:
                            TextStyle(color: AppColors.textDark, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Label({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMedium.withValues(alpha: 0.8)),
        const SizedBox(width: 7),
        Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textMedium,
                fontSize: 13)),
      ],
    );
  }
}

class _GenderRow extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _GenderRow({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _PillRow(
      left: '♂️  Jantan',
      right: '♀️  Betina',
      isLeft: selected == 'male',
      onChanged: (l) => onChanged(l ? 'male' : 'female'),
    );
  }
}

class _PillRow extends StatelessWidget {
  final String left;
  final String right;
  final bool isLeft;
  final ValueChanged<bool> onChanged;
  const _PillRow({
    required this.left,
    required this.right,
    required this.isLeft,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _pill(left, isLeft, () => onChanged(true))),
        const SizedBox(width: 12),
        Expanded(child: _pill(right, !isLeft, () => onChanged(false))),
      ],
    );
  }

  Widget _pill(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label,
            style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 14)),
      ),
    );
  }
}

class _AgeSection extends StatelessWidget {
  const _AgeSection();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PetFormController>();
    return Obx(() {
      final isEstimate = c.ageMode.value == 'estimate';
      return Column(
        children: [
          _PillRow(
            left: 'Perkiraan Umur',
            right: 'Tanggal Lahir',
            isLeft: isEstimate,
            onChanged: (l) => c.ageMode.value = l ? 'estimate' : 'birthdate',
          ),
          const SizedBox(height: 10),
          if (isEstimate)
            Row(
              children: [
                Expanded(
                  child: PawTextField(
                    controller: c.yearCtrl,
                    label: 'Tahun',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PawTextField(
                    controller: c.monthCtrl,
                    label: 'Bulan',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            )
          else
            GestureDetector(
              onTap: c.pickBirthDate,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 18, color: AppColors.textMedium),
                    const SizedBox(width: 10),
                    Text(c.birthDateLabel,
                        style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }
}

class _PhotoCard extends StatelessWidget {
  final dynamic image;
  final VoidCallback onTap;
  const _PhotoCard({required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: _cardDeco(),
        clipBehavior: Clip.antiAlias,
        child: image != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(image, fit: BoxFit.cover),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Ganti Foto',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.add_a_photo_rounded,
                        color: AppColors.textDark, size: 30),
                  ),
                  const SizedBox(height: 14),
                  const Text('Tambah Foto Hewan',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  Text('Foto dipakai untuk mengidentifikasi ras',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMedium.withValues(alpha: 0.8))),
                ],
              ),
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  const _ErrorBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: const TextStyle(color: AppColors.error, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.image_search_rounded,
                  color: AppColors.textDark, size: 40),
            ),
            const SizedBox(height: 24),
            const Text('Mengidentifikasi ras hewan...',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.textDark)),
            const SizedBox(height: 6),
            const Text('Model AI sedang memproses foto',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textMedium)),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
