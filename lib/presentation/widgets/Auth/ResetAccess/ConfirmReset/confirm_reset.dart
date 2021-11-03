import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';
import 'package:lseway/presentation/navigation/main_router.dart';
import 'package:lseway/presentation/widgets/Core/PinCodeField/pin_code_field.dart';
import 'package:lseway/presentation/widgets/Core/SendAgainButton/send_again_button.dart';
import 'package:lseway/utils/utils.dart';

class ConfirmReset extends StatefulWidget {
  final String email;
  const ConfirmReset({Key? key, required this.email}) : super(key: key);

  @override
  _ConfirmResetState createState() => _ConfirmResetState();
}

class _ConfirmResetState extends State<ConfirmReset> {
  String code = '';
  bool error = false;

  void onCodeChange(String? text) {
    setState(() {
      code = text ?? '';
      error = false;
    });
    if (text?.length == 4) {
      onSubmit();
    }
  }

  void onSubmit() {
    BlocProvider.of<UserBloc>(context).add(ConfirmResetEmail(email: widget.email, code: code));
  }


  void authListener(BuildContext context, UserState state) {
    setupBlocListener<UserState, UserLoadingState, ResetConfirmEmailErrorState,
            ResetConfrimEmailSuccessState>(context, state,
        (state) {
      MainRouter.router.navigateTo(context, '/reset/phone',
          routeSettings:
              RouteSettings(arguments: EmailParams(email: state.email)),
          transition: TransitionType.cupertino, replace: true);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 50),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            BlocListener<UserBloc, UserState>(listener: authListener, child: const SizedBox(),),
            Text(
              'Введите код',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(
              height: 32,
            ),
            const Text(
              'Мы отправили код на электронный адрес:',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xffB1B3BD), fontSize: 15, fontFamily: 'Circe'),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(widget.email,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(fontSize: 18)),
            const SizedBox(
              height: 32,
            ),
            PinCodeField(
              onChange: onCodeChange,
              length: 4,
              error: error,
            )
          ],
        ),
        SendAgainButton(
          onSend: () {
            BlocProvider.of<UserBloc>(context)
                .add(ApplyForResetWithEmail(email: widget.email));
          },
          sendText: 'Письмо с кодом отправлено на указанный e-mail',
          time: 15,
        )
      ]),
    );
  }
}
