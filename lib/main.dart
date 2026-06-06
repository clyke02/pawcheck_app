import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/data/repositories/auth_repository.dart';
import 'app/routes/app_pages.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PawCheckApp());
}

class PawCheckApp extends StatelessWidget {
  const PawCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PawCheck',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.login,
      getPages: AppPages.pages,
      builder: (context, child) => _AuthGate(child: child!),
    );
  }
}

class _AuthGate extends StatefulWidget {
  final Widget child;
  const _AuthGate({required this.child});

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final (user, _) = await AuthRepository().loadSaved();
    if (user != null && Get.currentRoute == Routes.login) {
      Get.offAllNamed(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
