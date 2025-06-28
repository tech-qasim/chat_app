import 'package:chat_app/models/message.dart';
import 'package:chat_app/providers/chat_user_provider.dart';
import 'package:chat_app/repository/chat_repo.dart';
import 'package:chat_app/repository/contact_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chat_app/models/contact.dart';
import 'package:chat_app/repository/user_repo.dart';
import 'package:chat_app/utils/di.dart';
import 'package:uuid/uuid.dart';

class ChatState {
  bool isUsernameExists;
  List<Contact> contacts;

  ChatState({required this.isUsernameExists, required this.contacts});

  ChatState copyWith({bool? isUsernameExists, List<Contact>? contacts}) {
    return ChatState(
      isUsernameExists: isUsernameExists ?? this.isUsernameExists,
      contacts: contacts ?? this.contacts,
    );
  }

  factory ChatState.initial() {
    return ChatState(isUsernameExists: false, contacts: []);
  }
}

class ChatNotifier extends Notifier<ChatState> {
  void setUsernameExists(bool exists) {
    state = state.copyWith(isUsernameExists: exists);
  }

  @override
  ChatState build() {
    return ChatState.initial();
  }

  void checkIfUsernameExistsInFirestore(String username) async {
    final userRepo = getIt<UserRepository>();
    final isUserExists = await userRepo.checkIfUsernameExistsInFirestore(
      username,
    );

    if (isUserExists) {
      state = state.copyWith(isUsernameExists: true);
    } else {
      state = state.copyWith(isUsernameExists: false);
    }
  }

  Future<void> fetchContacts() async {
    final userRepo = getIt<ContactRepository>();
    final currentChatUser = ref.read(chatUserProvider)?.id;
    final response = await userRepo.fetchContacts(currentChatUser ?? "");
    state = state.copyWith(contacts: response.data);
  }

  Stream<List<Message>> getMessages(String chatId) {
    final messages = getIt<ChatRepo>().getMessages(chatId);
    return messages;
  }

  void sendMessage(String content, String receiverId) async {
    final currentUser = ref.read(chatUserProvider)?.id ?? '';
    final chatRoom = "${currentUser}_$receiverId";
    final message = Message(
      id: Uuid().v4(),
      senderId: currentUser,
      receiverId: receiverId,
      content: content,
    );
    await getIt<ChatRepo>().sendMessage(message, chatRoom);
  }

  Future<void> addContact(String username) async {
    if (state.isUsernameExists == true) {
      if (state.contacts.any((contact) => contact.contactName == username)) {
        return;
      }

      final user = await getIt<UserRepository>().fetchUserByUsername(username);
      final currentChatUser = ref.read(chatUserProvider)?.id;

      final newContact = Contact(
        id: Uuid().v4(),
        ownerId: currentChatUser ?? '',
        contactUserId: user?.id ?? '',
        contactName: user?.username ?? '',
      );

      final response = await getIt<ContactRepository>().saveContact(newContact);

      if (response.data != null) {
        state = state.copyWith(contacts: [...state.contacts, newContact]);
      }
    } else {
      debugPrint('user does not exist so i cannot add');
    }
  }
}

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
