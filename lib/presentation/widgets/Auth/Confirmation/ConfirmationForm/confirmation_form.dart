import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/core/dialogBuilder/dialogBuilder.dart';
import 'package:lseway/core/snackbarBuilder/snackbarBuilder.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';
import 'package:lseway/presentation/navigation/main_router.dart';
import 'package:lseway/presentation/widgets/Core/CustomInput/custom_input.dart';
import 'package:lseway/presentation/widgets/Core/PinCodeField/pin_code_field.dart';

class ConfirmationForm extends StatefulWidget {
  final String phone;
  const ConfirmationForm({Key? key, required this.phone}) : super(key: key);



  @override
  _ConfirmationFormState createState() => _ConfirmationFormState();
}

class _ConfirmationFormState extends State<ConfirmationForm> {

  String code = '';
  bool error = false;

  

  @override
  void dispose() {


    super.dispose();
  }

  void onSubmit() {

      BlocProvider.of<UserBloc>(context)
          .add(ConfirmPhone(code: code, phone: widget.phone));
    
  }

  void authListener(BuildContext context, UserState state) {
    print(state);
    var dialog = DialogBuilder();

    if (state is UserConfirmingState) {
      if (ModalRoute.of(context) != null && ModalRoute.of(context)!.isCurrent) {
        dialog.showLoadingDialog(context);
      }
    } else if (state is UserCodeConfirmationErrorState) {
      if (ModalRoute.of(context) != null && ModalRoute.of(context)!.isActive) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          error=true;
        });
        SnackBar snackBar = SnackbarBuilder.errorSnackBar(
            text: state.message, context: context);

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else if (state is UserAuthorizedState) {
      if (ModalRoute.of(context) != null && ModalRoute.of(context)!.isActive) {
        Navigator.of(context, rootNavigator: true).pop();
        MainRouter.router.navigateTo(context, '/main', clearStack: true, transition: TransitionType.cupertino);
      }
    }
  }


  void onCodeChange(String? text) {
    setState(() {
      code = text ?? '';
      error = false;
    });
    if (text?.length == 6) {
      onSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocListener<UserBloc, UserState>(
            listener: authListener,
            child: const SizedBox(),
          ),
          Container(
              child: Column(
            children: [
              PinCodeField(onChange: onCodeChange, length: 6, error: error,),
              const SizedBox(
                height: 19,
              ),
            ],
          ))
        ],
      ),
    );
  }
}
