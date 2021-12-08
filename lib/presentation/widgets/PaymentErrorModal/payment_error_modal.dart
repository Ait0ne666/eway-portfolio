import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lseway/presentation/navigation/app_router.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/global.dart';

void showPaymentErrorodal(void Function() repeat) {
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
                constraints: const BoxConstraints(maxHeight: 380),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(dialogContext).size.width - 40,
                      padding: const EdgeInsets.only(bottom: 20, top: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/green-bolt.png',
                            width: 90,
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 280),
                            child: Text('Не удалось провести оплату', style: Theme.of(dialogContext)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(fontSize: 22),
                                      textAlign: TextAlign.center,
                                      )
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 272),
                              child: CustomButton(
                                text: 'Повторить',
                                type: ButtonTypes.SECONDARY,
                                bgColor: const Color(0xffEDEDF3),
                                onPress: () {
                                  Navigator.of(dialogContext).pop();
                                  repeat();
                                },
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 272),
                              child: CustomButton(
                                text: 'Способы оплаты',
                                type: ButtonTypes.DARK,
                                onPress: () {
                                  Navigator.of(dialogContext).pop();
                                  AppRouter.router.navigateTo(dialogContext, '/paymentMethods');
                                },
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
