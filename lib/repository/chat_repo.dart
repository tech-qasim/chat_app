import 'package:chat_app/models/contact.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/services/firebase_references.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRepo {
  final FirebaseReferences firebaseReferences;
  ChatRepo({required this.firebaseReferences});

  Future<void> markMessageAsRead(String chatRoom, String currentUserId) async {
    try {
      final unreadMessages =
          await firebaseReferences
              .chats(chatRoom)
              .where('receiverId', isEqualTo: currentUserId)
              .where('isRead', isEqualTo: false)
              .get();

      for (var doc in unreadMessages.docs) {
        await doc.reference.update({'isRead': true});
      }
    } catch (e) {
      print('Error marking message as read: $e');
    }
  }

  Stream<List<Message>> getMessages(String chatRoom) {
    return firebaseReferences
        .chats(chatRoom)
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Message.fromMap(doc.data().toMap()))
                  .toList(),
        );
  }

  Future<void> sendMessage(Message message, String chatId) async {
    try {
      await firebaseReferences.chats(chatId).add(message);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  // Stream<List<Contact>> getContactsWithUnreadMessages(String currentUserId) {
  //   try {
  //     return FirebaseFirestore.instance.collection('chats').snapshots().map((
  //       snapshot,
  //     ) {
  //       for (var doc in snapshot.docs) {
  //         print(doc.toString());
  //       }

  //       return [];
  //     });
  //   } on Exception catch (e) {
  //     debugPrint(e.toString());
  //     return Stream<List<Contact>>.empty();
  //   }
  // }

  Future<Object> getAllChats() async {
    try {
      return FirebaseFirestore.instance
          .collection('chats')
          .snapshots()
          .map(
            (snapshot) => snapshot.docs.map((doc) {
              print(doc.toString());
            }),
          );
    } catch (e) {
      print('Error reading chats: $e');
      return [];
    }
  }

  Stream<List<Contact>> getContactsWithUnreadMessages(String currentUserId) {
    return firebaseReferences.chatCollection.snapshots().asyncMap((
      snapshot,
    ) async {
      Set<String> contactIds = {};

      for (var doc in snapshot.docs) {
        final messagesSnapshot =
            await doc.reference
                .collection('messages')
                .where('receiverId', isEqualTo: currentUserId)
                .where('isRead', isEqualTo: false)
                .get();

        for (var msg in messagesSnapshot.docs) {
          contactIds.add(msg['senderId'] as String);
        }
      }

      // Fetch Contact objects for each contactId
      List<Contact> contacts = [];
      for (var id in contactIds) {
        final contactDoc = await firebaseReferences.contacts.doc(id).get();
        if (contactDoc.exists) {
          contacts.add(Contact.fromMap((contactDoc.data()?.toMap() ?? {})));
        }
      }

      return contacts;
    });
  }

  //     snapshot,
  //   ) async {
  //     Set<String> contactIds = {};

  //     for (var doc in snapshot.docs) {
  //       final messagesSnapshot =
  //           await doc.reference
  //               .collection('messages')
  //               .where('receiverId', isEqualTo: currentUserId)
  //               .where('isRead', isEqualTo: false)
  //               .get();

  //       for (var msg in messagesSnapshot.docs) {
  //         contactIds.add(msg['senderId']);
  //       }
  //     }

  //     return contactIds.toList();
  //   });
  // }
}
