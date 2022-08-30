import 'package:flutter/material.dart';
import 'package:open_video/pages/wallpaper/wallpaper_list_page.dart';

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
