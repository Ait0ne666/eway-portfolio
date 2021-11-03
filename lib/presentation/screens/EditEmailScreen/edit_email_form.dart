import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/domain/entitites/user/user.entity.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/Core/CustomInput/custom_input.dart';

class EditEmailForm extends StatefulWidget {
  final User user;

  const EditEmailForm({Key? key, required this.user}) : super(key: key);

  @override
  _EditEmailFormState createState() => _EditEmailFormState();
}

class _EditEmailFormState extends State<EditEmailForm> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<CustomInputState> _emailKey =
      GlobalKey<CustomInputState>();



  @override
  void initState() {
    _emailController.value = TextEditingValue(text: widget.user.email ?? '');
    super.initState();
  }



  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }


  void handleSubmit() {
    var emailError = _emailKey.currentState?.handleValidation();

    if (emailError == null) {
      var email = _emailController.value.text.trim();
      FocusScope.of(context).requestFocus(new FocusNode());
      BlocProvider.of<UserBloc>(context).add(ChangeEmail(email: email));
    }
  }





  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInput(
          type: CustomInputTypes.TEXT,
          controller: _emailController,
          label: 'Как вас зовут?',
          isCentered: true,
          key: _emailKey,
          required: true,
          autofocus: true,
        ),
        const SizedBox(height: 30,),
        CustomButton(text: 'Сохранить', onPress: handleSubmit),
        const SizedBox(height: 62,),
        Text('На почту будет выслана ссылка для подтверждения', style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 14), textAlign: TextAlign.center, )
      ],
    );
  }
}
