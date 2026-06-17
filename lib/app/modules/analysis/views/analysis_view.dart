import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../widgets/gender_toggle.dart';
import '../../../widgets/paw_app_bar.dart';
import '../../../widgets/paw_button.dart';
import '../../../widgets/paw_loading_widget.dart';
import '../../../widgets/paw_text_field.dart';
import '../controllers/analysis_controller.dart';

class AnalysisView extends GetView<AnalysisController> {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PawAppBar(title: 'Analisis BCS'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const PawLoadingWidget(
              message: 'Sedang menganalisis...\nMohon tunggu sebentar.');
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => GestureDetector(
                    onTap: controller.showImageSourceDialog,
                    child: Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: controller.selectedImage.value != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.file(
                                controller.selectedImage.value!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_rounded,
                                    size: 48, color: AppColors.primary),
                                SizedBox(height: 8),
                                Text(
                                  'Tap untuk menambah foto',
                                  style: TextStyle(
                                      color: AppColors.textMedium),
                                ),
                              ],
                            ),
                    ),
                  )),
              const SizedBox(height: 24),
              const Text(
                'Data Hewan',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 12),
              PawTextField(
                controller: controller.petNameCtrl,
                label: 'Nama Hewan',
                prefixIcon: Icons.pets_rounded,
              ),
              const SizedBox(height: 14),
              PawTextField(
                controller: controller.weightCtrl,
                label: 'Berat (kg)',
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                prefixIcon: Icons.monitor_weight_outlined,
              ),
              const SizedBox(height: 14),
              PawTextField(
                controller: controller.ageCtrl,
                label: 'Usia (tahun)',
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                prefixIcon: Icons.cake_outlined,
              ),
              const SizedBox(height: 14),
              const Text(
                'Jenis Kelamin',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMedium),
              ),
              const SizedBox(height: 8),
              Obx(() => GenderToggle(
                    selected: controller.selectedGender.value,
                    onChanged: (v) => controller.selectedGender.value = v,
                  )),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.errorMessage.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.error, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(
                              color: AppColors.error, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),
              PawButton(
                label: 'Analisis Sekarang',
                onTap: controller.analyze,
                icon: Icons.analytics_rounded,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}
