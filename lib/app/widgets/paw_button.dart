import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PawButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;

  const PawButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: isLoading ? null : onTap,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.accent, width: 1.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
          child: _child(isOutlined: true),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: isLoading || onTap == null
            ? null
            : const LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        color: isLoading || onTap == null ? Colors.grey[300] : null,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLoading ? null : onTap,
          child: Center(child: _child()),
        ),
      ),
    );
  }

  Widget _child({bool isOutlined = false}) {
    final textColor = isOutlined ? AppColors.accent : AppColors.textDark;
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
              isOutlined ? AppColors.accent : AppColors.textDark),
        ),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15)),
        ],
      );
    }
    return Text(label,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.w700, fontSize: 15));
  }
}
