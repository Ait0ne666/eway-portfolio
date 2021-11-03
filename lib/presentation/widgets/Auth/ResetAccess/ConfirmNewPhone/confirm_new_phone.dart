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

class ConfirmNewPhone extends StatefulWidget {
  final String email;
  final String phone;
  const ConfirmNewPhone({Key? key, required this.email, required this.phone}) : super(key: key);

  @override
  _ConfirmNewPhoneState createState() => _ConfirmNewPhoneState();
}

class _ConfirmNewPhoneState extends State<ConfirmNewPhone> {
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
    BlocProvider.of<UserBloc>(context).add(ConfirmNewPhoneEvent(email: widget.email, code: code, phone: widget.phone));
  }


  void authListener(BuildContext context, UserState state) {
    setupBlocListener<UserState, UserLoadingState, ResetConfirmNewPhoneErrorState,
            UserAuthorizedState>(context, state,
        (state) {
          MainRouter.router.navigateTo(context, '/main', clearStack: true, transition: TransitionType.cupertino);
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
              'Мы отправили код на номер:',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xffB1B3BD), fontSize: 15, fontFamily: 'Circe'),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(convertPhoneToString(widget.phone),
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
          sendText: 'Письмо с кодом отправлено на указанный номер',
          time: 60,
        )
      ]),
    );
  }
}
