import 'package:fluro/fluro.dart';
import 'package:lseway/presentation/screens/ConfirmScreen/confirm_screen.dart';
import 'package:lseway/presentation/screens/LoginScreen/login_screen.dart';
import 'package:lseway/presentation/screens/MainScreen/main_screen.dart';
import 'package:lseway/presentation/screens/RegistrationScreen/registration_screen.dart';
import 'package:lseway/presentation/screens/ResetAccess/ConfirmNewPhoneScreen/confirm_new_phone_screen.dart';
import 'package:lseway/presentation/screens/ResetAccess/ConfirmResetEmailScreen/confirm_reset_email_screen.dart';
import 'package:lseway/presentation/screens/ResetAccess/ResetAccessScreen/reset_access_screen.dart';
import 'package:lseway/presentation/screens/ResetAccess/SetNewPhoneScreen/set_new_phone_screen.dart';
import 'package:lseway/presentation/screens/WelcomeScreen/welcome_screen.dart';

class ConfirmationParams {
  
  final String phone;

  ConfirmationParams({ required this.phone});
}


class EmailParams {
  
  final String email;

  EmailParams({ required this.email});
}


class PhoneParams {
  
  final String email;
  final String phone;

  PhoneParams({ required this.email, required this.phone});
}

class MainRouter {
  static FluroRouter router = FluroRouter();

  static final Handler _mainHandler =
      Handler(handlerFunc: (context, pwarameters) => MainScreen());

  static final Handler _welcomeHandler =
      Handler(handlerFunc: (context, parameters) => const WelcomeScreen());

  static final Handler _authHandler =
    Handler(handlerFunc: (context, parameters) => const LoginScreen());

  static final Handler _registrationHandler =
    Handler(handlerFunc: (context, parameters) => const RegistrationScreen());

  static final Handler _loginConfirmationHandler = Handler(handlerFunc: (context, params) {
    var params = context!.settings!.arguments as ConfirmationParams;

    return ConfirmScreen(phone: params.phone);
  });

  static final Handler _resetAccessHandler =
    Handler(handlerFunc: (context, parameters) => const ResetAccessScreen());


  static final Handler _resetEmailConfirmHandler = Handler(handlerFunc: (context, params) {
    var params = context!.settings!.arguments as EmailParams;

    return ConfirmResetEmailScreen(email: params.email);
  });

    static final Handler _resetSetNewPhoneHandler = Handler(handlerFunc: (context, params) {
    var params = context!.settings!.arguments as EmailParams;

    return SetNewPhoneScreen(email: params.email);
  });


      static final Handler _confirmNewPhoneHandler = Handler(handlerFunc: (context, params) {
    var params = context!.settings!.arguments as PhoneParams;

    return ConfirmNewPhoneScreen(email: params.email, phone: params.phone,);
  });

  static void setupRouter() {
    router.define('/main', handler: _mainHandler);
    router.define('/welcome', handler: _welcomeHandler);
    router.define('/login', handler: _authHandler);
    router.define('/confirm', handler: _loginConfirmationHandler);
    router.define('/register', handler: _registrationHandler);
    router.define('/reset', handler: _resetAccessHandler);
    router.define('/reset/confirm', handler: _resetEmailConfirmHandler);
    router.define('/reset/phone', handler: _resetSetNewPhoneHandler);
    router.define('/reset/phone/confirm', handler: _confirmNewPhoneHandler);

  }
}
