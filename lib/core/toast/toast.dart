import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  static void showToast(BuildContext context, String text) {
    FToast toast = FToast();
    toast.init(context);
    Widget tst = Container(
      width: MediaQuery.of(context).size.width,
      
      padding: EdgeInsets.only(left: 24.0, right: 24, top: 16.0, bottom: 16+MediaQuery.of(context).padding.bottom ),
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[2],
        
        color: Theme.of(context).colorScheme.error,
      ),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
      ),
    );

    toast.showToast(
      child: tst,
      positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            
            left: 0,
            bottom: 0 + MediaQuery.of(context).viewInsets.bottom,
          );
        },
      toastDuration: const Duration(seconds: 4),
    );
  }
}
