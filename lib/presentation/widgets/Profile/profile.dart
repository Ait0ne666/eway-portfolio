import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';
import 'package:lseway/presentation/navigation/app_router.dart';
import 'package:lseway/presentation/widgets/CustomDrawer/avatar.dart';
import 'package:lseway/presentation/widgets/Profile/charge_end_switcher.dart';
import 'package:lseway/utils/utils.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state.user == null) {
        return const SizedBox();
      }

      var user = state.user!;

      return Column(
        children: [
          Row(
            children: [
              CustomAvatar(
                user: user,
                bg: Color(0xffE4E5EB),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ваш телефон',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(convertPhoneToString(user.phone),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontSize: 20))
                ],
              )
            ],
          ),
          const Divider(
            height: 64,
            thickness: 1.6,
            color: Color(0xffE0E0EB),
          ),
          InkWell(
            onTap: () {
              AppRouter.router.navigateTo(context, '/name',
                  transition: TransitionType.cupertino);
            },
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Как вас зовут?',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 4),
                      Text(user.name ?? 'Не указано',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(fontSize: 20))
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
          const SizedBox(height: 45),
          InkWell(
            onTap: () {
              AppRouter.router.navigateTo(context, '/email',
                  transition: TransitionType.cupertino);
            },
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ваш e-mail',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email ?? 'Не указан',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontSize: 20),
                      ),
                      SizedBox(height: user.email != null ? 4 : 0),
                      user.email != null
                          ? Row(
                              children: [
                                user.email_confirmed
                                    ? Image.asset('assets/check-small.png', width: 17.5)
                                    : const SizedBox(),
                                SizedBox(
                                  width: user.email_confirmed ? 8 : 0,
                                ),
                                Text(
                                  user.email_confirmed
                                      ? 'Подтвержден'
                                      : 'Не подтвержден',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Circe',
                                      fontWeight: FontWeight.w800,
                                      color: user.email_confirmed
                                          ? const Color(0xff5CCD9E)
                                          : Theme.of(context)
                                              .colorScheme
                                              .error),
                                )
                              ],
                            )
                          : const SizedBox()
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
          const Divider(
            height: 64,
            thickness: 1.6,
            color: Color(0xffE0E0EB),
          ),
          const ChargeEndSwitcher()
        ],
      );
    });
  }
}
