import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/presentation/navigation/app_router.dart';
import 'package:lseway/presentation/widgets/Filter/filter.dart';
import 'package:lseway/presentation/widgets/IconButton/icon_button.dart';
import 'package:lseway/presentation/widgets/Menu/menu.dart';

class CustomAppBar extends StatelessWidget {
  final void Function() reload;
  const CustomAppBar({Key? key, required this.reload}) : super(key: key);

  void showNearest(BuildContext context) {
    AppRouter.router
        .navigateTo(context, '/nearest', transition: TransitionType.cupertino)
        .then((value) {
      reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomMenu(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconButton(
                      icon: SvgPicture.asset('assets/list.svg'),
                      onTap: () => showNearest(context)),
                  const SizedBox(
                    width: 12,
                  ),
                  const CustomFilter(),
                ],
              ),
            ],
          ),
        ),
        top: MediaQuery.of(context).viewPadding.top + 30,
        left: 0);
  }
}
