import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/user/user.entity.dart';



class UserState extends Equatable {

  final User? user;


  const UserState({required this.user});


  @override
  List<Object?> get props => [user];

}




class UserInitialState extends UserState {

  
  const UserInitialState(): super(user: null);

}


class UserUnauthorizedState extends UserState {
  const UserUnauthorizedState(): super(user: null);
}



class UserAuthorizedState extends UserState {
  final User? user;


  const UserAuthorizedState({required this.user}): super(user: user);
}


class UserLoadingState extends UserState {
  final User? user;


  const UserLoadingState({required this.user}): super(user: user);
}


class UserConfirmingState extends UserState {
  final User? user;


  const UserConfirmingState({required this.user}): super(user: user);
}


class UserErrorState extends UserState {
  final User? user;
  final String message;

  const UserErrorState({required this.user, required this.message}): super(user: user);
}



class UserRegisterSuccess extends UserState {


  const UserRegisterSuccess(): super(user: null);
}

class UserRegisterErrorState extends UserErrorState {
  // final User? user;
  // final String message;

  const UserRegisterErrorState({User? user, required String message}): super(user: user, message: message);
}


class UserLoginWithEmailErrorState extends UserErrorState {
  // final User? user;
  // final String message;

  const UserLoginWithEmailErrorState({User? user, required String message}): super(user: user, message: message);
}



class UserConfirmationCodeSentState extends UserState {
  final String phone;
  const UserConfirmationCodeSentState({required this.phone}): super(user: null);
}


class UserConfirmationCodeSentErrorState extends UserErrorState {
  // final User? user;
  // final String message;

  const UserConfirmationCodeSentErrorState({User? user, required String message}): super(user: user, message: message);
}


class UserCodeConfirmationErrorState extends UserErrorState {
  // final User? user;
  // final String message;

  const UserCodeConfirmationErrorState({User? user, required String message}): super(user: user, message: message);
}


class UserChangingState extends UserState {
  final User? user;


  const UserChangingState({required this.user}): super(user: user);
}



class UserChangedState extends UserState {
  final User? user;


  const UserChangedState({required this.user}): super(user: user);
}



class UserChangeErrorState extends UserErrorState {


  const UserChangeErrorState({User? user, required String message}): super(user: user, message: message);
}





class ResetSendEmailSuccessState extends UserState {
  final String email;


  const ResetSendEmailSuccessState({required this.email, required User? user}): super(user: user);
}


class ResetSendEmailErrorState extends UserErrorState {
  


  const ResetSendEmailErrorState({required String message, required User? user}): super(user: user, message: message);
}

class ResetConfrimEmailSuccessState extends UserState {
  final String email;


  const ResetConfrimEmailSuccessState({required this.email, required User? user}): super(user: user);
}

class ResetConfirmEmailErrorState extends UserErrorState {
 


  const ResetConfirmEmailErrorState({required String message, required User? user}): super(user: user, message: message);
}



class ResetSetnewPhoneSuccessState extends UserState {
  final String email;
  final String phone;


  const ResetSetnewPhoneSuccessState({required this.phone, required this.email, required User? user}): super(user: user);
}


class ResetSetnewPhoneErrorState extends UserErrorState {
  


  const ResetSetnewPhoneErrorState({required String message, required User? user}): super(user: user, message: message);
}



class ResetConfirmNewPhoneErrorState extends UserErrorState {
  


  const ResetConfirmNewPhoneErrorState({required String message, required User? user}): super(user: user, message: message);
}



class AvatarUploadingUserState extends UserState {
  const AvatarUploadingUserState({required User? user}): super(user: user);
}


class AvatarUploadedUserState extends UserState {
  const AvatarUploadedUserState({required User? user}): super(user: user);
}


class AvatarUploadError extends UserState {
  final String message;


  const AvatarUploadError({required this.message, required User? user}): super(user: user);
}





class Toggle80ErrorState extends UserState {
  final User? user;
  final String message;

  const Toggle80ErrorState({required this.user, required this.message}): super(user: user);
}


class Toggle80SuccessUserState extends UserState {
  const Toggle80SuccessUserState({required User? user}): super(user: user);
}