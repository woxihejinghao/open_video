import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_video/common/instance.dart';
import 'package:video_player/video_player.dart';

class VideoControlView extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback? tapCallback;
  VideoControlView({Key? key, required this.controller, this.tapCallback})
      : super(key: key);

  @override
  State<VideoControlView> createState() => _VideoControlViewState();
}

class _VideoControlViewState extends State<VideoControlView> {
  ///是否正在播放
  ValueNotifier<bool> isPlaying = ValueNotifier(false);

  ///是否展示加载动画
  ValueNotifier<bool> showLoading = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      isPlaying.value = widget.controller.value.isPlaying;
      showLoading.value = widget.controller.value.isBuffering;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
          onTap: _handleTap,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(widget.controller),
              Align(
                alignment: Alignment.center,
                child: ValueListenableBuilder(
                  valueListenable: isPlaying,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return value
                        ? Container()
                        : const Icon(
                            Icons.play_arrow_rounded,
                            size: 35,
                            color: Colors.white,
                          );
                  },
                ),
              ),
              _buildLoading(),
              ValueListenableBuilder(
                valueListenable: isPlaying,
                builder: (BuildContext context, bool value, Widget? child) {
                  return !value
                      ? Container()
                      : VideoProgressIndicator(
                          widget.controller,
                          allowScrubbing: true,
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                          colors: VideoProgressColors(
                              playedColor: currentColorScheme.primary),
                        );
                },
              ),
            ],
          )),
    );
  }

  _buildLoading() {
    return Align(
      alignment: Alignment.center,
      child: ValueListenableBuilder(
        valueListenable: showLoading,
        builder: (BuildContext context, bool value, Widget? child) {
          return !value ? Container() : const CircularProgressIndicator();
        },
      ),
    );
  }

  _handleTap() async {
    if (widget.tapCallback != null) {
      widget.tapCallback!();
    }
    if (!widget.controller.value.isInitialized) {
      showLoading.value = true;
      isPlaying.value = true;
      await widget.controller.initialize();
      widget.controller.play();
      return;
    }

    if (widget.controller.value.isPlaying) {
      widget.controller.pause();
    } else {
      widget.controller.play();
    }
  }
}
