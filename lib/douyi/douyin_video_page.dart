import 'package:flutter/material.dart';
import 'package:open_video/common/net/net_manager.dart';
import 'package:open_video/douyi/model/douyi_list_model.dart';
import 'package:open_video/douyi/view/douyi_video_item.dart';

class DouYinVideoPage extends StatefulWidget {
  const DouYinVideoPage({Key? key}) : super(key: key);

  @override
  State<DouYinVideoPage> createState() => _DouYinVideoPageState();
}

class _DouYinVideoPageState extends State<DouYinVideoPage> {
  int _currentPage = 0;
  List<DouYinListModel> _dataList = [];

  final PageController _pageController = PageController();
  //是否已经加载过
  bool _isLoaded = false;
  @override
  void initState() {
    super.initState();
    _loadData();
    _pageController.addListener(() {
      if (((_pageController.page ?? 0) >= _dataList.length - 3) && !_isLoaded) {
        _isLoaded = true;
        _loadData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return DouYinVideoItem(model: _dataList[index]);
        },
        itemCount: _dataList.length,
      ),
    );
  }

  _loadData() async {
    var response = await LRNetManager.get("/getMiniVideo",
        pra: {"limit": 10, "page": _currentPage});
    if (!response.success) {
      return;
    }
    _currentPage += 1;
    List list = response.data["list"];
    if (_currentPage == 0) {
      _dataList = list.map((e) => DouYinListModel.fromJson(e)).toList();
    } else {
      _dataList.addAll(list.map((e) => DouYinListModel.fromJson(e)).toList());
    }
    _isLoaded = false;
    setState(() {});
  }
}
