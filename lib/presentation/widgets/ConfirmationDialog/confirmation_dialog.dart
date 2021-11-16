import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/global.dart';

void showConfirmationModal(void Function() onSuccess, void Function() onCancel,
    List<String> text, String subtext) {
  var globalCtx = NavigationService.navigatorKey.currentContext;

  if (globalCtx != null) {
    Future(
      () => showDialog(
        context: globalCtx,
        barrierDismissible: true,
        useRootNavigator: true,
        barrierColor: const Color.fromRGBO(38, 38, 50, 0.2),
        builder: (dialogContext) {
          return SimpleDialog(
            backgroundColor: Theme.of(dialogContext).colorScheme.primaryVariant,
            insetPadding: const EdgeInsets.all(20),
            contentPadding: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 2,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 480),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(dialogContext).size.width - 40,
                      padding: const EdgeInsets.only(bottom: 20, top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/green-bolt.png',
                            width: 90,
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 280),
                            child: Text.rich(
                              TextSpan(
                                  children: text.map((e) {
                                return TextSpan(
                                  text: e== text[0] ? e : '\n'+ e,
                                  style: Theme.of(dialogContext)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(fontSize: 22),
                                );
                              }).toList()),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            subtext,
                            style: Theme.of(dialogContext)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                    color: const Color(0xff1A1D21),
                                    fontSize: 18),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 272),
                              child: CustomButton(
                                text: 'Нет',
                                type: ButtonTypes.SECONDARY,
                                bgColor: const Color(0xffEDEDF3),
                                onPress: onCancel,
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 272),
                              child: CustomButton(
                                text: 'Да!',
                                type: ButtonTypes.PRIMARY,
                                onPress: onSuccess,
                              )),
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
}
