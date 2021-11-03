import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:lseway/domain/entitites/user/user.entity.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';

import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/Core/CustomInput/custom_input.dart';

class EditNameForm extends StatefulWidget {
  final User user;

  const EditNameForm({Key? key, required this.user}) : super(key: key);

  @override
  _EditNameFormState createState() => _EditNameFormState();
}

class _EditNameFormState extends State<EditNameForm> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<CustomInputState> _nameKey =
      GlobalKey<CustomInputState>();



  @override
  void initState() {
    _nameController.value = TextEditingValue(text: widget.user.name ?? '');
    super.initState();
  }



  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }


  void handleSubmit() {
    var nameError = _nameKey.currentState?.handleValidation();

    if (nameError == null) {
      var name = _nameController.value.text.trim();
      FocusScope.of(context).requestFocus(new FocusNode());
      BlocProvider.of<UserBloc>(context).add(ChangeName(name: name));
    }
  }





  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInput(
          type: CustomInputTypes.TEXT,
          controller: _nameController,
          label: 'Как вас зовут?',
          isCentered: true,
          key: _nameKey,
          required: true,
          autofocus: true,
        ),
        const SizedBox(height: 30,),
        CustomButton(text: 'Сохранить', onPress: handleSubmit)
      ],
    );
  }
}
