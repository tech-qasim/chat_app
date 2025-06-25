import 'package:chat_app/constants/extension_constants.dart';
import 'package:chat_app/providers/chat_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final isUserExists = ref.watch(chatProvider).isUsernameExists;
    return Scaffold(
      appBar: AppBar(title: Text('Contacts')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text('Add Contact'),
                  content: Consumer(
                    builder: (context, ref, child) {
                      final isUsernameExists =
                          ref.watch(chatProvider).isUsernameExists;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: textController,
                            onChanged: (value) {
                              ref
                                  .read(chatProvider.notifier)
                                  .checkIfUsernameExistsInFirestore(value);
                            },
                          ),

                          SizedBox(height: 5),

                          isUsernameExists
                              ? Text(
                                'Username available',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: Colors.green,
                                ),
                              )
                              : Text(
                                'Username not available',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                        ],
                      );
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Close'),
                    ),
                    TextButton(
                      onPressed: isUserExists ? () {} : null,
                      child: Text('Add'),
                    ),
                  ],
                ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Column(children: [
          
        ],
      ),
    );
  }
}
