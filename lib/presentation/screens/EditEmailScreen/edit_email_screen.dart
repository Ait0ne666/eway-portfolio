import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/core/dialogBuilder/dialogBuilder.dart';
import 'package:lseway/core/snackbarBuilder/snackbarBuilder.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';
import 'package:lseway/presentation/navigation/app_router.dart';
import 'package:lseway/presentation/navigation/main_router.dart';
import 'package:lseway/presentation/screens/EditEmailScreen/edit_email_form.dart';
import 'package:lseway/presentation/widgets/CustomAppBar/custom_profile_bar.dart';
import 'package:lseway/presentation/widgets/global.dart';

class EditEmailScreen extends StatelessWidget {
  const EditEmailScreen({Key? key}) : super(key: key);

  void changeListener(BuildContext context, UserState state) {
    var dialog = DialogBuilder();

    if (state is UserChangingState) {
      if (ModalRoute.of(context) != null && ModalRoute.of(context)!.isCurrent) {
        dialog.showLoadingDialog(context);
      }
    } else if (state is UserChangeErrorState) {
      if (ModalRoute.of(context) != null && ModalRoute.of(context)!.isActive) {
        Navigator.of(context, rootNavigator: true).pop();
        SnackBar snackBar = SnackbarBuilder.errorSnackBar(
            text: state.message, context: context);

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else if (state is UserChangedState) {
      if (ModalRoute.of(context) != null && ModalRoute.of(context)!.isActive) {
        Navigator.of(context, rootNavigator: true).pop();
        AppRouter.router.navigateTo(context, '/email/code',
            transition: TransitionType.cupertino, replace: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF0F1F6),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: MediaQuery.of(context).viewPadding.top + 30),
          child: Column(
            children: [
              const CustomProfileBar(title: 'Введите E-mail', isCentered: true,),
              const SizedBox(
                height: 73,
              ),
              BlocConsumer<UserBloc, UserState>(
                listener: changeListener,

                builder: (context, state) {
                  if (state.user !=null) {
                  return EditEmailForm(user: state.user!,);

                  } else {
                    return const  SizedBox();
                  }
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
