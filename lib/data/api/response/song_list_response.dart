import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../bean/song_bean.dart';

part 'song_list_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class SongListResponse {
  @JsonKey(name: 'resultCount')
  int? resultCount;

  @JsonKey(name: 'results')
  List<SongBean>? results;

  SongListResponse(this.resultCount, this.results);

  factory SongListResponse.fromJson(Map<String, dynamic> json) =>
      _$SongListResponseFromJson(json);

}
