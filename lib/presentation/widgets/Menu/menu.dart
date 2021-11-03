import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/widgets/IconButton/icon_button.dart';

class CustomMenu extends StatelessWidget {
  const CustomMenu({Key? key}) : super(key: key);

  void openMenu(BuildContext context) {
    // BlocProvider.of<UserBloc>(context).add(Logout());
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
        onTap:() => openMenu(context), icon: SvgPicture.asset('assets/burger.svg'));
  }
}
