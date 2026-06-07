import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'paw_button.dart';

class PawEmptyWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const PawEmptyWidget({
    super.key,
    required this.message,
    this.icon = Icons.pets,
    this.actionLabel,
    this.onAction,
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 52),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(
                  color: AppColors.textMedium,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              PawButton(label: actionLabel!, onTap: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
