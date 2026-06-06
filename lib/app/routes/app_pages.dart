import 'package:get/get.dart';
import '../modules/auth/login/login_binding.dart';
import '../modules/auth/login/login_view.dart';
import '../modules/auth/register/register_binding.dart';
import '../modules/auth/register/register_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/analysis/analysis_binding.dart';
import '../modules/analysis/analysis_view.dart';
import '../modules/analysis/result_view.dart';
import '../modules/pets/pets_binding.dart';
import '../modules/pets/pets_view.dart';
import '../modules/pet_detail/pet_detail_binding.dart';
import '../modules/pet_detail/pet_detail_view.dart';

abstract class Routes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const analysis = '/analysis';
  static const analysisResult = '/analysis/result';
  static const pets = '/pets';
  static const petDetail = '/pets/:id';
}

class AppPages {
  static const initial = Routes.login;

  static final pages = [
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.analysis,
      page: () => const AnalysisView(),
      binding: AnalysisBinding(),
    ),
    GetPage(
      name: Routes.analysisResult,
      page: () => const ResultView(),
      binding: AnalysisBinding(),
    ),
    GetPage(
      name: Routes.pets,
      page: () => const PetsView(),
      binding: PetsBinding(),
    ),
    GetPage(
      name: Routes.petDetail,
      page: () => const PetDetailView(),
      binding: PetDetailBinding(),
    ),
  ];
}
