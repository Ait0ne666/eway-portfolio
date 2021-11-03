import 'dart:io';

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {


  RequestRetrier retrier = RequestRetrier(dio: Dio());


  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {

    if (_shouldRetry(err)) {


      try {
        await Future.delayed(Duration(milliseconds: 5000));
        var response = await retrier.scheduleRequestRetry(err.requestOptions);
        return handler.resolve(response);
      
      } catch (e) {
      
        return super.onError(err, handler);
      }

    }

    return super.onError(err, handler);
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType.other &&
        err.error != null &&
        err.error is SocketException;
  }
}

class RequestRetrier {
  final Dio dio;

  RequestRetrier({required this.dio});

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    return dio.request(requestOptions.path,
          cancelToken: requestOptions.cancelToken,
          data: requestOptions.data,
          onReceiveProgress: requestOptions.onReceiveProgress,
          onSendProgress: requestOptions.onSendProgress,
          queryParameters: requestOptions.queryParameters,
          options: Options(
            headers: requestOptions.headers,
            method: requestOptions.method
          ));
  }
}
