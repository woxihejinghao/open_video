import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:open_video/common/net/net_manager.dart';
import 'package:open_video/common/route/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/instance.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "登录",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  30, MediaQuery.of(context).size.height * 0.1, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _accountController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: "请输入邮箱",
                        prefixIcon: Icon(Icons.email_outlined)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
                        hintText: "请输入密码",
                        prefixIcon: Icon(Icons.lock_outline)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                        double.infinity,
                        50,
                      ),
                    ),
                    child: const Text(
                      "登录",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  _buildRegistButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegistButton() {
    return TextButton(
        onPressed: () {
          context.lrNavigatorTo(Routes.regist);
        },
        child: const Text(
          "去注册",
          style: TextStyle(fontSize: 15),
        ));
  }

  _login() async {
    String account = _accountController.text;
    String password = _passwordController.text;
    showLoading();
    var response = await LRNetManager.post("/login",
        pra: {"account": account, "password": password});
    dismissLoading();
    if (!response.success) {
      showToast(response.message);
      return;
    }
    var pre = await SharedPreferences.getInstance();
    await pre.setString("token", response.data["token"] as String);
    if (!mounted) {
      return;
    }
    router.lrNavigatorTo(context, Routes.main, clearStack: true);
  }
}
