import 'package:get/get.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/auth/verify_otp/bindings/verify_otp_binding.dart';
import '../modules/auth/verify_otp/views/verify_otp_view.dart';
import '../modules/pets/bindings/pets_binding.dart';
import '../modules/pets/views/pets_view.dart';
import '../modules/pet_form/bindings/pet_form_binding.dart';
import '../modules/pet_form/views/pet_form_view.dart';
import '../modules/analysis/bindings/analysis_binding.dart';
import '../modules/analysis/bindings/analysis_result_binding.dart';
import '../modules/analysis/views/analysis_view.dart';
import '../modules/analysis/views/result_view.dart';
import '../modules/pet_detail/bindings/pet_detail_binding.dart';
import '../modules/pet_detail/views/pet_detail_view.dart';

abstract class Routes {
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const VERIFY_OTP = '/verify-otp';
  static const BERANDA = '/beranda';
  static const ADD_PET = '/tambah-hewan';
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
      name: Routes.VERIFY_OTP,
      page: () => const VerifyOtpView(),
      binding: VerifyOtpBinding(),
    ),
    GetPage(
      name: Routes.BERANDA,
      page: () => const PetsView(),
      binding: PetsBinding(),
    ),
    GetPage(
      name: Routes.ADD_PET,
      page: () => const PetFormView(),
      binding: PetFormBinding(),
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
