import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/data/repositories/auth_repository.dart';
import 'app/routes/app_pages.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final (user, _) = await AuthRepository().loadSaved();
  final initialRoute = user != null ? Routes.HOME : Routes.LOGIN;
  runApp(PawCheckApp(initialRoute: initialRoute));
}

class PawCheckApp extends StatelessWidget {
  final String initialRoute;
  const PawCheckApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PawCheck',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.pages,
    );
  }
}
