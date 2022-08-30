import 'package:flutter/material.dart';
import 'package:open_video/common/instance.dart';
import 'package:open_video/pages/douyi/douyin_video_page.dart';
import 'package:open_video/pages/listVideo/list_video_page.dart';
import 'package:open_video/pages/wallpaper/wallpaper_page.dart';
import 'package:open_video/provider/common_provider.dart';
import 'package:provider/provider.dart';

class MainTabPage extends StatefulWidget {
  const MainTabPage({Key? key}) : super(key: key);

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  final List<BottomNavigationBarItem> bottomNavItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.list), label: "多看"),
    BottomNavigationBarItem(icon: Icon(Icons.image), label: "壁纸"),
    BottomNavigationBarItem(icon: Icon(Icons.video_call), label: "抖音")
  ];

  final List<Widget> myPages = const [
    ListVideoPage(),
    WallpaperPage(),
    DouYinVideoPage()
  ];

  var _currentPage = 0;

  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentPage,
        children: myPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: _currentPage,
        onTap: (index) {
          context.read<CommonProvider>().changeSelectTabIndex(index);
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}
