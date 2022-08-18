import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:open_video/common/net/net_manager.dart';
import 'package:open_video/wallpaper/model/wallpaper_list_model.dart';
import 'package:open_video/wallpaper/view/wallpaper_list_item.dart';
import 'package:open_video/wallpaper/wallpaper_browse_page.dart';
import 'package:open_video/wallpaper/wallpaper_list_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WallpaperPage extends StatefulWidget {
  const WallpaperPage({Key? key}) : super(key: key);

  @override
  State<WallpaperPage> createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  final tabTexts = const [
    "推荐",
    "动物",
    "美女",
    "汽车",
    "漫画",
    "食物",
    "游戏",
    "电影",
    "人物",
    "手机",
    "风景",
  ];

  final keys = const [
    "",
    "animal",
    "beauty",
    "car",
    "comic",
    "food",
    "game",
    "movie",
    "person",
    "phone",
    "scenery",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "壁纸",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
        ),
      ),
      body: DefaultTabController(
          length: tabTexts.length,
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(
                  child: TabBarView(
                children: keys
                    .map((e) => WallpaperListPage(
                          category: e,
                        ))
                    .toList(),
              ))
            ],
          )),
    );
  }

  _buildTabBar() {
    return TabBar(
        isScrollable: true,
        tabs: tabTexts
            .map((e) => Tab(
                  text: e,
                ))
            .toList());
  }
}
