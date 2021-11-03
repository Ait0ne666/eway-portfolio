import 'package:flutter/material.dart';


class DialogBuilder {
  



  void showLoadingDialog(BuildContext context) {
      
      Future(
      () => showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (dialogContext) {
          return SimpleDialog(
            
            backgroundColor: Colors.transparent,
            elevation: 0,
            children: [
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.error),
                ),
              )
            ],
          );
        },
      ),
    );
  }


  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }


}