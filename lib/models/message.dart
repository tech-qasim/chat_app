import 'dart:convert';

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.isRead = false,
  });

  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    bool? isRead,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'senderId': senderId});
    result.addAll({'receiverId': receiverId});
    result.addAll({'content': content});
    result.addAll({'isRead': isRead});

    return result;
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      content: map['content'] ?? '',
      isRead: map['isRead'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(id: $id, senderId: $senderId, receiverId: $receiverId, content: $content, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.id == id &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.content == content &&
        other.isRead == isRead;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode ^
        content.hashCode ^
        isRead.hashCode;
  }
}
