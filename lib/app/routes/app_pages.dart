import 'package:get/get.dart';
import '../modules/auth/login/login_binding.dart';
import '../modules/auth/login/login_view.dart';
import '../modules/auth/register/register_binding.dart';
import '../modules/auth/register/register_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/analysis/analysis_binding.dart';
import '../modules/analysis/analysis_result_binding.dart';
import '../modules/analysis/analysis_view.dart';
import '../modules/analysis/result_view.dart';
import '../modules/pets/pets_binding.dart';
import '../modules/pets/pets_view.dart';
import '../modules/pet_detail/pet_detail_binding.dart';
import '../modules/pet_detail/pet_detail_view.dart';

abstract class Routes {
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const HOME = '/home';
  static const ANALYSIS = '/analysis';
  static const ANALYSIS_RESULT = '/analysis/result';
  static const PETS = '/pets';
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
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
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
      name: Routes.PETS,
      page: () => const PetsView(),
      binding: PetsBinding(),
    ),
    GetPage(
      name: Routes.PET_DETAIL,
      page: () => const PetDetailView(),
      binding: PetDetailBinding(),
    ),
  ];
}
