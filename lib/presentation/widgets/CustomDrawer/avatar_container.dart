import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';
import 'package:lseway/presentation/navigation/app_router.dart';
import 'package:lseway/presentation/widgets/CustomDrawer/avatar.dart';
import 'package:lseway/utils/utils.dart';

class AvatarContainer extends StatelessWidget {
  const AvatarContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state.user == null) {
        return const SizedBox();
      }
      var user = state.user!;
      return InkWell(
        onTap: () {
          Navigator.of(context).pop();
          AppRouter.router.navigateTo(context, '/profile', transition: TransitionType.cupertino);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(247, 247, 247, 0.3),
                    blurRadius: 26,
                    offset: Offset(0, 8))
              ]),
          child: Row(
            children: [
              CustomAvatar(user: state.user!),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name != null && user.name!.isNotEmpty
                      ? toBeginningOfSentenceCase(user.name!)!
                      : 'Профиль',
                      style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontSize: 18),
                    ),
                    FittedBox(child: Text(convertPhoneToString(user.phone), style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 14),))
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              SvgPicture.asset('assets/chevron-right.svg')
            ],
          ),
        ),
      );
    });
  }
}
