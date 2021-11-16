import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/presentation/widgets/Main/Map/Book/book_modal_content.dart';
import 'package:lseway/presentation/widgets/global.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void showBookModal(int pointId, int connector) {
  var context = NavigationService.navigatorKey.currentContext;

  if (context == null) {
  } else {
    showMaterialModalBottomSheet(
        context: context,
        barrierColor: const Color.fromRGBO(38, 38, 50, 0.2),
        backgroundColor: Colors.transparent,
        useRootNavigator: true,
        builder: (dialogContext) {
          return ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  // color: const Color.fromRGBO(38, 38, 50, 0.2),
                  padding: const EdgeInsets.only(
                      top: 135, bottom: 20, left: 20, right: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                        height: 597,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white),
                        child: Material(
                          color: Colors.transparent,
                          child: BookModalContent(
                            pointId: pointId,
                            connector: connector,
                          ),
                        )),
                  ),
                ),
              ),
            ),
          );
        }).then((value) {});
  }
}
