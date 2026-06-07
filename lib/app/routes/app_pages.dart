import 'package:get/get.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/analysis/bindings/analysis_binding.dart';
import '../modules/analysis/bindings/analysis_result_binding.dart';
import '../modules/analysis/views/analysis_view.dart';
import '../modules/analysis/views/result_view.dart';
import '../modules/pet_detail/bindings/pet_detail_binding.dart';
import '../modules/pet_detail/views/pet_detail_view.dart';

abstract class Routes {
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const MAIN = '/main';
  static const ANALYSIS = '/analysis';
  static const ANALYSIS_RESULT = '/analysis/result';
  static const PET_DETAIL = '/pets/:id';
}

class AppPages {
  static const initial = Routes.LOGIN;

  static final pages = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.ANALYSIS,
      page: () => const AnalysisView(),
      binding: AnalysisBinding(),
    ),
    GetPage(
      name: Routes.ANALYSIS_RESULT,
      page: () => const ResultView(),
      binding: AnalysisResultBinding(),
    ),
    GetPage(
      name: Routes.PET_DETAIL,
      page: () => const PetDetailView(),
      binding: PetDetailBinding(),
    ),
  ];
}
