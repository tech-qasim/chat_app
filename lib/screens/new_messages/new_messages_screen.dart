import 'package:auto_route/auto_route.dart';
import 'package:chat_app/constants/extension_constants.dart';
import 'package:chat_app/models/contact.dart';
import 'package:chat_app/providers/chat_provider.dart';
import 'package:chat_app/providers/chat_user_provider.dart';
import 'package:chat_app/route/app_route.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class NewMessagesScreen extends ConsumerStatefulWidget {
  const NewMessagesScreen({super.key});

  @override
  ConsumerState<NewMessagesScreen> createState() => _NewMessagesState();
}

class _NewMessagesState extends ConsumerState<NewMessagesScreen> {
  @override
  void initState() {
    super.initState();
  }

  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // final contacts = ref.watch(chatProvider).contacts;
    // final currentUser = ref.watch(chatUserProvider);

    final contactsStream =
        ref.watch(chatProvider.notifier).getContactsWithUnreadMessages();

    return Scaffold(
      appBar: AppBar(title: Text('Contacts')),

      body: StreamBuilder<List<Contact>>(
        stream: contactsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No contacts found.'));
          }
          final contacts = snapshot.data!;
          final currentUser = ref.watch(chatUserProvider);
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                title: Text(contact.contactName),
                onTap: () {
                  final chatRoom = ref
                      .read(chatProvider.notifier)
                      .getChatRoomId(
                        currentUser?.id ?? '',
                        contact.contactUserId,
                      );
                  ref
                      .read(chatProvider.notifier)
                      .markMessagesAsRead(chatRoom, currentUser?.id ?? '');
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
