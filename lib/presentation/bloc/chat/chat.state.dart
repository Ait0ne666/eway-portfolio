import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/chat/chat.entity.dart';

class ChatState extends Equatable {

  final Chat? chat;


  const ChatState({required this.chat});

  @override
  List<Object?> get props => [chat];
}



class ChatInitialState extends ChatState {


  const ChatInitialState():super(chat: null);


}



class ChatLoadedState extends ChatState {
  const ChatLoadedState({required Chat chat}):super(chat: chat);
}

class ChatErrorState extends ChatState {
  final String message;
  const ChatErrorState({required Chat? chat, required this.message}):super(chat: chat);
}

class ChatLoadingState extends ChatState {
  const ChatLoadingState({required Chat? chat}):super(chat: chat);
}



class ChatMessageSendErrorState extends ChatState {
  final String message;
  final int? messageId;
  const ChatMessageSendErrorState({required Chat? chat, required this.message, required this.messageId}):super(chat: chat);
}



