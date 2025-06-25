import 'package:chat_app/models/response.dart';
import 'package:chat_app/repository/contact_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chat_app/models/contact.dart';
import 'package:chat_app/repository/user_repo.dart';
import 'package:chat_app/utils/di.dart';

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
    final response = await userRepo.fetchContacts();
    state = state.copyWith(contacts: response.data);
  }
}

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
