import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:open_video/common/net/net_manager.dart';

class ListVideoPage extends StatefulWidget {
  const ListVideoPage({Key? key}) : super(key: key);

  @override
  State<ListVideoPage> createState() => _ListVideoPageState();
}

class _ListVideoPageState extends State<ListVideoPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("列表"),
      ),
    );
  }

  _loadData() async {
    var response =
        await LRNetManager.get("/getHaoKanVideo", pra: {"page": 0, "size": 10});
    if (response.success) {
      debugPrint("请求数据:${response.data}");
    } else {
      debugPrint("请求失败");
    }
  }
}
