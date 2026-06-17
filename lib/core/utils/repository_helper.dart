import '../../app/data/providers/api_provider.dart' show ApiException;
import 'api_response.dart';

mixin RepositoryHelper {
  Future<ApiResponse<T>> guard<T>(Future<ApiResponse<T>> Function() block) async {
    try {
      return await block();
    } on ApiException catch (e) {
      return ApiResponse.error(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
