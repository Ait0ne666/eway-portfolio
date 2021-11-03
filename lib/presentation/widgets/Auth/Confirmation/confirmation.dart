import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/navigation/main_router.dart';
import 'package:lseway/presentation/widgets/Auth/Confirmation/ConfirmationForm/confirmation_form.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/Core/SendAgainButton/send_again_button.dart';
import 'package:lseway/utils/utils.dart';

class Confirmation extends StatelessWidget {
  final String phone;
  const Confirmation({Key? key, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
          'Введите код',
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(
          height: 32,
        ),
        Text(
          'Мы отправили код на номер:',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontSize: 15,
                color: const Color(0xffB1B3BD),
              ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          convertPhoneToString(phone),
          style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 16),
        ),
        const SizedBox(
          height: 32,
        ),
        ConfirmationForm(phone: phone),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: 'Неверно указан номер?',
                onPress: () {
                  MainRouter.router.pop(context);
                },
                type: ButtonTypes.SECONDARY,
                bgColor: const Color(0xffE7E7F2),
              ),
              const SizedBox(
                height: 15,
              ),
              SendAgainButton(
                  time: 60,
                  onSend: () {
                    BlocProvider.of<UserBloc>(context)
                        .add(RequestPhoneConfirmation(phone: phone));
                  },
                  sendText: 'Код выслан на указанный номер')
            ],
          ),
        ),
      ]),
    );
  }
}
