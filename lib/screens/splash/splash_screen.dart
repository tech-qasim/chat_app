import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/constants/extension_constants.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/chat_user_provider.dart';
import 'package:chat_app/route/app_route.gr.dart';
import 'package:chat_app/utils/di.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(
      backgroundColor: Colors.white,
      childWidget: SizedBox(
        height: 250,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Chat App",
              style: context.textTheme.displayLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      asyncNavigationCallback: () async {
        final auth = getIt<FirebaseAuth>();
        final user = auth.currentUser;

        if (user != null) {
          final chatUser = await ref
              .read(authProvider.notifier)
              .checkIfUserExistsInFirebase(user.uid);

          ref.read(authProvider.notifier).setAuthCurrentUser(user);
          ref.read(chatUserProvider.notifier).state = chatUser;

          await Future.delayed(
            const Duration(seconds: 2),
          ); // Optional delay for splash effect

          if (context.mounted) {
            if (chatUser != null) {
              debugPrint('whats happening');
              context.router.replace(const NavigationRoute());
            } else {
              context.router.replace(const LoginRoute());
            }
          }
        } else {
          await Future.delayed(
            const Duration(seconds: 2),
          ); // Optional delay for splash effect

          if (context.mounted) {
            context.router.replace(const LoginRoute());
          }
        }
      },

      useImmersiveMode: false,
    );
  }
}
