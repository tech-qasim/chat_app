import 'package:chat_app/repository/auth_repo.dart';
import 'package:chat_app/repository/user_repo.dart';
import 'package:chat_app/utils/di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class ChatState {
  bool isUsernameExists;
  ChatState({required this.isUsernameExists});

  ChatState copyWith({bool? isUsernameExists}) {
    return ChatState(
      isUsernameExists: isUsernameExists ?? this.isUsernameExists,
    );
  }

  factory ChatState.initial() {
    return ChatState(isUsernameExists: false);
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
}

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
