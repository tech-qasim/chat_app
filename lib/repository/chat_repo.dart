import 'package:chat_app/models/message.dart';
import 'package:chat_app/services/firebase_references.dart';

class ChatRepo {
  final FirebaseReferences firebaseReferences;
  ChatRepo({required this.firebaseReferences});

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
}
