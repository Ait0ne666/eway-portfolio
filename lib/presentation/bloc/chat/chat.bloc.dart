import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/domain/entitites/chat/chat.entity.dart';
import 'package:lseway/domain/entitites/chat/message.entity.dart';
import 'package:lseway/domain/use-cases/chat/chat.use_case.dart';
import 'package:lseway/presentation/bloc/chat/chat.event.dart';
import 'package:lseway/presentation/bloc/chat/chat.state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatUseCase usecase;

  Chat? chat;
  StreamSubscription<Message>? subscription;

  ChatBloc({required this.usecase}) : super(const ChatInitialState()) {
    on<LoadChat>((event, emit) async {
      if (chat == null) {
        emit(ChatLoadingState(chat: chat));
      }
      var result = await usecase.getChatInfo();

      result.fold((failure) {
        emit(ChatErrorState(chat: chat, message: failure.message));
      }, (chatResult) {
        chat = chatResult.chat;
        emit(ChatLoadedState(chat: chat!));

        subscription = chatResult.messageStream.listen((event) {
          add(AddMessage(message: event));
        });
      });
    });
    on<AddMessage>((event, emit) {
      var messages = [...chat!.messages];

      messages.removeWhere((element) => element.id == event.message.id);

      messages.add(event.message);

      chat = chat!.copyWith(messages: messages);

      emit(ChatLoadedState(chat: chat!));
    });
    on<CloseChat>((event, emit) {
      subscription?.cancel();
      subscription = null;

      usecase.disconnect();
    });
    on<SendMessage>((event, emit) async {
      var messages = [...chat!.messages];

      messages.add(event.message);

      chat = chat!.copyWith(messages: messages);

      emit(ChatLoadedState(chat: chat!));

      var result = await usecase.sendMessage(event.message);

      result.fold((failure) {
        emit(ChatMessageSendErrorState(
            chat: chat, message: failure.message, messageId: event.message.id));
      }, (message) {
        var messages = [...chat!.messages];

        messages.removeWhere((element) {
          if (element.senderId == message.senderId && element.text == message.text && element.status == MessageStatus.NOT_SENT) return true;
          return false;
        });

        messages.add(message);

        chat = chat!.copyWith(messages: messages);

        emit(ChatLoadedState(chat: chat!));
      });
    });
  }
}
