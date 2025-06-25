import 'package:chat_app/models/contact.dart';
import 'package:chat_app/models/response.dart';
import 'package:chat_app/services/firebase_references.dart';
import 'package:flutter/material.dart';

class ContactRepository {
  final FirebaseReferences firebaseReferences;

  ContactRepository({required this.firebaseReferences});

  Future<Response<Contact?>> saveUser(Contact contact) async {
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
}
