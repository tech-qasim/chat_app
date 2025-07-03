import 'package:auto_route/auto_route.dart';
import 'package:chat_app/constants/extension_constants.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/chat_user_provider.dart';
import 'package:chat_app/route/app_route.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedInUser = ref.watch(chatUserProvider)?.username;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                (loggedInUser != null && loggedInUser.isNotEmpty)
                    ? loggedInUser[0].toUpperCase()
                    : '',
                style: context.textTheme.bodyMedium?.copyWith(fontSize: 32),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              loggedInUser ?? '',
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).signOut();
                context.router.replace(LoginRoute());
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
