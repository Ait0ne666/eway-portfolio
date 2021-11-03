import 'package:flutter/material.dart';
import 'package:lseway/core/widgets/cupertino_progress.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Center(
            child: Image.asset('assets/logo.png'),
          ),
          Positioned(
              bottom: MediaQuery.of(context).size.height*0.1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
            children: [
                const CupertinoActivityIndicator(),
                const SizedBox(width: 12,),
                Text(
                  'Ищем станции поблизости...',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: const Color(0xffB1B3BD), fontSize: 16),
                  textAlign: TextAlign.center,
                )
            ],
          ),
              ))
        ],
      ),
    );
  }
}
