import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/core/network/retry_interceptor.dart';
import 'package:lseway/data/data-sources/user/user_local_data_source.dart';
import 'package:corsac_jwt/corsac_jwt.dart';

String decodeBase64(String toDecode) {
  String res;
  try {
    while (toDecode.length * 6 % 8 != 0) {
      toDecode += "=";
    }
    res = utf8.decode(base64.decode(toDecode));
  } catch (error) {
    throw Exception("decodeBase64([toDecode=$toDecode]) \n\t\terror: $error");
  }
  return res;
}

bool isExpired(String token) {
  try {
    final decoded = json.decode(decodeBase64(token.split(".")[0]));

    var exp = decoded['exp'];
    var expDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);

    var currentTime = DateTime.now().toUtc();

    if (expDate.isBefore(currentTime.subtract(const Duration(minutes: 30)))) {
      return true;
    }

    return false;
  } catch (err) {
    return false;
  }

  
}

Dio initDioClient() {
  var tokenDio = Dio();

  var localDataSource = UserLocalDataSource();
  var apiUrl = Config.API_URL;
  var dio = Dio();

  var tokenInterceptor =
      InterceptorsWrapper(onRequest: (options, handler) async {
    var jwt = localDataSource.getJwt();
    if (jwt == null) {
      handler.next(options);
    } else {
      if (isExpired(jwt)) {
        var refresh = localDataSource.getRefresh();

        if (refresh == null) {
          handler.next(options);
        } else {
          var url = apiUrl + 'refresh';

          dio.interceptors.requestLock.lock();

          tokenDio.post(url, data: {"refresh_token": refresh}, options: Options(
            headers: {
              "Authorization": "Bearer " + jwt
            }
          )).then((response) {
            var data = response.data;
            var access = data["result"]["access_token"];
            var refresh = data["result"]["refresh_token"];

            localDataSource.saveJwt(access);
            localDataSource.saveRefresh(refresh);
            options.headers['Authorization'] = 'Bearer ' + access;
            handler.next(options);
          }).catchError((err) {
            handler.next(options);
          }).whenComplete(() => dio.interceptors.requestLock.unlock());
        }
      } else {
        options.headers['Authorization'] = 'Bearer ' + jwt;
        handler.next(options);
      }
    }
  });

  dio.interceptors.add(RetryInterceptor());
  dio.interceptors.add(tokenInterceptor);

  return dio;
}
