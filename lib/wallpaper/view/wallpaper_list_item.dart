import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:open_video/wallpaper/model/wallpaper_list_model.dart';

class WallpaperListItem extends StatelessWidget {
  final WallpaperListModel model;
  const WallpaperListItem({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExtendedImage.network(
        model.url,
        compressionRatio: 0.5,
        fit: BoxFit.cover,
        enableMemoryCache: true,
        clearMemoryCacheWhenDispose: true,
      ),
    );
  }
}
