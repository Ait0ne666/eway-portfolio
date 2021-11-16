import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/domain/entitites/chat/chat_result.entity.dart';
import 'package:lseway/domain/entitites/chat/message.entity.dart';
import 'package:lseway/domain/repositories/chat/chat.repository.dart';

class ChatUseCase {

  final ChatRepository repository;


  ChatUseCase({required this.repository});



    Future<Either<Failure, ChatResult>> getChatInfo() {


      return repository.getChatInfo();
    }


  Future<Either<Failure, Message>> sendMessage(Message message) {
    return repository.sendMessage(message);
  }


  void disconnect() {
    repository.disconnect();
  }


}