import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:open_video/common/instance.dart';
import 'package:permission_handler/permission_handler.dart';

class WallpaperBrowsePage extends StatefulWidget {
  final String url;
  const WallpaperBrowsePage({Key? key, required this.url}) : super(key: key);

  @override
  State<WallpaperBrowsePage> createState() => _WallpaperBrowsePageState();
}

class _WallpaperBrowsePageState extends State<WallpaperBrowsePage> {
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
            )),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: ExtendedImageGesturePageView.builder(
            controller: ExtendedPageController(
              initialPage: 0,
              pageSpacing: 50,
            ),
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Hero(
                  tag: widget.url,
                  child: ExtendedImage.network(
                    widget.url,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.gesture,
                    initGestureConfigHandler: (ExtendedImageState state) {
                      return GestureConfig(
                        //you must set inPageView true if you want to use ExtendedImageGesturePageView
                        inPageView: true,
                        initialScale: 1.0,
                        maxScale: 5.0,
                        animationMaxScale: 6.0,
                        initialAlignment: InitialAlignment.center,
                      );
                    },
                  ));
            },
          )),
          Positioned(
            child: _buildBottomToolBar(),
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewPadding.bottom + 10,
          )
        ],
      ),
    );
  }

  _buildBottomToolBar() {
    return Card(
      child: Container(
        // color: Colors.red,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite),
              iconSize: 30,
            ),
            IconButton(
              onPressed: _saveWallpaper,
              icon: const Icon(Icons.save_alt_rounded),
              iconSize: 30,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }

  //保存图片
  _saveWallpaper() async {
    if (Platform.isAndroid) {
      if (!(await Permission.storage.request().isGranted)) {
        showToast("请打开存储权限");
        return;
      }
    } else if (Platform.isIOS) {
      if (!(await Permission.photos.request().isGranted)) {
        showToast("请开启图片权限");
        return;
      }
    }
    showLoading();
    var data = await getNetworkImageData(widget.url);
    if (data == null) {
      dismissLoading();
      showToast("保存失败");
      return;
    }

    final result = await ImageGallerySaver.saveImage(data);
    dismissLoading();
    showToast("保存成功");
  }
}
