enum MessageStatus { DELIVERED, SENT, NOT_SENT }

class Message {
  final int? id;
  final String text;
  final DateTime createdAt;
  final int senderId;
  final MessageStatus? status;

  Message(
      {this.id,
      required this.createdAt,
      required this.text,
      required this.senderId,
      this.status});



  Message copyWith({
      int? id,
  String? text,
  DateTime? createdAt,
  int? senderId,
  MessageStatus? status,
  }) {
    return Message(
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      text: text ?? this.text,
      senderId: senderId ?? this.senderId,
      status: status ?? this.status,
    );
  }
}
