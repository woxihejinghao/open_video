import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoadingToast extends StatelessWidget {
  const LoadingToast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CupertinoActivityIndicator(
                  radius: 15,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "正在加载～",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
