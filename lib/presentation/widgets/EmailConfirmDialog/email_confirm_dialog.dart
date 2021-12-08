import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/data/data-sources/user/user_local_data_source.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/navigation/app_router.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/global.dart';

import '../../../../injection_container.dart' as di;

void shouldShowConfrimEmail(BuildContext context) async {
  final PendingDynamicLinkData? data =
      await FirebaseDynamicLinks.instance.getInitialLink();
  final Uri? deepLink = data?.link;

  if (deepLink != null) {
    var queryParams = deepLink.queryParameters;
    if (queryParams.containsKey("point_number")) {
      return;
    }
  }
  var localDataSource = di.sl<UserLocalDataSource>();

  bool shown = localDataSource.getEmailConfirmationShown();
  var emailConfirmed =
      BlocProvider.of<UserBloc>(context).state.user?.email_confirmed;

  if (!shown && emailConfirmed != true) {
    // if (true){
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
              Container(
                constraints: const BoxConstraints(maxHeight: 540),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/email-red.png', width: 83),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 261),
                        child: Center(
                          child: Text(
                            'Пожалуйста, укажите e-mail',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(fontSize: 26),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const Text(
                        'Чтобы иметь возможность восстановить доступ к своему аккаунту, добавьте резервный адрес электронной почты',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Circe',
                          color: Color(0xffB1B3BD),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 21,
                      ),
                      const Text(
                        'Также вы можете добавить его позже в разделе личных данных',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Circe',
                          color: Color(0xffB1B3BD),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 39,
                      ),
                      CustomButton(
                        text: 'Указать почту',
                        onPress: () {
                          Navigator.of(dialogContext, rootNavigator: true)
                              .pop();
                          AppRouter.router.navigateTo(context, '/email');
                        },
                      ),
                      const SizedBox(
                        height: 19,
                      ),
                      CustomButton(
                        text: 'Спасибо, позже',
                        type: ButtonTypes.SECONDARY,
                        onPress: () {
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    ).then((value) {
      localDataSource.saveEmailConfirmationShown();
    });
  }
}
