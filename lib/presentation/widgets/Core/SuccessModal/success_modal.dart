import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';

Future<dynamic> showSuccessModal(BuildContext context, Widget text) {
  return Future(
    () => showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: true,
      barrierColor: const Color.fromRGBO(38, 38, 50, 0.2),
      builder: (dialogContext) {
        return SimpleDialog(
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          insetPadding: const EdgeInsets.all(20),
          contentPadding: EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 2,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 430,
              ),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width-40,
                    padding: const EdgeInsets.symmetric(vertical: 70),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/check-green.png',
                          width: 124,
                        ),
                        text,
                        const SizedBox(
                          height: 59,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 220),
                          child: CustomButton(
                              text: 'Отлично',
                              sharpAngle: true,
                              postfix:
                                  SvgPicture.asset('assets/chevron-red.svg'),
                              onPress: () {
                                Navigator.of(dialogContext).pop();
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    ),
  );
}
