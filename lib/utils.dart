import 'package:flutter/material.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text) {
    if (text == null) return;

    switch (text) {
      case 'Given String is empty or null':
        text = "メールアドレスを入力してください";
        break;
      case 'The email address is badly formatted.':
        text = "有効なメールアドレスを入力してください";
        break;
        case 'The email address is already in use by another account.':
        text = "登録済みのメールアドレスです";
        break;
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
        text = "メールアドレスまたはパスワードが違います";
        break;
        case 'The email address is badly formatted.':
        text = "有効なメールアドレスを入力してください";
        break;
        case 'The password is invalid or the user does not have a password.':
        text = "メールアドレスまたはパスワードが違います";
        break;
        case 'Password should be at least 6 characters':
        text = "パスワードは6文字以上で構成してください";
        break;
      default:
    }

    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
