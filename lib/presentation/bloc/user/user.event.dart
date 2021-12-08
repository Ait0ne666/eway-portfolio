import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/user/user.entity.dart';

class UserEvent{
  @override
  List<Object> get props => [];
}

class CheckAuth extends UserEvent {}

class RegisterUser extends UserEvent {
  final String? phone;
  final String? password;
  final String name;
  final String? email;
  final String surname;

  RegisterUser(
      {this.password,
      this.phone,
      required this.name,
      required this.surname,
      this.email});

  @override
  List<Object> get props => [name, surname];
}

class LoginUserWithEmail extends UserEvent {
  final String email;
  final String password;

  LoginUserWithEmail({required this.email, required this.password});
}

class Logout extends UserEvent {
  Logout();
}

class RefreshToken extends UserEvent {}

class RequestPhoneConfirmation extends UserEvent {
  final String phone;

  RequestPhoneConfirmation({required this.phone});
}

class ConfirmPhone extends UserEvent {
  final String phone;
  final String code;

  ConfirmPhone({required this.phone, required this.code});
}

class Toggle80Percent extends UserEvent {
  final String phone;
  final bool aggree;

  Toggle80Percent({required this.phone, required this.aggree});

  @override
  List<Object> get props => [phone, aggree];
}

class ChangeEmail extends UserEvent {
  final String email;
  final bool aggree;

  ChangeEmail({required this.email, required this.aggree});

  @override
  List<Object> get props => [email];
}

class ChangeName extends UserEvent {
  final String name;

  ChangeName({required this.name});

  @override
  List<Object> get props => [name];
}

class ConfirmEmail extends UserEvent {
  final String email;
  final String code;

  ConfirmEmail({required this.email, required this.code});

  @override
  List<Object> get props => [email, code];
}

class ApplyForResetWithEmail extends UserEvent {
  final String email;

  ApplyForResetWithEmail({required this.email});

  @override
  List<Object> get props => [email];
}

class ConfirmResetEmail extends UserEvent {
  final String email;
  final String code;

  ConfirmResetEmail({required this.email, required this.code});

  @override
  List<Object> get props => [email, code];
}

class SetNewPhoneEvent extends UserEvent {
  final String email;
  final String phone;

  SetNewPhoneEvent({required this.email, required this.phone});

  @override
  List<Object> get props => [email, phone];
}

class ConfirmNewPhoneEvent extends UserEvent {
  final String email;
  final String phone;
  final String code;

  ConfirmNewPhoneEvent(
      {required this.email, required this.phone, required this.code});

  @override
  List<Object> get props => [email, phone, code];
}

class UploadFile extends UserEvent {
  final String filePath;

  UploadFile({required this.filePath});
}
