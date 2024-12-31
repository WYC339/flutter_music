import 'package:json_annotation/json_annotation.dart';

part 'song_bean.g.dart';


@JsonSerializable()
class SongBean {

  @JsonKey(name: 'wrapperType')
  String wrapperType;

  @JsonKey(name: 'kind')
  String kind;

  @JsonKey(name: 'artistId')
  int artistId;

  @JsonKey(name: 'collectionId')
  int collectionId;

  @JsonKey(name: 'trackId')
  int trackId;

  @JsonKey(name: 'artistName')
  String artistName;

  @JsonKey(name: 'collectionName')
  String collectionName;

  @JsonKey(name: 'trackName')
  String trackName;

  @JsonKey(name: 'collectionCensoredName')
  String collectionCensoredName;

  @JsonKey(name: 'trackCensoredName')
  String trackCensoredName;

  @JsonKey(name: 'artistViewUrl')
  String artistViewUrl;

  @JsonKey(name: 'collectionViewUrl')
  String collectionViewUrl;

  @JsonKey(name: 'trackViewUrl')
  String trackViewUrl;

  @JsonKey(name: 'previewUrl')
  String previewUrl;

  @JsonKey(name: 'artworkUrl30')
  String artworkUrl30;

  @JsonKey(name: 'artworkUrl60')
  String artworkUrl60;

  @JsonKey(name: 'artworkUrl100')
  String artworkUrl100;

  @JsonKey(name: 'collectionPrice')
  double collectionPrice;

  @JsonKey(name: 'trackPrice')
  double trackPrice;

  @JsonKey(name: 'releaseDate')
  String releaseDate;

  @JsonKey(name: 'collectionExplicitness')
  String collectionExplicitness;

  @JsonKey(name: 'trackExplicitness')
  String trackExplicitness;

  @JsonKey(name: 'discCount')
  int discCount;

  @JsonKey(name: 'discNumber')
  int discNumber;

  @JsonKey(name: 'trackCount')
  int trackCount;

  @JsonKey(name: 'trackNumber')
  int trackNumber;

  @JsonKey(name: 'trackTimeMillis')
  int trackTimeMillis;

  @JsonKey(name: 'country')
  String country;

  @JsonKey(name: 'currency')
  String currency;

  @JsonKey(name: 'primaryGenreName')
  String primaryGenreName;

  SongBean(this.wrapperType,this.kind,this.artistId,this.collectionId,this.trackId,this.artistName,this.collectionName,this.trackName,this.collectionCensoredName,this.trackCensoredName,this.artistViewUrl,this.collectionViewUrl,this.trackViewUrl,this.previewUrl,this.artworkUrl30,this.artworkUrl60,this.artworkUrl100,this.collectionPrice,this.trackPrice,this.releaseDate,this.collectionExplicitness,this.trackExplicitness,this.discCount,this.discNumber,this.trackCount,this.trackNumber,this.trackTimeMillis,this.country,this.currency,this.primaryGenreName);

  factory SongBean.fromJson(Map<String, dynamic> srcJson) => _$SongBeanFromJson(srcJson);

}