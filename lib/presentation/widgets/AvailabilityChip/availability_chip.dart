import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AvailabilityChip extends StatelessWidget {
  final bool available;
  final bool up;
  const AvailabilityChip({Key? key, required this.available, required this.up}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 33,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          
          gradient: LinearGradient(colors: !up ? [Color(0xff8F9398), Color(0xffB4B7C1)]  : available ? [
            Color(0xff41C696),
            Color(0xff6BD15A),
          ] : [Color(0xffE01E1D), Color(0xffF41D25)], begin: Alignment.centerLeft, end: Alignment.centerRight, stops: [0, 0.2]),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(83, 193, 81, 0.25),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),

          ]
          ),
      child: Container(
        width: double.infinity,
        height: 33,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
        ),
        child: Center(
          child: Text(
            !up ? 'неактивна' :  available ? 'свободна' : 'занята',
            style: Theme.of(context).textTheme.overline,
          ),
        ),
      ),
    );
  }
}
