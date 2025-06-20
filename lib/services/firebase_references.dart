import 'package:chat_app/constant/firebase_constants.dart';
import 'package:chat_app/models/chat_user.dart';
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
}
