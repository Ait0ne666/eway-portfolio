import 'package:flutter/material.dart';

class SnackbarBuilder {


  SnackbarBuilder();

  static SnackBar errorSnackBar({required BuildContext context, required String text}) {
    Duration time = Duration(milliseconds: 6000);
    String actionText = "OK";


    void onPress() {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }

    return SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
      ),
      duration: time,
      backgroundColor: Theme.of(context).colorScheme.error,
      action:  SnackBarAction(
        label: actionText,
        onPressed: onPress,
        textColor: Colors.white,
      ) 
    );
  }

    static SnackBar successSnackBar({required BuildContext context, required String text}) {
    Duration time = Duration(milliseconds: 6000);
    String actionText = "OK";


    void onPress() {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }

    return SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
      ),
      duration: time,
      backgroundColor: Color(0xffa2cf6e),
      action:  SnackBarAction(
        label: actionText,
        onPressed: onPress,
        textColor: Colors.white,
      ) 
    );
  }
}
