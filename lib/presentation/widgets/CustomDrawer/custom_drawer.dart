import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/navigation/app_router.dart';
import 'package:lseway/presentation/navigation/main_router.dart';
import 'package:lseway/presentation/widgets/CustomDrawer/avatar_container.dart';
import 'package:lseway/presentation/widgets/CustomDrawer/drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF0F1F6),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewPadding.vertical),
            padding: EdgeInsets.only(
                top: 30, bottom: MediaQuery.of(context).viewPadding.bottom + MediaQuery.of(context).size.height/10, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const AvatarContainer(),
                    const SizedBox(
                      height: 50,
                    ),
                    DrawerItem(
                      icon: Image.asset('assets/wallet-grey.png'),
                      onTap: () {
                        Navigator.of(context).pop();
                        AppRouter.router.navigateTo(context, '/paymentMethods',
                            transition: TransitionType.cupertino);
                      },
                      title: 'Способы оплаты',
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    DrawerItem(
                      icon: Image.asset('assets/calendar-grey.png'),
                      onTap: () {
                        Navigator.of(context).pop();
                        AppRouter.router.navigateTo(context, '/history',
                            transition: TransitionType.cupertino);
                      },
                      title: 'История заказов',
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    DrawerItem(
                      icon: Image.asset('assets/star-grey.png'),
                      onTap: () {
                        Navigator.of(context).pop();
                        AppRouter.router.navigateTo(context, '/topPlaces',
                            transition: TransitionType.cupertino);
                      },
                      title: 'Топ мест',
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    DrawerItem(
                      icon: Image.asset('assets/message-grey.png'),
                      onTap: () {
                        Navigator.of(context).pop();
                        AppRouter.router.navigateTo(context, '/support',
                            transition: TransitionType.cupertino);
                      },
                      title: 'Служба поддержки',
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    DrawerItem(
                      icon: Image.asset('assets/info.png', width: 24,),
                      onTap: () {},
                      title: 'Условия пользования ',
                    ),
                  ],
                ),
                SizedBox(height: 40,),
                InkWell(
                  onTap: () {
                    MainRouter.router.navigateTo(context, '/login',
                        clearStack: true, transition: TransitionType.cupertino);
                    BlocProvider.of<UserBloc>(context).add(Logout());
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Transform.translate(
                          offset: Offset(0, -2),
                          child: Image.asset(
                            'assets/arrow-left.png',
                            width: 45 / 3,
                            height: 33 / 3,
                          )),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        'Выйти из аккаунта',
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'URWGeometricExt',
                            foreground: Paint()
                              ..shader = LinearGradient(colors: [
                                Color(0xffE01E1D),
                                Color(0xffF41D25)
                              ]).createShader(Rect.fromLTWH(0, 0, 163, 31)),
                            shadows: const [
                              Shadow(
                                blurRadius: 26,
                                offset: Offset(0, 8),
                                color: Color.fromRGBO(226, 25, 32, 0.1),
                              ),
                              Shadow(
                                blurRadius: 6,
                                offset: Offset(1, 0),
                                color: Color.fromRGBO(202, 11, 22, 0.15),
                              ),
                            ]),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
