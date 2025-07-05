import 'package:chat_app/models/chat_room.dart';
import 'package:chat_app/models/contact.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/repository/contact_repo.dart';
import 'package:chat_app/services/firebase_references.dart';
import 'package:chat_app/utils/di.dart';
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

  Future<void> setChatRoom(ChatRoom chatRoom) async {
    try {
      await firebaseReferences.chatRoom(chatRoom.chatRoom).set(chatRoom);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendMessage(Message message, ChatRoom chatRoom) async {
    try {
      setChatRoom(chatRoom);
      await firebaseReferences.chats(chatRoom.chatRoom).add(message);
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

  // Future<List<String>> getAllChats() async {
  //   print('hello world');
  //   try {
  //     final snapshot =
  //         await FirebaseFirestore.instance.collection('chats').get();

  //     print('control not accepted');

  //     List<String> chatIds = [];

  //     for (var chatDoc in snapshot.docs) {
  //       final docRef = FirebaseFirestore.instance
  //           .collection('chats')
  //           .doc(chatDoc.id);
  //       final docSnapshot = await docRef.get();

  //       if (!docSnapshot.exists) {
  //         print('Italic Document: ${chatDoc.id}');

  //         // Read subcollection (e.g., messages)
  //         final messagesSnapshot = await docRef.collection('messages').get();
  //         for (var messageDoc in messagesSnapshot.docs) {
  //           print('  Message from ${chatDoc.id}: ${messageDoc.data()}');
  //         }
  //       }
  //     }

  //     print('chatIds : $chatIds');
  //     return chatIds;
  //   } catch (e) {
  //     print('Error reading chats: $e');
  //     return [];
  //   }
  // }

  Stream<List<Contact>> getContactsWithUnreadMessages(String currentUserId) {
    final chatCollection = FirebaseFirestore.instance.collection('chats');

    return chatCollection.snapshots().asyncMap((snapshot) async {
      Set<String> contactIds = {};

      for (var chatDoc in snapshot.docs) {
        final messagesQuery =
            await chatDoc.reference
                .collection('messages')
                .where('receiverId', isEqualTo: currentUserId)
                .where('isRead', isEqualTo: false)
                .get();

        for (var msg in messagesQuery.docs) {
          final senderId = msg['senderId'] as String;
          contactIds.add(senderId);
        }
      }

      final ids = contactIds.toList();

      List<Contact> contacts = [];

      for (var id in ids) {
        final contactSnapshot = await getIt<ContactRepository>()
            .getContactByUserId(id);
        final contactData = contactSnapshot.data;
        if (contactData != null) {
          contacts.add(contactData);
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
