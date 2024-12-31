import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_demo/base/base_view_model.dart';
import 'package:music_demo/data/api/repositories/music_repository.dart';
import 'package:music_demo/data/api/response/song_list_response.dart';
import 'package:music_demo/data/bean/song_bean.dart';
import 'package:music_demo/module/dialog/loading_dialog.dart';
import 'package:provider/provider.dart';

import '../utils/toast_util.dart';
import 'package:audioplayers/audioplayers.dart';

class MainViewModel extends BaseViewModel {
  MusicRepository get _musicRepository => context.read<MusicRepository>();

  MainViewModel(super.context) {
    initPlay();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCachedSongs();
    });
  }

  bool isLoading = true;
  List<SongBean>? _allSongs;
  List<SongBean>? _songs;
  bool _isError = false;
  SortType _sortType = SortType.songName;

  final TextEditingController etFieldController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  SongBean? playingSong;

  List<SongBean> get songs => _songs ?? [];

  bool get isError => _isError;

  SortType get sortType => _sortType;

  /// 获取歌曲
  void getCachedSongs() {
    if (_allSongs == null || _allSongs?.isEmpty == true) {
      isLoading = true;
      showLoadingDialog(context);
    }
    _musicRepository.getCachedSongList().whenComplete(() {
      dismissLoadingDialog();
      isLoading = false;
    }).then((response) {
      SongListResponse songListResponse =
          SongListResponse.fromJson(jsonDecode(response));
      _allSongs = songListResponse.results;
      _isError = false;
      _songs ??= _allSongs;
      sortSongsByCurrentSortType();
    }).onError((e, t) {
      _isError = true;
      notifyListeners();
      if (e is SocketException) {
        print('Network error: $e');
        // 网络不可用的处理逻辑
        //_handleNetworkError(e);
        ToastUtil.show("网络不可用");
      } else if (e is DioException) {
        print('Connection timeout: $e');
        // 连接超时的处理逻辑
        //_handleConnectionTimeout(e);
        ToastUtil.show(e.message ?? "服务器响应错误");
      } else {
        print('Other error: $e');
        // 其他错误的处理逻辑
        ToastUtil.show("未知错误");
      }
    });
  }

  /// 变更歌曲排序规则
  void onChangeSortType(SortType sortType) {
    _sortType = sortType;
    sortSongsByCurrentSortType();
  }

  /// 根据当前排序类型对歌曲进行排序
  void sortSongsByCurrentSortType() {
    if (_songs != null) {
      switch (_sortType) {
        case SortType.songName:
          _songs!
              .sort((a, b) => a.trackName.compareTo(b.trackName)); // 按照歌曲名称排序
          break;
        case SortType.albumName:
          _songs!.sort((a, b) =>
              a.collectionName.compareTo(b.collectionName)); // 按照专辑名称排序
          break;
      }
    }
    notifyListeners();
  }

  ///对输入框内的关键字进行搜索
  void onSearchSong() {
    String input = etFieldController.text;
    _songs = filterSongsByKeyword(_allSongs, input);
    sortSongsByCurrentSortType();
  }

  ///对歌曲列表进行关键字搜索
  List<SongBean>? filterSongsByKeyword(List<SongBean>? songs, String? keyword) {
    if (keyword == null || keyword.isEmpty || songs == null) {
      return songs; // 如果关键字为空，返回原始列表
    }

    final lowerCaseKeyword = keyword.toLowerCase();

    return songs.where((song) {
      final artistNameMatch =
          song.primaryGenreName?.toLowerCase()?.contains(lowerCaseKeyword) ??
              false;
      final collectionNameMatch =
          song.collectionName?.toLowerCase()?.contains(lowerCaseKeyword) ??
              false;
      final trackNameMatch =
          song.trackName?.toLowerCase()?.contains(lowerCaseKeyword) ?? false;

      return artistNameMatch || collectionNameMatch || trackNameMatch;
    }).toList();
  }

  /// 初始化播放器
  void initPlay() {
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    //监听播放器接结束事件，进行下一首或同步ui显示
    _audioPlayer.onPlayerComplete.listen((event) {
      var index = _songs?.indexOf(playingSong!);
      if (index != null &&
          _songs != null &&
          index >= 0 &&
          index < _songs!.length - 1) {
        playingSong = _songs![index + 1];
        onPlayAction(playingSong!);
      } else {
        playingSong = null;
      }
      notifyListeners();
    });
  }

  /// 是否正在播放
  bool isPlaying() {
    return _audioPlayer.state == PlayerState.playing;
  }

  /// 播放&暂停
  void onPlayAction(SongBean song) {
    if (_audioPlayer.state == PlayerState.playing) {
      if (playingSong?.trackId == song.trackId) {
        _audioPlayer.pause();
        playingSong = null;
        notifyListeners();
        return;
      } else {
        _audioPlayer.stop();
        notifyListeners();
      }
    }
    playingSong = song;
    _audioPlayer.setSourceUrl(song.previewUrl);
    _audioPlayer.resume();
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

enum SortType {
  songName, //歌曲名称
  albumName, //专辑名称
}
