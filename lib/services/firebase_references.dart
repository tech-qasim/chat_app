import 'package:chat_app/constants/firebase_constants.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseReferences {
  final String appMode;
  final FirebaseFirestore firestore;

  FirebaseReferences({required this.appMode, required this.firestore});

  CollectionReference<ChatUser> get users => firestore
      .collection(FirebaseCollectionNames.chatUsers)
      .withConverter<ChatUser>(
        fromFirestore:
            (snapshot, _) => ChatUser.fromMap((snapshot.data() ?? {})),
        toFirestore: (user, _) => user.toMap(),
      );
  CollectionReference<Contact> get contacts => firestore
      .collection(FirebaseCollectionNames.contacts)
      .withConverter<Contact>(
        fromFirestore:
            (snapshot, _) => Contact.fromMap((snapshot.data() ?? {})),
        toFirestore: (contact, _) => contact.toMap(),
      );
}
