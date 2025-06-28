import 'package:chat_app/repository/auth_repo.dart';
import 'package:chat_app/repository/contact_repo.dart';
import 'package:chat_app/repository/user_repo.dart';
import 'package:chat_app/services/firebase_references.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupDependecyInjector() {
  getIt.registerLazySingleton<FirebaseFirestore>(() {
    final firestore = FirebaseFirestore.instance;
    firestore.settings = const Settings(persistenceEnabled: true);
    return firestore;
  });
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepo(auth: getIt<FirebaseAuth>()),
  );
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(firebaseReferences: getIt<FirebaseReferences>()),
  );
  getIt.registerLazySingleton<ContactRepository>(
    () => ContactRepository(firebaseReferences: getIt<FirebaseReferences>()),
  );

  getIt.registerLazySingleton<FirebaseReferences>(
    () => FirebaseReferences(
      firestore: getIt<FirebaseFirestore>(),
      appMode: 'dev',
    ),
  );
}
