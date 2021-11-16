import 'package:lseway/domain/entitites/chat/message.entity.dart';

class Manager {
  final int id;
  final String name;
  final String? avatar;
  final bool online;

  Manager({required this.id, required this.name, required this.online, this.avatar});
}

class Chat {
  final Manager manager;
  final List<Message> messages;

  Chat({
    required this.manager,
    required this.messages,
  });


  Chat copyWith({
    Manager? manager,
    List<Message>? messages,
  }) {
    return Chat(
      manager: manager ?? this.manager,
      messages: messages ?? this.messages,
    );
  }

}
