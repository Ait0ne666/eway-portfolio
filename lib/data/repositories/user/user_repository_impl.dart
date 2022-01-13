import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/Responses/success.dart';
import 'package:lseway/core/network/network_info.dart';
import 'package:lseway/data/adapters/user/user.adapter.dart';
import 'package:lseway/data/data-sources/charge/charge.remote_data_source.dart';
import 'package:lseway/data/data-sources/user/user_local_data_source.dart';
import 'package:lseway/data/data-sources/user/user_remote_data_source.dart';
import 'package:lseway/domain/entitites/user/reset_result.dart';
import 'package:lseway/domain/entitites/user/user.entity.dart';
import 'package:lseway/domain/repositories/user/user.repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;
  final UserRemoteDataSource remoteDataSource;
  final ChargeRemoteDataSource chargeRemoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.chargeRemoteDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, Success>> register(
      {String? phone,
      String? email,
      required String name,
      required String surname,
      String? password}) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    var result = await remoteDataSource.register(
        password: password,
        phone: phone,
        name: name,
        surname: surname,
        email: email);
    return result;
  }

  @override
  Future<User?> checkAuthorization() async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      var model = localDataSource.getUserModel();
      if (model != null) {
        return mapModelToUser(model);
      }
      return null;
    }

    var jwt = localDataSource.getJwt();
    var refresh = localDataSource.getRefresh();

    var profileResult = await remoteDataSource.getProfile();

    return profileResult.fold((l) {
      return null;
    }, (model) {
      localDataSource.saveUserModel(model);
      saveDeviceToken();
      return mapModelToUser(model);
    });
  }

  @override
  void logout() async {
    try {
      await deleteDeviceToken();
    } catch (err) {}
    chargeRemoteDataSource.stopChargeListener();
    localDataSource.deleteJwt();
    localDataSource.deleteRefresh();
    localDataSource.deleteFilter();
    localDataSource.deleteEmailConfrimationShown();
  }

  @override
  Future<Either<Failure, User>> loginWithEmail(
      String email, String password) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    var loginResult = await remoteDataSource.loginWithEmail(email, password);

    return loginResult.fold((failure) {
      return Left(failure);
    }, (result) async {
      localDataSource.saveJwt(result.accessToken);
      localDataSource.saveRefresh(result.refreshToken);
      
      var profileResult = await remoteDataSource.getProfile();

      return profileResult.fold((l) {
        return Left(l);
      }, (model) {
        localDataSource.saveUserModel(model);
        saveDeviceToken();
        return Right(mapModelToUser(model));
      });
    });
  }

  @override
  void refreshToken() async {
    var jwt = localDataSource.getJwt();
    var refresh = localDataSource.getRefresh();

    if (jwt != null && refresh != null) {
      var result = await remoteDataSource.refreshToken(jwt, refresh);

      result.fold((l) {}, (r) {
        localDataSource.saveJwt(r.accessToken);
        localDataSource.saveRefresh(r.refreshToken);
      });
    }
  }

  @override
  Future<Either<Failure, Success>> requestPhoneConfirmation(
      String phone) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    return remoteDataSource.requestPhoneConfirmation(phone);
  }

  Future<Either<Failure, User>> confirmPhone(String phone, String code) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    var loginResult = await remoteDataSource.confirmPhone(phone, code);

    return loginResult.fold((failure) {
      return Left(failure);
    }, (result) async {
      localDataSource.saveJwt(result.accessToken);
      localDataSource.saveRefresh(result.refreshToken);
      
      var profileResult = await remoteDataSource.getProfile();

      return profileResult.fold((l) {
        return Left(l);
      }, (model) {
        localDataSource.saveUserModel(model);
        saveDeviceToken();
        return Right(mapModelToUser(model));
      });
    });
  }

  Future<Either<Failure, String>> changeName(String name) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    var result = await remoteDataSource.changeName(name);

    return result.fold((failure) {
      return Left(failure);
    }, (success) {
      var model = localDataSource.getUserModel();

      if (model != null) {
        var newModel = model.copyWith(name: success);

        localDataSource.saveUserModel(newModel);
      }

      return Right(name);
    });
  }

  Future<Either<Failure, String>> changeEmail(String email, bool aggree) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    var result = await remoteDataSource.changeEmail(email, aggree);

    return result.fold((failure) {
      return Left(failure);
    }, (success) {
      var model = localDataSource.getUserModel();

      if (model != null) {
        var newModel = model.copyWith(email: success, email_confirmed: false);

        localDataSource.saveUserModel(newModel);
      }

      return Right(email);
    });
  }

  Future<Either<Failure, String>> confirmEmail(
      String email, String code) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    return remoteDataSource.confirmEmail(email, code);
  }

  @override
  Future<Either<Failure, String>> resetAccess({required String email}) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    return remoteDataSource.resetAccess(email);
  }

  @override
  Future<Either<Failure, String>> confirmReset(
      {required String email, required String code}) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    return remoteDataSource.confirmReset(email, code);
  }

  @override
  Future<Either<Failure, ResetResult>> setNewPhone(
      {required String email, required String phone}) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    return remoteDataSource.setNewPhone(email, phone);
  }

  @override
  Future<Either<Failure, User>> confirmNewPhone(
      {required String email,
      required String phone,
      required String code}) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    var loginResult = await remoteDataSource.confirmPhone(phone, code);

    return loginResult.fold((failure) {
      return Left(failure);
    }, (result) async {
      localDataSource.saveJwt(result.accessToken);
      localDataSource.saveRefresh(result.refreshToken);
      
      var profileResult = await remoteDataSource.getProfile();

      return profileResult.fold((l) {
        return Left(l);
      }, (model) {
        localDataSource.saveUserModel(model);
        saveDeviceToken();
        return Right(mapModelToUser(model));
      });
    });
  }

  // Future<Either<Failure, String>> confirmReset({String email, String code});
  // Future<Either<Failure, ResetResult>> setNewPhone({String email, String phone});
  // Future<Either<Failure, User>> confirmNewPhone({String email, String phone, String code});

  Future<void> saveDeviceToken() async {
    var deviceToken = localDataSource.getDeviceToken();
    if (deviceToken != null) {
      remoteDataSource.saveDeviceToken(deviceToken);
    }
  }

  Future<void> deleteDeviceToken() async {
    localDataSource.deleteDeviceToken();
    await remoteDataSource.deleteDeviceToken();
  }

  @override
  Future<Either<Failure, String>> uploadFile(String filePath) async {
    return remoteDataSource.uploadFile(filePath);
  }

  @override
  Future<Either<Failure, bool>> toggleEndAt80(bool endAt80, String phone) {
    localDataSource.save80PercentShown(phone);

    return remoteDataSource.toggleEndAt80(endAt80);
  }

  @override
  bool stopChargeAt80DialogShown(String phone) {
    var shown = localDataSource.get80PercentShown(phone);
    if (shown !=true) {
      localDataSource.save80PercentShown(phone);
    }
    return shown?? false;
    // return false;
  }
}
