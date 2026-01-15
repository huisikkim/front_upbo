import '../../core/constants/api_constants.dart';
import '../models/profile_model.dart';
import '../services/api_service.dart';

class ProfileRepository {
  final _dio = ApiService.dio;

  Future<ProfileModel> createProfile({
    required String name,
    String? relation,
    String? organization,
    String? phone,
    String? memo,
  }) async {
    final response = await _dio.post(
      ApiConstants.profiles,
      data: {
        'name': name,
        'relation': relation,
        'organization': organization,
        'phone': phone,
        'memo': memo,
      },
    );
    return ProfileModel.fromJson(response.data);
  }
}
