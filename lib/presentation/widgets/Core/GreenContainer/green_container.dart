import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class GreenContainer extends StatelessWidget {
  final double borderRadius;
  final Widget child;
  
  
  
  const GreenContainer({ Key? key, required this.borderRadius, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0,8),
            blurRadius: 26,
            color: Color.fromRGBO(83, 193, 81, 0.4),
          )
        ],
        gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xff4fc985), Color(0xff6cd168)], stops: [0,0.5])
      ),
      child: Neumorphic(
        style: const NeumorphicStyle(
          color: Colors.transparent,
          depth: -2,
          shadowDarkColorEmboss: Color.fromRGBO(255, 255, 255, 0.6),
          shadowLightColorEmboss: Color.fromRGBO(255, 255, 255, 0.6),
        ),
        child: child,
      ),
    );
  }
}