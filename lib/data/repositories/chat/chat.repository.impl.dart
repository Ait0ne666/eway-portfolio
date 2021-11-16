import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/network/network_info.dart';
import 'package:lseway/data/data-sources/chat/chat.remote_data_source.dart';
import 'package:lseway/domain/entitites/chat/chat_result.entity.dart';
import 'package:lseway/domain/entitites/chat/message.entity.dart';
import 'package:lseway/domain/repositories/chat/chat.repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl(
      {required this.networkInfo, required this.remoteDataSource});

  @override
  Future<Either<Failure, ChatResult>> getChatInfo() async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }


    return remoteDataSource.getChatInfo();
  }

  @override
  Future<Either<Failure, Message>> sendMessage(Message message) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }


    return remoteDataSource.sendMessage(message);



  }

  @override
  void disconnect() {
    remoteDataSource.disconnect();
  }
}
