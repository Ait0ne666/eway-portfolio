import 'dart:async';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/domain/entitites/chat/chat.entity.dart';
import 'package:lseway/domain/entitites/chat/chat_result.entity.dart';
import 'package:lseway/domain/entitites/chat/message.entity.dart';

class ChatRemoteDataSource {
  final Dio dio;

  static const String _apiUrl = Config.API_URL;

  ChatRemoteDataSource({required this.dio});

  StreamController<Message>? chatController;
  Timer? timer;

  Future<Either<Failure, ChatResult>> getChatInfo() async {
    await Future.delayed(const Duration(milliseconds: 200));

    chatController = StreamController<Message>();

    var messageStream = chatController!.stream;

    Future.delayed(Duration(seconds: 5), () {
      chatController?.add(
        Message(
          createdAt: DateTime.now(),
          status: MessageStatus.DELIVERED,
          senderId: 5,
          text: 'new message',
          id: 2,
        ),
      );
    });

    return Right(
      ChatResult(
        chat: Chat(
            manager: Manager(id: 5, name: 'Василий', online: false),
            messages: [
              Message(
                createdAt: DateTime.now().subtract(const Duration(days: 1)),
                status: MessageStatus.DELIVERED,
                senderId: 5,
                text: 'Temporary text',
                id: 1,
              ),
            ]),
        messageStream: messageStream,
      ),
    );
  }

  Future<Either<Failure, Message>> sendMessage(Message message) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return Right(message.copyWith(
        status: MessageStatus.DELIVERED, id: Random().nextInt(10000)));
  }

  void disconnect() {
    chatController?.close();
    chatController = null;
  }
}
