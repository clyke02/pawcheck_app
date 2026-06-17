import 'package:get/get.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../controllers/verify_otp_controller.dart';

class VerifyOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<VerifyOtpController>(
      () => VerifyOtpController(repository: Get.find()),
    );
  }
}
