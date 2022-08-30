import 'package:flutter/material.dart';
import 'package:open_video/pages/listVideo/view/video_control_view.dart';
import 'package:video_player/video_player.dart';

class VideoFullScreenView extends StatefulWidget {
  final VideoPlayerController playerController;
  const VideoFullScreenView({Key? key, required this.playerController})
      : super(key: key);

  @override
  State<VideoFullScreenView> createState() => _VideoFullScreenViewState();
}

class _VideoFullScreenViewState extends State<VideoFullScreenView> {
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Padding(
        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).viewPadding.top, 0,
            MediaQuery.of(context).viewPadding.bottom, 0),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Stack(
            children: [
              Positioned.fill(
                  child: AspectRatio(
                aspectRatio: widget.playerController.value.aspectRatio,
                child: VideoControlView(controller: widget.playerController),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
