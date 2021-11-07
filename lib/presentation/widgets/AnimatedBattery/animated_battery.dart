import 'package:flutter/material.dart';
import 'package:rainbow_color/rainbow_color.dart';

class AnimatedBattery extends StatefulWidget {
  const AnimatedBattery({ Key? key }) : super(key: key);

  @override
  _AnimatedBatteryState createState() => _AnimatedBatteryState();
}

class _AnimatedBatteryState extends State<AnimatedBattery> with SingleTickerProviderStateMixin {


  late AnimationController _controller;
  late Animation<Color> _beginAnimation;
  late Animation<Color> _endAnimation;
  late Animation<double> _heightAnimation;


  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const  Duration(seconds: 4));

    _beginAnimation = RainbowColorTween([Color(0xffBB0D0C), Color(0xffF2CE10), Color(0xff64C854)]).animate(_controller);
    _endAnimation = RainbowColorTween([Color(0xffE7151D), Color(0xffE7151D), Color(0xffC87800), Color(0xff38B88A), Color(0xff38B88A)]).animate(_controller);
    _heightAnimation = Tween<double>(begin: 80, end: 309).animate(_controller);
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 309,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 180,
              height: _heightAnimation.value,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [_beginAnimation.value, _endAnimation.value], begin: Alignment.bottomCenter, end: Alignment.topCenter )
              ),
              child: child,
            ),
          );
        },
        child: Container(),
      ),
    );
  }
}