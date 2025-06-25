import 'package:chat_app/models/contact.dart';
import 'package:chat_app/models/response.dart';
import 'package:chat_app/services/firebase_references.dart';
import 'package:flutter/material.dart';

class ContactRepository {
  final FirebaseReferences firebaseReferences;

  ContactRepository({required this.firebaseReferences});

  Future<Response<Contact?>> saveContact(Contact contact) async {
    try {
      await firebaseReferences.contacts
          .doc(contact.id)
          .set(contact)
          .then((value) => debugPrint("User saved succesfully"));
      return Success(data: contact);
    } catch (e) {
      return Failure(message: 'user saving failed : $e');
    }
  }

  Future<Response<List<Contact>>> fetchContacts() async {
    try {
      final querySnapshot = await firebaseReferences.contacts.get();
      final contacts =
          querySnapshot.docs
              .map((doc) => Contact.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
      return Success(data: contacts);
    } catch (e) {
      return Failure(message: 'Failed to fetch contacts: $e');
    }
  }
}
