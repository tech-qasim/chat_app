import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/response.dart';
import 'package:chat_app/services/firebase_references.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserRepository {
  final FirebaseReferences firebaseReferences;

  const UserRepository({required this.firebaseReferences});

  Future<Response<ChatUser?>> saveUser(ChatUser user) async {
    try {
      await firebaseReferences.users
          .doc(user.id)
          .set(user)
          .then((value) => debugPrint("User saved succesfully"));
      return Success(data: user);
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  Future<ChatUser?> fetchUser(String userId) async {
    try {
      final data = await firebaseReferences.users.doc(userId).get();
      return data.data();
    } catch (e) {
      debugPrint("Error fetching User: $e");
      return null;
    }
  }

  Future<void> updateUserAccessToken(String userId, String token) async {
    try {
      await firebaseReferences.users
          .doc(userId)
          .update({'accessToken': token})
          .catchError((err) {
            if (kDebugMode) {
              print(err);
            }
          })
          .then((value) {
            if (kDebugMode) {
              print('access token updated');
            }
          });
    } catch (e) {
      debugPrint("Error updating User Access Token: $e");
      rethrow;
    }
  }

  Future<void> updateUserProfilePic(String userId, String profilePic) async {
    try {
      await firebaseReferences.users
          .doc(userId)
          .update({'profilePic': profilePic})
          .then((value) => debugPrint("User Profile updated succesfully"));
    } catch (e) {
      debugPrint("Error updating User Profile Pic: $e");
      rethrow;
    }
  }

  Future<void> updateName(String userId, String name) async {
    try {
      await firebaseReferences.users
          .doc(userId)
          .update({'name': name})
          .then((value) => debugPrint("User Profile updated succesfully"));
    } catch (e) {
      debugPrint("Error updating User Profile Pic: $e");
      rethrow;
    }
  }

  // Future<void> updateAppStreakAIMessage(String userId, String msg) async {
  //   try {
  //     await firebaseReferences.users.doc(userId).update({
  //       'appStreakAIMessage': msg,
  //     });
  //   } catch (e) {
  //     debugPrint("error storing the app streak msg : ${e.toString()}");
  //   }
  // }
  Future<void> deleteUserData(String uid) async {
    try {
      await firebaseReferences.users.doc(uid).delete();
      debugPrint('user deleted');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Response<bool>> updateNotiUser(ChatUser user) async {
    try {
      await firebaseReferences.users.doc(user.id).update(user.toMap());

      return const Success(data: true);
    } catch (e) {
      debugPrint('Error updating Firestore $user: $e');
      return Failure(message: e.toString());
    }
  }
}
