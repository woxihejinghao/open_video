import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:open_video/common/net/net_manager.dart';
import 'package:open_video/wallpaper/model/wallpaper_list_model.dart';
import 'package:open_video/wallpaper/view/wallpaper_list_item.dart';
import 'package:open_video/wallpaper/wallpaper_browse_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WallpaperListPage extends StatefulWidget {
  final String category;
  const WallpaperListPage({Key? key, required this.category}) : super(key: key);

  @override
  State<WallpaperListPage> createState() => _WallpaperListPageState();
}

class _WallpaperListPageState extends State<WallpaperListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  var _currentPage = 0;
  List<WallpaperListModel> _dataList = [];

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      enablePullUp: true,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4 / 3,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5),
        itemCount: _dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Hero(
                tag: _dataList[index].url,
                child: WallpaperListItem(model: _dataList[index])),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return WallpaperBrowsePage(url: _dataList[index].url);
              }));
            },
          );
        },
      ),
    );
  }

  _onRefresh() async {
    Map<String, dynamic> pra = {"size": 10, "page": 0};
    if (widget.category.isNotEmpty) {
      pra["type"] = widget.category;
    }
    var response = await LRNetManager.get("/getImages", pra: pra);
    _refreshController.refreshCompleted();
    if (response.success) {
      _currentPage = 0;
      setState(() {
        List list = response.data["list"];
        _dataList = list.map((e) => WallpaperListModel.fromJson(e)).toList();
      });
    }
  }

  _onLoading() async {
    Map<String, dynamic> pra = {"size": 10, "page": _currentPage + 1};
    if (widget.category.isNotEmpty) {
      pra["type"] = widget.category;
    }
    var response = await LRNetManager.get("/getImages", pra: pra);
    _refreshController.loadComplete();
    if (response.success) {
      _currentPage += 1;
      setState(() {
        List list = response.data["list"];
        _dataList
            .addAll(list.map((e) => WallpaperListModel.fromJson(e)).toList());
      });
    }
  }
}
