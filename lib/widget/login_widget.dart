import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:testsea/page/forgot_password_page.dart';
import 'package:testsea/provider/google_sign_in.dart';
import 'package:testsea/utils.dart';

import '../main.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          FlutterLogo(size: 70),
          Text(
            "ログイン",
            style: TextStyle(color: Colors.white, fontSize: 35),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: "メールアドレス"),
          ),
          SizedBox(
            height: 4,
          ),
          TextField(
            controller: passwordController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: "パスワード"),
            obscureText: true,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
              onPressed: signIn,
              icon: Icon(Icons.lock_open),
              label: Text(
                "ログイン",
                style: TextStyle(fontSize: 24),
              )),
          SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: Size(double.infinity, 50)),
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);

                provider.googleLogin();
              },
              icon: FaIcon(
                FontAwesomeIcons.google,
                color: Colors.lightBlue,
              ),
              label: Text("Google Sign Up", style: TextStyle(fontSize: 24))),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForgotPasswordPage()));
            },
            child: Text("パスワードをお忘れの方",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.lightBlue)),
          ),
          SizedBox(
            height: 20,
          ),
          RichText(
              text: TextSpan(
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  text: "アカウント作成の方は",
                  children: [
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                    text: "こちら",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.lightBlue))
              ]))
        ],
      ),
    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print("ログインエラー : $e");

      Utils.showSnackBar(e.message);
    }
    //Navigator.of(context) not working!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

/* Google認証の場合　Fire Base Authの設定後　以下をTerminalで実行*/
///mac
///keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
///windows
///keytool -list -v keystore "\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
///
///SHA1: ~~~  をCopy
///Firebase Android＜フィンガープリント追加にPaste