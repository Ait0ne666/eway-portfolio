class ServerException implements Exception {
  final String message;

  ServerException(this.message);
}

class FormatException implements Exception {}

class CacheException implements Exception {}
