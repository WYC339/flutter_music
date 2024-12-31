import 'package:flutter/cupertino.dart';
import 'package:music_demo/data/api/api_client.dart';
import 'package:music_demo/data/api/response/song_list_response.dart';

class MusicRepository extends ChangeNotifier {
  Future<String> getCachedSongList() {
    return apiClient.getSongs();
  }
}
