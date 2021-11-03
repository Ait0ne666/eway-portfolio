import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';
import 'package:lseway/presentation/navigation/main_router.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/Core/CustomInput/custom_input.dart';
import 'package:lseway/utils/utils.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SetNewPhone extends StatefulWidget {
  final String email;
  const SetNewPhone({Key? key, required this.email}) : super(key: key);

  @override
  _SetNewPhoneState createState() => _SetNewPhoneState();
}

class _SetNewPhoneState extends State<SetNewPhone> {
  
  final TextEditingController _phoneController = TextEditingController();
    final formatter = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});

  final GlobalKey<CustomInputState> _phoneKey =
      GlobalKey<CustomInputState>();
  

  @override
  void initState() {
    super.initState();
    _phoneController.value = const TextEditingValue(text: '+7');

    _phoneController.addListener(() {
      if (_phoneController.value.text.length<2) {
        _phoneController.value = const TextEditingValue(text: '+7');
      }
    });
  }


  @override
  void dispose() {
    _phoneController.dispose();

  

    super.dispose();
  }

  void onSubmit() {
    

    var phoneError = _phoneKey.currentState?.handleValidation();
    if (phoneError == null ) {
      var phone = '7' + formatter.getUnmaskedText();

      

      BlocProvider.of<UserBloc>(context)
          .add(SetNewPhoneEvent(phone:  phone, email: widget.email,));
    }
  }

  void authListener(BuildContext context, UserState state) {
    setupBlocListener<UserState, UserLoadingState, ResetSetnewPhoneErrorState,
            ResetSetnewPhoneSuccessState>(context, state,
        (ResetSetnewPhoneSuccessState state) {
      MainRouter.router.navigateTo(context, '/reset/phone/confirm',
          routeSettings:
              RouteSettings(arguments: PhoneParams(email: state.email, phone: state.phone)),
          transition: TransitionType.cupertino);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        BlocListener<UserBloc, UserState>(listener: authListener, child: const SizedBox(),),
        Text(
          'Вход',
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(
          height: 36,
        ),

        const Text(
          'Укажите новый номер телефона',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff1A1D21),
            fontSize: 15,
            fontFamily: 'Circe',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 13,
        ),
        CustomInput(
          type: CustomInputTypes.PHONE,

          controller: _phoneController,
          maskFormatter: formatter,
          required: true,
          key: _phoneKey,
        ),
        const SizedBox(
          height: 35,
        ),
        CustomButton(text: 'Войти', onPress: onSubmit)
      ]),
    );
  }
}
