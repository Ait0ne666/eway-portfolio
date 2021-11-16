import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';
import 'package:lseway/presentation/widgets/Core/SendAgainButton/send_again_button.dart';
import 'package:lseway/presentation/widgets/CustomAppBar/custom_profile_bar.dart';

class ConfrimEmailScreen extends StatelessWidget {
  const ConfrimEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF0F1F6),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: MediaQuery.of(context).viewPadding.top + 30),
          child: Column(
            children: [
              const CustomProfileBar(title: 'Подтверждение', isCentered: true,),
              const SizedBox(
                height: 73,
              ),
              Text(
                'Мы отправили ссылку с подтверждением',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 16, height: 1.1),
                textAlign: TextAlign.center,
              ),
              Text(
                'на электронный адрес',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 16, height: 1.1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                if (state.user != null && state.user!.email != null) {
                  return Column(
                    children: [
                      Text(
                        state.user!.email!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 260,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: SendAgainButton(
                          onSend: () {
                            BlocProvider.of<UserBloc>(context)
                                .add(ChangeEmail(email: state.user!.email!, aggree: state.user!.aggreedToNews));
                          },
                          sendText: 'Письмо успешно отправлено',
                        ),
                      )
                    ],
                  );
                }
                return const SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
