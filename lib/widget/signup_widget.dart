import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:testsea/utils.dart';

import '../main.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const SignUpWidget({Key? key, required this.onClickedSignIn})
      : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
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
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            FlutterLogo(size: 70),
            Text(
              "新規登録",
              style: TextStyle(color: Colors.white, fontSize: 35),
            ),
            TextFormField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "メールアドレス"),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) {
                email != null && EmailValidator.validate(email)
                    ? '有効なメールアドレスを入力してください'
                    : null;
              },
            ),
            SizedBox(
              height: 4,
            ),
            TextFormField(
              controller: passwordController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: "パスワード"),
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                value != null && value.length < 6 ? '６文字以上で構成してください' : null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                onPressed: signUp,
                icon: Icon(Icons.lock_open),
                label: Text(
                  "新規登録",
                  style: TextStyle(fontSize: 24),
                )),
            SizedBox(
              height: 20,
            ),
            RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    text: "アカウントをお持ちの方は",
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: "こちら",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.lightBlue))
                ]))
          ],
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      print("アカウント作成エラー $e");
      Utils.showSnackBar(e.message);
    }
    //Navigator.of(context) not working!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
