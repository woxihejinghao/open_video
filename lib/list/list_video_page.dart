import 'dart:async';
import 'package:flutter/material.dart';
import 'package:open_video/common/net/net_manager.dart';
import 'package:open_video/list/model/list_video_model.dart';
import 'package:open_video/list/view/list_video_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_player/video_player.dart';

class ListVideoPage extends StatefulWidget {
  const ListVideoPage({Key? key}) : super(key: key);

  @override
  State<ListVideoPage> createState() => _ListVideoPageState();
}

class _ListVideoPageState extends State<ListVideoPage> {
  List<ListVideoModel> _dataList = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  //当前页码
  int _currentPage = 0;

  //视频控制器流
  final StreamController<VideoPlayerController> _streamController =
      StreamController.broadcast();
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _onRefresh();
    _streamController.stream.listen((event) {
      VideoPlayerController newVideoController = event;

      if (_videoPlayerController != null &&
          newVideoController.textureId != _videoPlayerController?.textureId) {
        _videoPlayerController?.pause();
      }

      _videoPlayerController = newVideoController;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "多看",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        enablePullUp: true,
        child: ListView.builder(
          itemCount: _dataList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListVideoItem(
              model: _dataList[index],
              streamController: _streamController,
            );
          },
        ),
      ),
    );
  }

  _onRefresh() async {
    var response =
        await LRNetManager.get("/getHaoKanVideo", pra: {"page": 0, "size": 10});
    _refreshController.refreshCompleted();
    if (response.success) {
      _currentPage = 0;
      setState(() {
        List list = response.data["list"];
        _dataList = list.map((e) => ListVideoModel.fromJson(e)).toList();
      });
    }
  }

  _onLoading() async {
    var response = await LRNetManager.get("/getHaoKanVideo",
        pra: {"page": _currentPage + 1, "size": 10});
    _refreshController.refreshCompleted();
    if (response.success) {
      _currentPage += 1;
      setState(() {
        List list = response.data["list"];
        var dataList = list.map((e) => ListVideoModel.fromJson(e)).toList();
        _dataList.addAll(dataList);
      });
    }
  }
}
