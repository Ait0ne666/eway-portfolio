import 'package:flutter/material.dart';





class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({ Key? key }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          child: Center(
            child: Center(
              child: ElevatedButton(child: const Text('Welcome screen'), onPressed: () {
                // BlocProvider.of<UserBloc>(context).add(Logout());
              },),
            ),
          ),
        ),
      );
  }
}