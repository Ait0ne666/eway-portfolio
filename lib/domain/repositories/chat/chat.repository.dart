import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/domain/entitites/chat/chat.entity.dart';
import 'package:lseway/domain/entitites/chat/chat_result.entity.dart';
import 'package:lseway/domain/entitites/chat/message.entity.dart';

abstract class ChatRepository {


  Future<Either<Failure, ChatResult>> getChatInfo();


  Future<Either<Failure, Message>> sendMessage(Message message);


  void disconnect();

}