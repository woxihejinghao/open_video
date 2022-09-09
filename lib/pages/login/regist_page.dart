import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:open_video/common/instance.dart';
import 'package:open_video/common/net/net_manager.dart';
import 'package:open_video/common/route/router.dart';

class RegistPage extends StatefulWidget {
  const RegistPage({Key? key}) : super(key: key);

  @override
  State<RegistPage> createState() => _RegistPageState();
}

class _RegistPageState extends State<RegistPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  Timer? timer;
  int seconds = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "注册",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                30, MediaQuery.of(context).size.height * 0.1, 30, 0),
            child: Column(
              children: [
                TextField(
                  controller: _accountController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      hintText: "请输入邮箱",
                      prefixIcon: Icon(Icons.email_outlined)),
                ),
                const SizedBox(
                  height: 15,
                ),
                _buildCodeTextfield(),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: "请输入密码", prefixIcon: Icon(Icons.lock_outline)),
                ),
                const SizedBox(
                  height: 30,
                ),
                _buildRegistButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeTextfield() {
    return TextField(
      maxLength: 6,
      controller: _codeController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: "请输入验证码",
          suffixIcon: TextButton(
              onPressed: seconds <= 0 ? _sendCode : null,
              child: Text(
                seconds > 0 ? "${seconds} s" : "验证码",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ))),
    );
  }

  Widget _buildRegistButton() {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
            onPressed: _registAndLogin, child: const Text("注册并登录")));
  }

  //发送注册验证码
  _sendCode() async {
    String mail = _accountController.text;
    String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
    if (!RegExp(regexEmail).hasMatch(mail)) {
      showToast("请输入正确的邮箱");
      return;
    }
    showLoading();
    var response = await LRNetManager.post("/sendVerificationCode",
        pra: {"mail": _accountController.text});
    dismissLoading();
    if (!response.success) {
      showToast(response.message);
      return;
    }
    showToast("发送成功");
    setState(() {
      seconds = 60;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds -= 1;
        if (seconds <= 0) {
          timer.cancel();
        }
      });
    });
  }

  _registAndLogin() async {
    showLoading();
    String account = _accountController.text;
    String code = _codeController.text;
    String password = _passwordController.text;
    var response = await LRNetManager.post("/register",
        pra: {"account": account, "code": code, "password": password});
    dismissLoading();
    if (!response.success) {
      showToast(response.message);
      return;
    }
    if (!mounted) {
      return;
    }
    router.lrNavigatorTo(context, Routes.main, clearStack: true);
  }
}
