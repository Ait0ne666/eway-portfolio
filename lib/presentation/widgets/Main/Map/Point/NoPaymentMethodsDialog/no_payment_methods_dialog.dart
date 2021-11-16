import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/Settings/PaymentMethods/credit_card_form.dart';
import 'package:lseway/presentation/widgets/global.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void showNoPaymentMethodsDialog(void Function() onSuccess) {
  var context = NavigationService.navigatorKey.currentContext;

  if (context != null) {
    Future(
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
                  maxHeight: 500,
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Center(
                              child: Text(
                                'У вас не привязан способ оплаты',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(fontSize: 28),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Center(
                              child: Text(
                                'Добавьте платежную карту или настройте оплату с ${Platform.isIOS ? "Apple Pay" : "Google Pay"}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(
                                        fontSize: 18, fontFamily: 'Circe'),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 45,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: CustomButton(
                              onPress: () {
                                Navigator.of(dialogContext, rootNavigator: true)
                                    .pop();
                                handleAddCard(onSuccess);
                              },
                              text: 'Добавить карту',
                              icon: Image.asset(
                                'assets/card-green.png',
                                width: 28,
                              ),
                              type: ButtonTypes.SECONDARY,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: CustomButton(
                              onPress: () {},
                              text: Platform.isIOS ? 'Аpple Pay' : 'Google Pay',
                              type: ButtonTypes.DARK,
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 21,
                      right: 21,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(dialogContext, rootNavigator: true)
                              .pop();
                        },
                        child: SvgPicture.asset('assets/close.svg'),
                      ),
                    )
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

void handleAddCard(void Function() onSuccess) {
  var context = NavigationService.navigatorKey.currentContext;

  if (context != null) {
    showMaterialModalBottomSheet(
        context: context,
        barrierColor: const Color.fromRGBO(38, 38, 50, 0.2),
        backgroundColor: Colors.transparent,
        isDismissible: true,
        builder: (dialogContext) {
          return CreditCardForm(
            onSuccess: onSuccess,
            extent: 550,
          );
        });
  }
}
