import 'package:dio/dio.dart';
import 'package:music_demo/data/api/response/song_list_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../consts/constants.dart';
import 'network_module.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  /// 获取歌曲列表
  @GET("/search")
  Future<String> getSongs(
      {@Query("term") String? term = "Talyor+Swift",
      @Query("limit") int? limit = 200,
      @Query("media") String? media = "music"});
}

final apiClient = ApiClient(defaultDio, baseUrl: Constants.baseUrl);
