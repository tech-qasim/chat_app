import 'dart:convert';

class ChatUser {
  String id;
  String username;
  String email;
  ChatUser({required this.id, required this.username, required this.email});

  ChatUser copyWith({String? id, String? username, String? email}) {
    return ChatUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'username': username});
    result.addAll({'email': email});

    return result;
  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUser.fromJson(String source) =>
      ChatUser.fromMap(json.decode(source));

  @override
  String toString() => 'ChatUser(id: $id, username: $username, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatUser &&
        other.id == id &&
        other.username == username &&
        other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ username.hashCode ^ email.hashCode;
}
