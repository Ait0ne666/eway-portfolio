import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/Responses/success.dart';
import 'package:lseway/domain/entitites/user/reset_result.dart';
import 'package:lseway/domain/entitites/user/user.entity.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> loginWithEmail(String email, String password);
  Future<Either<Failure, Success>> requestPhoneConfirmation(String phone);

  Future<Either<Failure, User>> confirmPhone(String phone, String code);

  Future<Either<Failure, String>> changeName(String name);

  Future<Either<Failure, String>> changeEmail(String email, bool aggree);

  Future<Either<Failure, String>> confirmEmail(String email, String code);

  Future<Either<Failure, String>> uploadFile(String filePath);
  Future<Either<Failure, bool>> toggleEndAt80(bool endAt80, String phone);

  bool stopChargeAt80DialogShown(String phone);

  void logout();

  Future<Either<Failure, String>> resetAccess({required String email});
  Future<Either<Failure, String>> confirmReset(
      {required String email, required String code});
  Future<Either<Failure, ResetResult>> setNewPhone(
      {required String email, required String phone});
  Future<Either<Failure, User>> confirmNewPhone(
      {required String email, required String phone, required String code});

  Future<Either<Failure, Success>> register(
      {String? phone,
      String? email,
      required String name,
      required String surname,
      String? password});

  Future<User?> checkAuthorization();

  void refreshToken();
}
