import 'package:lseway/domain/entitites/chat/chat.entity.dart';
import 'package:lseway/domain/entitites/chat/message.entity.dart';

class ChatResult {
  final Chat chat;
  final Stream<Message> messageStream;

  ChatResult({required this.chat, required this.messageStream});
}
