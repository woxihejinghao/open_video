import 'package:flutter/material.dart';

class FullScreenVideoPage extends StatefulWidget {
  const FullScreenVideoPage({Key? key}) : super(key: key);

  @override
  State<FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("全")),
    );
  }
}
