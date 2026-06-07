import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'paw_button.dart';

class PawErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const PawErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline_rounded,
                  color: AppColors.error, size: 48),
            ),
            const SizedBox(height: 20),
            const Text(
              'Oops!',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                  color: AppColors.textMedium, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              PawButton(label: 'Coba Lagi', onTap: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
