import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:music_demo/base/base_page.dart';
import 'package:music_demo/data/bean/song_bean.dart';
import 'package:music_demo/module/main/main_view_model.dart';
import 'package:music_demo/module/utils/toast_util.dart';
import 'package:provider/provider.dart';

class MainPage extends BasePage<MainViewModel> {
  @override
  MainViewModel createViewModel(BuildContext context) {
    return MainViewModel(context);
  }

  DateTime? _lastPressedAt; // 记录上次点击时间
  @override
  Widget build(BuildContext context) {
    return PopScope(
        //防止用户误触返回键退出
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (_lastPressedAt == null ||
              DateTime.now().difference(_lastPressedAt!) >
                  const Duration(seconds: 2)) {
            // 第一次点击或超过两秒后再次点击
            _lastPressedAt = DateTime.now();
            ToastUtil.show('再按一次退出');
            return;
          } else {
            // 两秒内再次点击
            //Navigator.pop(context);
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text(
              '热门歌曲',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: buildCenter(context),
        ));
  }

  /// 构建主体
  Widget buildCenter(BuildContext context) {
    var isLoading = context.watch<MainViewModel>().isLoading;
    if (isLoading) {
      return Container();
    }
    var isError = context.watch<MainViewModel>().isError;
    if (isError) {
      return Center(
        child: GestureDetector(
            onTap: () {
              context.read<MainViewModel>().getCachedSongs();
            },
            child: Text(
              "加载异常，点击重新加载",
              style: TextStyle(color: Colors.black87, fontSize: 14.sp),
            )),
      );
    }
    return SafeArea(
      child: Column(
        children: [
          buildSortItem(),
          buildSearchItem(context),
          SizedBox(height: 10.h),
          buildSongsItems(),
        ],
      ),
    );
  }

  /// 构建排序item
  Widget buildSortItem() {
    return Row(
      children: [
        SizedBox(width: 12.w),
        Text("排序方式：", style: TextStyle(color: Colors.black, fontSize: 14.sp)),
        Selector<MainViewModel, SortType>(
          builder: (context, sortType, __) {
            return Expanded(
                child: Row(
              children: [
                Checkbox(
                    semanticLabel: "歌曲名称",
                    value: sortType == SortType.songName,
                    onChanged: (checked) {
                      context
                          .read<MainViewModel>()
                          .onChangeSortType(SortType.songName);
                    }),
                Text(
                  "歌曲名称",
                  style: TextStyle(color: Colors.black, fontSize: 14.sp),
                ),
                Checkbox(
                    semanticLabel: "专辑名称",
                    value: sortType == SortType.albumName,
                    onChanged: (checked) {
                      context
                          .read<MainViewModel>()
                          .onChangeSortType(SortType.albumName);
                    }),
                Text(
                  "专辑名称",
                  style: TextStyle(color: Colors.black, fontSize: 14.sp),
                )
              ],
            ));
          },
          selector: (_, viewModel) => viewModel.sortType,
        ),
      ],
    );
  }

  /// 构建搜索item
  Widget buildSearchItem(BuildContext context) {
    var controller = context.watch<MainViewModel>().etFieldController;
    bool isEmpty = controller.value.text.isEmpty;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      width: 1.sw,
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.all(Radius.circular(6.r)),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 1,
              maxLength: 20,
              cursorColor: Colors.black,
              style: TextStyle(fontSize: 14.h, color: Colors.black),
              decoration: InputDecoration(
                counterText: '',
                hintText: "请输入歌曲关键字",
                hintStyle: TextStyle(fontSize: 14.h, color: Colors.black26),
                border: InputBorder.none,
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 10.h, horizontal: 10.w), // 设置TextField的高度
              ),
              controller: controller,
              onChanged: (inputSearch) {
                context.read<MainViewModel>().onSearchSong();
              },
            ),
          ),
          isEmpty
              ? Container()
              : IconButton(
                  onPressed: () {
                    controller.clear();
                    context.read<MainViewModel>().onSearchSong();
                  },
                  icon: const Icon(Icons.clear, color: Colors.black54),
                ),
        ],
      ),
    );
  }

  /// 构建歌曲items
  Widget buildSongsItems() {
    return Selector<MainViewModel, List<SongBean>>(
      builder: (context, List<SongBean> songs, ___) {
        return Expanded(
          child: SizedBox(
            width: 1.sw,
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                SliverList.builder(
                  itemBuilder: buildSongItem,
                  itemCount: songs.length,
                )
              ],
            ),
          ),
        );
      },
      selector: (_, viewModel) => viewModel.songs,
    );
  }

  /// 构建歌曲item(点击封面图片播放音乐)
  Widget buildSongItem(BuildContext context, int index) {
    var songInfo = context.read<MainViewModel>().songs[index];
    var isPlaying = context.read<MainViewModel>().isPlaying();
    var playingSong = context.read<MainViewModel>().playingSong;
    return Container(
      height: 60.h,
      margin: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          SizedBox(width: 12.w),
          SizedBox(
            width: 60.w,
            height: 60.h,
            child: GestureDetector(
              onTap: () {
                context.read<MainViewModel>().onPlayAction(songInfo);
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipRRect(
                    //剪裁为圆角矩形
                    borderRadius: BorderRadius.circular(6.r),
                    child: Image.network(
                      songInfo.artworkUrl100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  playingSong?.trackId == songInfo.trackId
                      ? Lottie.asset('assets/anim/anim_playing.json',
                          width: 20.w, height: 20.h)
                      : Container()
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildSongInfoText("歌曲名称", songInfo.trackName),
              buildSongInfoText("专辑名称", songInfo.collectionName),
              buildSongInfoText("歌曲风格", songInfo.primaryGenreName),
            ],
          )),
          SizedBox(width: 5.w),
        ],
      ),
    );
  }

  Widget buildSongInfoText(String infoTitle, String infoContent) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              infoTitle,
              style: TextStyle(color: Colors.black54, fontSize: 14.sp),
            ),
            Text(
              overflow: TextOverflow.ellipsis,
              infoContent,
              maxLines: 1,
              style: TextStyle(color: Colors.black, fontSize: 12.sp),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
