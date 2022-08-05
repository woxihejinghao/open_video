import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:open_video/list/model/list_video_model.dart';
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

  ChewieController? _chewieController;
  @override
  void initState() {
    super.initState();
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
            Positioned(left: 0, right: 0, bottom: 0, child: _buildUserInfo()),
            if (_controller?.value.isInitialized ?? false)
              Positioned.fill(child: Chewie(controller: _chewieController!)),
            Offstage(
              offstage: _controller?.value.isInitialized ?? false,
              child: InkWell(
                onTap: () {
                  _initVideo();
                },
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white70,
                  size: 80,
                ),
              ),
            )
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
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            shape: BoxShape.circle,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            widget.model.username,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          )
        ],
      ),
    );
  }

  _initVideo() async {
    _controller = VideoPlayerController.network(widget.model.playurl);
    await _controller?.initialize();
    _chewieController =
        ChewieController(videoPlayerController: _controller!, autoPlay: true);
    Map map = {
      "videoController": _controller,
      "chewieController": _chewieController
    };
    widget.streamController.add(map);
    setState(() {});
  }
}
