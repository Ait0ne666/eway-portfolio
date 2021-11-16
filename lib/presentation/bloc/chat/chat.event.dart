import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/chat/message.entity.dart';

class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadChat extends ChatEvent {}

class SendMessage extends ChatEvent {
  final Message message;

  SendMessage({required this.message});
}

class AddMessage extends ChatEvent {
  final Message message;

  AddMessage({required this.message});
}



class CloseChat extends ChatEvent {
  
}