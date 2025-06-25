import 'dart:convert';

class Contact {
  String id;
  String ownerId;
  String contactUserId;
  String contactName;

  Contact({
    required this.id,
    required this.ownerId,
    required this.contactUserId,
    required this.contactName,
  });

  Contact copyWith({
    String? id,
    String? ownerId,
    String? contactUserId,
    String? contactName,
  }) {
    return Contact(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      contactUserId: contactUserId ?? this.contactUserId,
      contactName: contactName ?? this.contactName,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'ownerId': ownerId});
    result.addAll({'contactUserId': contactUserId});
    result.addAll({'contactName': contactName});

    return result;
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      contactUserId: map['contactUserId'] ?? '',
      contactName: map['contactName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) =>
      Contact.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Contact(id: $id, ownerId: $ownerId, contactUserId: $contactUserId, contactName: $contactName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Contact &&
        other.id == id &&
        other.ownerId == ownerId &&
        other.contactUserId == contactUserId &&
        other.contactName == contactName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ownerId.hashCode ^
        contactUserId.hashCode ^
        contactName.hashCode;
  }
}
