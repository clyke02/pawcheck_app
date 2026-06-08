import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';

class PawSnackbar {
  PawSnackbar._();

  static OverlayEntry? _entry;
  static Timer? _timer;

  static void success(String message) => _show(
        message: message,
        icon: Icons.check_circle_rounded,
        accentColor: const Color(0xFF2E7D32),
      );

  static void error(String message) => _show(
        message: message,
        icon: Icons.error_rounded,
        accentColor: AppColors.error,
      );

  static void info(String message) => _show(
        message: message,
        icon: Icons.info_rounded,
        accentColor: const Color(0xFF1565C0),
      );

  static void _show({
    required String message,
    required IconData icon,
    required Color accentColor,
  }) {
    _dismiss();
    final context = Get.overlayContext;
    if (context == null) return;

    _entry = OverlayEntry(
      builder: (_) => _PawToast(
        message: message,
        icon: icon,
        accentColor: accentColor,
        onDismiss: _dismiss,
      ),
    );
    Overlay.of(context).insert(_entry!);
    _timer = Timer(const Duration(seconds: 3), _dismiss);
  }

  static void _dismiss() {
    _timer?.cancel();
    _timer = null;
    _entry?.remove();
    _entry = null;
  }
}

class _PawToast extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onDismiss;

  const _PawToast({
    required this.message,
    required this.icon,
    required this.accentColor,
    required this.onDismiss,
  });

  @override
  State<_PawToast> createState() => _PawToastState();
}

class _PawToastState extends State<_PawToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    return Positioned(
      top: safeTop + 12,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: widget.onDismiss,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border(
                    left: BorderSide(color: widget.accentColor, width: 4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.13),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(widget.icon,
                          color: widget.accentColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.close_rounded,
                        color: AppColors.textLight, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
