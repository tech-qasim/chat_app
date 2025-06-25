import 'dart:convert';

class Contact {
  String id;
  String ownerId;
  String contactUserId;

  Contact({
    required this.id,
    required this.ownerId,
    required this.contactUserId,
  });

  Contact copyWith({String? id, String? ownerId, String? contactUserId}) {
    return Contact(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      contactUserId: contactUserId ?? this.contactUserId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'ownerId': ownerId});
    result.addAll({'contactUserId': contactUserId});

    return result;
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      contactUserId: map['contactUserId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) =>
      Contact.fromMap(json.decode(source));

  @override
  String toString() =>
      'Contact(id: $id, ownerId: $ownerId, contactUserId: $contactUserId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Contact &&
        other.id == id &&
        other.ownerId == ownerId &&
        other.contactUserId == contactUserId;
  }

  @override
  int get hashCode => id.hashCode ^ ownerId.hashCode ^ contactUserId.hashCode;
}
