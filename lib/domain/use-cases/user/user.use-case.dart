import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/Responses/success.dart';
import 'package:lseway/domain/entitites/user/reset_result.dart';
import 'package:lseway/domain/entitites/user/user.entity.dart';
import 'package:lseway/domain/repositories/user/user.repository.dart';

class UserUseCase {
  final UserRepository repository;

  UserUseCase({required this.repository});

  Future<Either<Failure, Success>> register(
      {String? phone,
      String? email,
      required String name,
      required String surname,
      String? password}) {
    return repository.register(
        password: password,
        phone: phone,
        name: name,
        surname: surname,
        email: email,
        );
  }


  Future<User?> checkAuthorization() async {
    return repository.checkAuthorization();
  }

  void logout() {
    return repository.logout();
  }

  Future<Either<Failure, User>> loginWithEmail(String email, String password) {
    return repository.loginWithEmail(email, password);
  }


  void refreshToken() {
    repository.refreshToken();
  }


    Future<Either<Failure, Success>> requestPhoneConfirmation(String phone) {
      return repository.requestPhoneConfirmation(phone);
    }

  Future<Either<Failure, User>> confirmPhone(String phone, String code) {
    return repository.confirmPhone(phone, code);
  }



    Future<Either<Failure, String>> changeName(String name) {
      return repository.changeName(name);
    }


  Future<Either<Failure, String>> changeEmail(String email) {
    return repository.changeEmail(email);
  }

  Future<Either<Failure, String>> confirmEmail(String email, String code) {
    return repository.confirmEmail(email, code);
  }



    Future<Either<Failure, String>> resetAccess({required String email}) {
      return repository.resetAccess(email: email);
    }
  Future<Either<Failure, String>> confirmReset({required String email, required String code}) {
    return repository.confirmReset(email: email, code: code);
  }

  Future<Either<Failure, ResetResult>> setNewPhone({required String email, required String phone}) {
    return repository.setNewPhone(email: email, phone: phone);
  }


  Future<Either<Failure, User>> confirmNewPhone({required String email, required String phone, required String code}) {
    return repository.confirmNewPhone(email: email, phone: phone, code: code);
  }
}
