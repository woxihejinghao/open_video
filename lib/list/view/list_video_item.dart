import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:open_video/list/model/list_video_model.dart';
import 'package:open_video/list/view/video_control_view.dart';
import 'package:open_video/list/view/video_full_screen_view.dart';
import 'package:video_player/video_player.dart';

class ListVideoItem extends StatefulWidget {
  final ListVideoModel model;
  final StreamController streamController;
  const ListVideoItem(
      {Key? key, required this.model, required this.streamController})
      : super(key: key);

  @override
  State<ListVideoItem> createState() => _ListVideoItemState();
}

class _ListVideoItemState extends State<ListVideoItem> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.model.playurl);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
                child: ExtendedImage.network(widget.model.coverurl)),
            if (_controller != null)
              Positioned.fill(
                  child: VideoControlView(
                controller: _controller!,
                tapCallback: () {
                  widget.streamController.add(_controller);
                },
                fullScreenCallback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => VideoFullScreenView(
                          playerController: _controller!))));
                },
              )),
            Positioned(left: 0, right: 0, top: 0, child: _buildUserInfo()),
          ],
        ),
      ),
    );
  }

  Container _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.all(8),
      // decoration: const BoxDecoration(color: Colors.black45),
      child: Row(
        children: [
          ExtendedImage.network(
            widget.model.userpic,
            width: 35,
            height: 35,
            fit: BoxFit.cover,
            shape: BoxShape.circle,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            widget.model.username,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}
