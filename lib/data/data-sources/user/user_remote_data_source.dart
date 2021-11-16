import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/Responses/success.dart';
import 'package:lseway/data/models/dto/login_result.dto.dart';
import 'package:lseway/data/models/user/user.model.dart';
import 'package:lseway/domain/entitites/user/reset_result.dart';
import 'package:lseway/domain/entitites/user/user.entity.dart';

class UserRemoteDataSource {
  Dio dio;
  static const String _apiUrl = Config.API_URL;

  UserRemoteDataSource({required this.dio});

  Future<Either<Failure, Success>> register(
      {String? phone,
      String? email,
      required String name,
      required String surname,
      String? password}) async {
    const url = _apiUrl + 'register';

    try {
      var data = {};
      if (email == null || email.isEmpty) {
        data = {
          // "email": email,
          "phone": phone,
          "name": name,
          "surname": surname
        };
      } else {
        data = {
          "email": email,
          // "phone": phone,
          "password": password,
          "name": name,
          "surname": surname
        };
      }

      await dio.post(url, data: data);

      return Right(Success(message: 'registrationSuccess'));
    } on DioError catch (err) {
      print(err.response);
      if (err.response?.statusCode == 400) {
        var message = 'Ошибка регистрации';
        return Left(ServerFailure(message));
      } else if (err.response?.statusCode == 409) {
        if (email != null) {
          var message = 'Пользователь с таким email уже существует';
          return Left(ServerFailure(message));
        } else {
          var message = 'Пользователь с таким номером телефона уже существует';
          return Left(ServerFailure(message));
        }
      }
      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    }
  }

  Future<Either<Failure, LoginResult>> loginWithEmail(
      String email, String password) async {
    const url = _apiUrl + 'auth';

    try {
      var data = {"email": email, "password": password};

      var response = await dio.post(url, data: data);

      var tokens = response.data['result'];
      var accessToken = tokens["access_token"];
      var refreshToken = tokens["refresh_token"];

      return Right(
          LoginResult(accessToken: accessToken, refreshToken: refreshToken));
    } on DioError catch (err) {
      print(err.response);
      if (err.response?.statusCode == 400 || err.response?.statusCode == 401) {
        var message = 'Неверный email или пароль';
        return Left(ServerFailure(message));
      }
      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    }
  }

  Future<Either<Failure, UserModel>> getProfile() async {
    const url = _apiUrl + 'me';

    try {
      var response = await dio.get(url);

      var result = response.data['result'];

      return Right(
        UserModel(
          id: 55555555,
            showWelcome: true,
            email: result["email"],
            name: result["name"],
            phone: result["phone"] ?? '79859153858',
            email_confirmed: result["email_confirmed"] ?? false,
            avatarUrl: result["avatar"],
            aggreedToNews: result["aggree"] ?? true),
      );
    } on DioError catch (err) {
      print(err.response);

      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    }
  }

  Future<Either<Failure, LoginResult>> refreshToken(
      String jwt, String refresh) async {
    var url = _apiUrl + 'refresh';

    try {
      dio.interceptors.requestLock.lock();
      var refreshDio = Dio();
      var response = await refreshDio.post(url,
          data: {"refresh_token": refresh},
          options: Options(headers: {"Authorization": "Bearer " + jwt}));
      var data = response.data;
      var access = data["result"]["access_token"];
      var refr = data["result"]["refresh_token"];
      dio.interceptors.requestLock.unlock();
      return Right(LoginResult(accessToken: access, refreshToken: refr));
    } catch (err) {
      dio.interceptors.requestLock.unlock();
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, Success>> requestPhoneConfirmation(
      String phone) async {
    const url = _apiUrl + 'auth';

    try {
      var data = {"phone": phone};

      await dio.post(url, data: data);

      return Right(Success(message: phone));
    } on DioError catch (err) {
      if (err.response?.statusCode == 400) {
        var errors = err.response!.data['errors'];
        if (errors != null) {
          var err = errors[0];

          if (err['message'] == 'Invalid phone number') {
            return registerWithPhone(phone);
          }
        }
      }

      if (err.response?.statusCode == 400 || err.response?.statusCode == 401) {
        var message = 'Пользователь с таким номером телефона не найден';
        return Left(ServerFailure(message));
      }
      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    }
  }

  Future<Either<Failure, Success>> registerWithPhone(String phone) async {
    const url = _apiUrl + 'register';

    var data = {"phone": phone};

    try {
      var response = dio.post(url, data: data);

      return Right(Success(message: phone));
    } catch (err) {
      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    }
  }

  Future<Either<Failure, LoginResult>> confirmPhone(
      String phone, String code) async {
    const url = _apiUrl + 'confirm';

    try {
      var data = {"phone": phone, "code": code};

      var response = await dio.post(url, data: data);

      var tokens = response.data['result'];
      var accessToken = tokens["access_token"];
      var refreshToken = tokens["refresh_token"];

      return Right(
          LoginResult(accessToken: accessToken, refreshToken: refreshToken));
    } on DioError catch (err) {
      if (err.response?.statusCode == 400 || err.response?.statusCode == 401) {
        var message = 'Неверный код';
        return Left(ServerFailure(message));
      }
      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    }
  }

  Future<Either<Failure, String>> changeName(String name) async {
    const url = _apiUrl + 'me';

    var data = {"name": name};

    try {
      var response = await dio.post(url, data: data);

      return Right(name);
    } catch (err) {
      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    }
  }

  Future<Either<Failure, String>> changeEmail(String email, bool aggree) async {
    const url = _apiUrl + 'me';

    var data = {"email": email};

    try {
      var response = await dio.post(url, data: data);

      return Right(email);
    } on DioError catch (err) {
      if (err.response?.statusCode == 400 || err.response?.statusCode == 401) {
        var message = 'Пользователь с таким email уже существует';
        return Left(ServerFailure(message));
      }
      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    }
  }

  Future<Either<Failure, String>> confirmEmail(
      String email, String code) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return Left(ServerFailure('Произошла непредвиденная ошибка'));
  }

  Future<Either<Failure, String>> resetAccess(String email) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return Right(email);
  }

  Future<Either<Failure, String>> confirmReset(
      String email, String code) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return Right(email);
  }

  Future<Either<Failure, ResetResult>> setNewPhone(
      String email, String phone) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return Right(ResetResult(email: email, phone: phone));
  }

  Future<Either<Failure, LoginResult>> confirmNewPhone(
      String email, String phone, String code) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return Right(
        LoginResult(accessToken: 'asdasdasdas', refreshToken: 'ffsdsdsf'));
  }


  Future<Either<Failure, String>> saveDeviceToken(String token) async {
    const url = _apiUrl + 'me';

    var data = {"device_token": token};

    try {
      var response = await dio.post(url, data: data);

      return Right(token);
    } catch (err) {
      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    }
  }


  Future<Either<Failure, Success>> deleteDeviceToken() async {
    const url = _apiUrl + 'me';

    var data = {"device_token": ""};

    try {
      var response = await dio.post(url, data: data);

      return Right(Success());
    } catch (err) {
      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    }
  }
}
