import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/daily_container_model.dart';

class DailyContainerRepository {
  final DioClient _client;

  DailyContainerRepository(this._client);

  Future<List<DailyContainerModel>> fetchDailyContainers() async {
    final response = await _client.dio.get('/DailyContainer');
    final data = response.data;

    if (data is! List) {
      throw ApiException('Unexpected response format');
    }

    return data
        .map((item) => DailyContainerModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
}
