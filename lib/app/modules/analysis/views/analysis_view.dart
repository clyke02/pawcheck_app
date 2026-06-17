import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../widgets/gender_toggle.dart';
import '../../../widgets/paw_button.dart';
import '../../../widgets/paw_text_field.dart';
import '../controllers/analysis_controller.dart';

class AnalysisView extends GetView<AnalysisController> {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const _AnalysisLoadingWidget();
        }
        return Column(
          children: [
            _AnalysisHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo card
                    Obx(() => _PhotoCard(
                          image: controller.selectedImage.value,
                          onTap: controller.showImageSourceDialog,
                        )),

                    const SizedBox(height: 14),

                    // Form card
                    Container(
                      decoration: _cardDeco(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(18, 18, 18, 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.pets_rounded,
                                      color: AppColors.primary, size: 17),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Data Hewan',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                              height: 1,
                              color: Colors.grey.withValues(alpha: 0.1)),
                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PawTextField(
                                  controller: controller.petNameCtrl,
                                  label: 'Nama Hewan',
                                  prefixIcon: Icons.badge_outlined,
                                ),
                                const SizedBox(height: 12),
                                PawTextField(
                                  controller: controller.weightCtrl,
                                  label: 'Berat (kg)',
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  prefixIcon: Icons.monitor_weight_outlined,
                                ),
                                const SizedBox(height: 12),
                                PawTextField(
                                  controller: controller.ageCtrl,
                                  label: 'Usia (tahun)',
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  prefixIcon: Icons.cake_outlined,
                                ),
                                const SizedBox(height: 18),
                                Divider(
                                    height: 1,
                                    color: Colors.grey.withValues(alpha: 0.1)),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Icon(Icons.wc_rounded,
                                        size: 16,
                                        color: AppColors.textMedium
                                            .withValues(alpha: 0.7)),
                                    const SizedBox(width: 7),
                                    const Text(
                                      'Jenis Kelamin',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textMedium,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Obx(() => GenderToggle(
                                      selected:
                                          controller.selectedGender.value,
                                      onChanged: (v) =>
                                          controller.selectedGender.value = v,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Error
                    Obx(() {
                      if (controller.errorMessage.value.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 11),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
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

                    PawButton(
                      label: 'Analisis Sekarang',
                      onTap: controller.analyze,
                      icon: Icons.analytics_rounded,
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
}

class _AnalysisHeader extends StatelessWidget {
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
                    Text(
                      'Analisis BCS',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Lengkapi foto & data hewan peliharaanmu',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 12,
                      ),
                    ),
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
            ? _ImagePreview(image: image)
            : const _PhotoPlaceholder(),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final dynamic image;
  const _ImagePreview({required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(image, fit: BoxFit.cover),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cameraswitch_rounded,
                    color: Colors.white, size: 14),
                SizedBox(width: 5),
                Text('Ganti Foto',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AnalysisLoadingWidget extends StatefulWidget {
  const _AnalysisLoadingWidget();

  @override
  State<_AnalysisLoadingWidget> createState() => _AnalysisLoadingWidgetState();
}

class _AnalysisLoadingWidgetState extends State<_AnalysisLoadingWidget> {
  static const _stages = [
    (
      icon: Icons.image_search_rounded,
      msg: 'Mengidentifikasi ras hewan...',
      sub: 'Model AI sedang memproses foto'
    ),
    (
      icon: Icons.monitor_weight_outlined,
      msg: 'Menghitung skor BCS...',
      sub: 'Menganalisis kondisi tubuh hewan'
    ),
    (
      icon: Icons.restaurant_rounded,
      msg: 'Membuat rekomendasi nutrisi...',
      sub: 'Menunggu respons Gemini AI'
    ),
  ];

  int _stage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted && _stage < _stages.length - 1) {
        setState(() => _stage++);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stage = _stages[_stage];
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: Container(
                  key: ValueKey(_stage),
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(stage.icon, color: AppColors.textDark, size: 40),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _stages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _stage ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _stage
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Column(
                  key: ValueKey(_stage),
                  children: [
                    Text(
                      stage.msg,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      stage.sub,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const Text(
          'Tambah Foto Hewan',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.textDark),
        ),
        const SizedBox(height: 4),
        Text(
          'Ketuk untuk memilih dari kamera atau galeri',
          style: TextStyle(
              fontSize: 12,
              color: AppColors.textMedium.withValues(alpha: 0.8)),
        ),
      ],
    );
  }
}
