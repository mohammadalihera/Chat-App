import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chatapp/common/widgets/index.dart';
import 'package:chatapp/features/select_contacts/controller/select_contact_controller.dart';

class SelectContactsScreen extends ConsumerWidget {
  SelectContactsScreen({Key? key}) : super(key: key);

  ScrollController controller = ScrollController();

  void selectContact(WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref.read(selectContactControllerProvider).selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select contact',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) => Scrollbar(
              controller: controller,
              thickness: 15,
              child: ListView.builder(
                  itemCount: contactList.length,
                  itemBuilder: (context, index) {
                    final contact = contactList[index];
                    return InkWell(
                      onTap: () => selectContact(ref, contact, context),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            contact.displayName,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          subtitle: contact.phones.isNotEmpty ? Text(contact.phones[0].normalizedNumber) : null,
                          leading: contact.photo == null
                              ? null
                              : CircleAvatar(
                                  backgroundImage: MemoryImage(contact.photo!),
                                  radius: 30,
                                ),
                        ),
                      ),
                    );
                  }),
            ),
            error: (err, trace) => ErrorScreen(error: err.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
