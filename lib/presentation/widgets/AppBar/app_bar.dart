import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/Filter/filter.dart';
import 'package:lseway/presentation/widgets/Menu/menu.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [CustomMenu(), CustomFilter()],
          ),
        ),
        top: MediaQuery.of(context).viewPadding.top + 30,
        left: 0);
  }
}
