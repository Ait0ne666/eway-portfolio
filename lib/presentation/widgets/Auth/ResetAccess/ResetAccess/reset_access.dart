import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/core/dialogBuilder/dialogBuilder.dart';
import 'package:lseway/core/snackbarBuilder/snackbarBuilder.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';
import 'package:lseway/presentation/navigation/main_router.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/Core/CustomInput/custom_input.dart';
import 'package:lseway/utils/utils.dart';

class ResetAccess extends StatefulWidget {
  const ResetAccess({Key? key}) : super(key: key);

  @override
  _ResetAccessState createState() => _ResetAccessState();
}

class _ResetAccessState extends State<ResetAccess> {
  final GlobalKey<CustomInputState> _emailKey = GlobalKey<CustomInputState>();
  final TextEditingController _emailController = TextEditingController();

  void onPress() {
    var emailError = _emailKey.currentState?.handleValidation();

    if (emailError == null) {
      var email = _emailController.value.text;
      BlocProvider.of<UserBloc>(context)
          .add(ApplyForResetWithEmail(email: email));
    }
  }

  void authListener(BuildContext context, UserState state) {
    setupBlocListener<UserState, UserLoadingState, ResetSendEmailErrorState,
            ResetSendEmailSuccessState>(context, state,
        (ResetSendEmailSuccessState state) {
      MainRouter.router.navigateTo(context, '/reset/confirm',
          routeSettings:
              RouteSettings(arguments: EmailParams(email: state.email)),
          transition: TransitionType.cupertino, replace: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        BlocListener<UserBloc, UserState>(listener: authListener, child: const SizedBox(),),
        Text(
          'Восстановить доступ',
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Вам придет письмо с кодом для восстановления доступа к аккаунту',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(0xffB1B3BD), fontSize: 15, fontFamily: 'Circe'),
        ),
        const SizedBox(
          height: 42,
        ),
        const Text(
          'Укажите почту, привязанную к аккаунту',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff1A1D21),
            fontSize: 15,
            fontFamily: 'Circe',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 13,
        ),
        CustomInput(
          type: CustomInputTypes.EMAIL,
          controller: _emailController,
          required: true,
          key: _emailKey,
        ),
        const SizedBox(
          height: 35,
        ),
        CustomButton(text: 'Восстановить доступ', onPress: onPress)
      ]),
    );
  }
}
