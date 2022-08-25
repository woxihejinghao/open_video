import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:open_video/common/instance.dart';
import 'package:open_video/douyi/model/douyi_list_model.dart';
import 'package:open_video/provider/common_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class DouYinVideoItem extends StatefulWidget {
  final DouYinListModel model;
  const DouYinVideoItem({Key? key, required this.model}) : super(key: key);

  @override
  State<DouYinVideoItem> createState() => _DouYinVideoItemState();
}

class _DouYinVideoItemState extends State<DouYinVideoItem>
    with TickerProviderStateMixin {
  late VideoPlayerController _playerController;
  //是否隐藏播放按钮
  final ValueNotifier<bool> _isPlayButtonHidden = ValueNotifier(true);
  //是否加载中
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);

  ///动画控制器
  late AnimationController _animationController;
  //动画
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    //初始化动画控制
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));

    //创建动画
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    //初始化播放器
    _playerController = VideoPlayerController.network(widget.model.playurl);
    _playerController.setLooping(true); //循环播放

    //监听播放状态
    _playerController.addListener(() {
      _isPlayButtonHidden.value = _playerController.value.isPlaying ||
          _playerController.value.isBuffering;
      _isLoading.value = _playerController.value.isBuffering;

      if (_playerController.value.isPlaying) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    });
    //监听是否处于抖音页面，暂停/播放
    currentContext
        .read<CommonProvider>()
        .streamController
        .stream
        .listen((index) {
      if (index == 2 && _playerController.value.isInitialized) {
        _playerController.play();
      } else {
        _playerController.pause();
      }
    });

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_playerController.value.isPlaying) {
          _playerController.pause();
        } else {
          _playerController.play();
        }
      },
      child: Stack(
        children: [
          _buildCover(),
          _buildPlayer(),
          _buildProgress(),
          _buildPlayButton(),
          _buildLoading(),
          _buildTitleAndName(),
          _buildUserAvatar()
        ],
      ),
    );
  }

//封面
  _buildCover() {
    return Positioned.fill(
        child: ExtendedImage.network(
      widget.model.picurl,
      fit: BoxFit.fill,
    ));
  }

  _buildLoading() {
    return ValueListenableBuilder(
      valueListenable: _isLoading,
      builder: (BuildContext context, bool value, Widget? child) {
        return Offstage(
          offstage: !value,
          child: const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

//播放器
  _buildPlayer() {
    return Positioned.fill(child: VideoPlayer(_playerController));
  }

//进度条
  _buildProgress() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: VideoProgressIndicator(
        _playerController,
        allowScrubbing: true,
        colors: VideoProgressColors(playedColor: currentColorScheme.primary),
      ),
    );
  }

//播放按钮
  _buildPlayButton() {
    return ValueListenableBuilder(
      valueListenable: _isPlayButtonHidden,
      builder: (BuildContext context, bool value, Widget? child) {
        return Align(
          alignment: Alignment.center,
          child: Offstage(
            offstage: value,
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 60,
            ),
          ),
        );
      },
    );
  }

  _buildTitleAndName() {
    return Positioned(
        left: 10,
        bottom: 30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "@${widget.model.alias}",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Text(
                widget.model.title,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ));
  }

  _buildUserAvatar() {
    return Positioned(
        right: 10,
        bottom: 30,
        child: RotationTransition(
          turns: _animation,
          child: ExtendedImage.network(
            widget.model.picuser,
            height: 60,
            width: 60,
            shape: BoxShape.circle,
            fit: BoxFit.cover,
            border: Border.all(color: Colors.black, width: 8),
          ),
        ));
  }

  //加载视频
  _loadVideo() async {
    _isLoading.value = true;
    await _playerController.initialize();
    // ignore: use_build_context_synchronously
    if (currentContext.read<CommonProvider>().selectedTabIndex == 2) {
      _playerController.play(); //选中的页面为当前页面才能自动播放
    }
  }

  @override
  void dispose() {
    _playerController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
