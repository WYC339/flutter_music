// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongListResponse _$SongListResponseFromJson(Map<String, dynamic> json) =>
    SongListResponse(
      (json['resultCount'] as num?)?.toInt(),
      (json['results'] as List<dynamic>?)
          ?.map((e) => SongBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SongListResponseToJson(SongListResponse instance) =>
    <String, dynamic>{
      'resultCount': instance.resultCount,
      'results': instance.results,
    };
