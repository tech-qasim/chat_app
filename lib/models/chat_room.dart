import 'dart:convert';

class ChatRoom {
  String chatRoom;
  String senderId;
  String receiverId;
  ChatRoom({
    required this.chatRoom,
    required this.senderId,
    required this.receiverId,
  });

  ChatRoom copyWith({String? chatRoom, String? senderId, String? receiverId}) {
    return ChatRoom(
      chatRoom: chatRoom ?? this.chatRoom,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'chatRoom': chatRoom});
    result.addAll({'senderId': senderId});
    result.addAll({'receiverId': receiverId});

    return result;
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      chatRoom: map['chatRoom'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoom.fromJson(String source) =>
      ChatRoom.fromMap(json.decode(source));

  @override
  String toString() =>
      'ChatRoom(chatRoom: $chatRoom, senderId: $senderId, receiverId: $receiverId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatRoom &&
        other.chatRoom == chatRoom &&
        other.senderId == senderId &&
        other.receiverId == receiverId;
  }

  @override
  int get hashCode =>
      chatRoom.hashCode ^ senderId.hashCode ^ receiverId.hashCode;
}
