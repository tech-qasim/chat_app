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

  Future<Response<List<Contact>>> fetchContacts(String userId) async {
    try {
      final contacts =
          await firebaseReferences.contacts
              .where('ownerId', isEqualTo: userId)
              .get();
      return Success(
        data: contacts.docs.map((e) => e.data()).toList().cast<Contact>(),
      );
    } catch (e) {
      debugPrint("Error fetching user categories: $e");
      return Failure(message: e.toString());
    }
  }

  Future<Response<Contact?>> getContactByUserId(String contactUserId) async {
    try {
      final query =
          await firebaseReferences.contacts
              .where('contactUserId', isEqualTo: contactUserId)
              .get();
      if (query.docs.isNotEmpty) {
        return Success(data: query.docs.first.data());
      } else {
        return Failure(message: 'Contact not found');
      }
    } catch (e) {
      return Failure(message: 'Failed to fetch contact: $e');
    }
  }
}
