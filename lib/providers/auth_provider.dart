import 'dart:io';

import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/response.dart';
import 'package:chat_app/providers/chat_user_provider.dart';
import 'package:chat_app/repository/auth_repo.dart';
import 'package:chat_app/repository/user_repo.dart';
import 'package:chat_app/utils/di.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final User? user;
  final String? phoneNumber;
  final String? location;
  final String? displayName;
  final String? username;
  final bool isLoading;
  final bool showPassword;
  final bool showConfirmPassword;
  final File? userPickedProfilePic;
  final bool isTermsAndConditionsAccepted;
  final String? userType;

  AuthState({
    this.user,
    this.phoneNumber,
    this.location,
    this.displayName,
    this.isLoading = false,
    this.showPassword = false,
    this.showConfirmPassword = false,
    this.userPickedProfilePic,
    this.isTermsAndConditionsAccepted = false,
    this.userType,
    this.username,
  });

  factory AuthState.initial() => AuthState();

  AuthState copyWith({
    User? user,
    String? phoneNumber,
    String? location,
    String? displayName,
    bool? isLoading,
    bool? showPassword,
    bool? showConfirmPassword,
    File? userPickedProfilePic,
    bool? isTermsAndConditionsAccepted,
    String? userType,
    String? username,
  }) {
    return AuthState(
      user: user ?? this.user,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      displayName: displayName ?? this.displayName,
      isLoading: isLoading ?? this.isLoading,
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      userPickedProfilePic: userPickedProfilePic ?? this.userPickedProfilePic,
      isTermsAndConditionsAccepted:
          isTermsAndConditionsAccepted ?? this.isTermsAndConditionsAccepted,
      userType: userType ?? this.userType,
      username: username ?? this.username,
    );
  }
}

class _AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState.initial();
  }

  void setAuthCurrentUser(User? user) {
    state = state.copyWith(user: user);
  }

  void setUserProperties(
    String phoneNumber,
    String location,
    String displayName,
  ) {
    state = state.copyWith(
      phoneNumber: phoneNumber,
      location: location,
      displayName: displayName,
    );
  }

  void setName(String name) {
    state = state.copyWith(displayName: name);
  }

  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  void setEmail(String email) {}

  void setLocation(String location) {
    state = state.copyWith(location: location);
  }

  void setDisplayName(String displayName) {
    state = state.copyWith(displayName: displayName);
  }

  void setIsLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void setShowPassword(bool value) {
    state = state.copyWith(showPassword: value);
  }

  void setShowConfirmPassword(bool value) {
    state = state.copyWith(showConfirmPassword: value);
  }

  void setUserPickedProfilePic(File image) {
    state = state.copyWith(userPickedProfilePic: image);
  }

  void isTermsAndConditionsAccepted(bool value) {
    state = state.copyWith(isTermsAndConditionsAccepted: value);
  }

  // Future<Response<KhiatUser?>?> registerTailorProfile() async {
  //   setIsLoading(true);
  //   final userFirebaseRepo = getIt<UserRepository>();
  //   final user = state.user;
  //   final newKhiatUser = KhiatUser(id: id, name: name, phoneNumber: phoneNumber, email: email)
  // }

  // Future<String?> uploadUserProfilePic(
  //   String? uid,
  //   File pickedUserProfilePic,
  // ) async {
  //   final firebase = FireStorageService();
  //   final firebaseresponse = await firebase.uploadFileImage(
  //     pickedUserProfilePic,
  //     '${FireStoragePaths.profilePic}$uid/${pickedUserProfilePic.path.split('/').last}',
  //   );
  //   return firebaseresponse.data;
  // }

  Future<Response<ChatUser?>?> registerUserProfile() async {
    setIsLoading(true);

    // final pickedUserProfilePic = state.userPickedProfilePic;
    // final userdisplayName= state.displayName;
    // final messanging = FirebaseMessaging.instance;
    // String? accessToken;
    // try {
    //   String? token = await messanging.getToken();
    //   debugPrint("Token: $token");
    // } catch (e) {
    //   debugPrint("Error fetching token: $e");
    // }

    // debugPrint("access token : $accessToken");

    // String? profilePicUrl = user?.photoURL;
    // if (pickedUserProfilePic != null) {
    //   profilePicUrl = await uploadUserProfilePic(
    //     user?.uid,
    //     pickedUserProfilePic,
    //   );
    //   if (profilePicUrl == null) {
    //     setIsLoading(false);
    //     return const Failure(message: "Profile picture upload failed");
    //   }
    // }

    final userFirebaseRepo = getIt<UserRepository>();
    final user = state.user;

    final newChatUser = ChatUser(
      id: user?.uid ?? "",
      email: user?.email ?? '',
      username: state.username ?? '',
    );

    final response = await userFirebaseRepo.saveUser(newChatUser);

    setIsLoading(false);
    if (response is Success) {
      ref.read(chatUserProvider.notifier).state = newChatUser;

      return response;
    } else if (response is Failure) {
      return response;
    }
    return null;
  }

  // Future<String?> uploadUserProfilePic(
  //   String? uid,
  //   File pickedUserProfilePic,
  // ) async {
  //   final firebase = FireStorageService();
  //   final firebaseresponse = await firebase.uploadFileImage(
  //     pickedUserProfilePic,
  //     '${FireStoragePaths.profilePic}$uid/${pickedUserProfilePic.path.split('/').last}',
  //   );
  //   return firebaseresponse.data;
  // }

  Future<Response<UserCredential>> signInWithEmail(
    String email,
    String password,
  ) async {
    state = state.copyWith(isLoading: true);
    final authRepo = getIt<AuthRepo>();
    final response = await authRepo.loginUserWithEmail(email, password);
    if (response.data != null) {
      final clockerUser = await checkIfUserExistsInFirebase(
        response.data!.user?.uid ?? "",
      );
      if (clockerUser != null) {
        ref.read(chatUserProvider.notifier).state = clockerUser;
        state = state.copyWith(isLoading: false, user: response.data!.user);
        return response;
      } else {
        state = state.copyWith(isLoading: false, user: response.data!.user);
        return response;
      }
    } else {
      state = state.copyWith(isLoading: false);
      return response;
    }
  }

  Future<Response<UserCredential>> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    state = state.copyWith(isLoading: true);
    final authRepo = getIt<AuthRepo>();
    final response = await authRepo.signupUserWithEmail(email, password);
    if (response.data != null) {
      final loggedInUser = await checkIfUserExistsInFirebase(
        response.data!.user?.uid ?? "",
      );
      if (loggedInUser != null) {
        ref.read(chatUserProvider.notifier).state = loggedInUser;
        state = state.copyWith(isLoading: false, user: response.data!.user);
        return response;
      } else {
        state = state.copyWith(isLoading: false, user: response.data!.user);
        return response;
      }
    } else {
      state = state.copyWith(isLoading: false);
      return response;
    }
  }

  Future<ChatUser?> checkIfUserExistsInFirebase(String userId) async {
    final userRepo = getIt<UserRepository>();
    final user = await userRepo.fetchUser(userId);
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  Future<Response> resetUserPassword(String email) async {
    final authRepo = getIt<AuthRepo>();
    final isResetCodeSent = await authRepo.resetUserPassword(email);
    if (isResetCodeSent) {
      return const Success(
        data: "Verification code successfully sent to your email",
      );
    } else {
      return const Failure(message: "Some error occurred, Try again");
    }
  }

  Future<void> signOut() async {
    final user = getIt<FirebaseAuth>().currentUser;

    print("log out user = ${user?.email}");
    final authRepo = getIt<AuthRepo>();
    authRepo.signOutUser();

    state = AuthState.initial();
    ref.read(chatUserProvider.notifier).state = null;
  }

  Future<ChatUser?> fetchChatUser(String uid) async {
    final userRepo = getIt<UserRepository>();
    final clockerUser = await userRepo.fetchUser(uid);
    ref.read(chatUserProvider.notifier).state = clockerUser;
    return clockerUser;
  }

  // void updateName(String name) async {
  //   state = state.copyWith(isLoading: true);

  //   final user = ref.read(habitbeeUserProvider);
  //   final userFirebaseRepo = getIt<UserRepository>();

  //   await userFirebaseRepo.updateName(user?.id ?? '', name);

  //   ref.read(habitbeeUserProvider.notifier).state = user?.copyWith(name: name);

  //   state = state.copyWith(isLoading: false);
  // }
}

final authProvider = NotifierProvider<_AuthNotifier, AuthState>(
  _AuthNotifier.new,
);
