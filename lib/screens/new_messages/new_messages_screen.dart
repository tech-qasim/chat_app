import 'package:auto_route/auto_route.dart';
import 'package:chat_app/models/contact.dart';
import 'package:chat_app/providers/chat_provider.dart';
import 'package:chat_app/providers/chat_user_provider.dart';
import 'package:chat_app/route/app_route.gr.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class NewMessagesScreen extends ConsumerWidget {
  const NewMessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsyncValue = ref.watch(unreadContactsProvider);
    final currentUser = ref.watch(chatUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Contacts with New Messages')),
      body: contactsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (contacts) {
          if (contacts.isEmpty) {
            return const Center(
              child: Text('No contacts with unread messages.'),
            );
          }

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                title: Text(contact.contactName),
                subtitle: Text('Tap to open chat'),
                trailing: const Icon(Icons.message),
                onTap: () {
                  final chatRoomId = ref
                      .read(chatProvider.notifier)
                      .getChatRoomId(
                        currentUser?.id ?? '',
                        contact.contactUserId,
                      );

                  // Mark messages as read
                  ref
                      .read(chatProvider.notifier)
                      .markMessagesAsRead(chatRoomId, currentUser?.id ?? '');

                  // Navigate to chat screen
                  context.router.push(
                    ChatRoute(receiverId: contact.contactUserId),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
