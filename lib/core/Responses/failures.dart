import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  Failure(this.message);

  List<Object> get props => [message];
}

class NetworkFailure extends Failure {
  final String message;

  NetworkFailure(this.message) : super(message);
}

class AuthorizationFailure extends Failure {
  final String message;

  AuthorizationFailure(this.message) : super(message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}
