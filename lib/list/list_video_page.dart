import 'dart:async';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:open_video/common/net/net_manager.dart';
import 'package:open_video/list/model/list_video_model.dart';
import 'package:open_video/list/view/list_video_item.dart';
import 'package:video_player/video_player.dart';

class ListVideoPage extends StatefulWidget {
  const ListVideoPage({Key? key}) : super(key: key);

  @override
  State<ListVideoPage> createState() => _ListVideoPageState();
}

class _ListVideoPageState extends State<ListVideoPage> {
  List<ListVideoModel> _dataList = [];
  final EasyRefreshController _refreshController = EasyRefreshController();

  //视频控制器流
  final StreamController<VideoPlayerController> _streamController =
      StreamController.broadcast();
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _loadData();
    _streamController.stream.listen((event) {
      VideoPlayerController newVideoController = event;

      if (_videoPlayerController != null &&
          newVideoController.textureId != _videoPlayerController?.textureId) {
        _videoPlayerController?.pause();
      }
      debugPrint("切换播放");

      _videoPlayerController = newVideoController;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("列表"),
      ),
      body: EasyRefresh(
        controller: _refreshController,
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

  _loadData() async {
    var response =
        await LRNetManager.get("/getHaoKanVideo", pra: {"page": 0, "size": 10});
    if (response.success) {
      debugPrint("请求数据:${response.data}");
      setState(() {
        List list = response.data["list"];
        _dataList = list.map((e) => ListVideoModel.fromJson(e)).toList();
      });
    } else {
      debugPrint("请求失败");
    }
  }
}
