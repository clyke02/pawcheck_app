import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import 'analysis_controller.dart';

class AnalysisView extends GetView<AnalysisController> {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analisis BCS')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image picker
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
                                Text('Tap untuk menambah foto',
                                    style: TextStyle(color: AppColors.textMedium)),
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
              TextField(
                controller: controller.weightCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Berat (kg)',
                  prefixIcon: Icon(Icons.monitor_weight_outlined),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller.ageCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Usia (tahun)',
                  prefixIcon: Icon(Icons.cake_outlined),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Jenis Kelamin',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppColors.textMedium)),
              const SizedBox(height: 8),
              Obx(() => Row(
                    children: [
                      _GenderChip(
                        label: 'Jantan ♂️',
                        selected: controller.selectedGender.value == 'male',
                        onTap: () => controller.selectedGender.value = 'male',
                      ),
                      const SizedBox(width: 12),
                      _GenderChip(
                        label: 'Betina ♀️',
                        selected: controller.selectedGender.value == 'female',
                        onTap: () => controller.selectedGender.value = 'female',
                      ),
                    ],
                  )),
              const SizedBox(height: 32),
              Obx(() => ElevatedButton.icon(
                    onPressed:
                        controller.isLoading.value ? null : controller.analyze,
                    icon: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.analytics_rounded),
                    label: Text(controller.isLoading.value
                        ? 'Menganalisis...'
                        : 'Analisis Sekarang'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenderChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE0E0E0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
