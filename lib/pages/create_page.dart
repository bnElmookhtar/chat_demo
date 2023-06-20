import 'package:flutter/material.dart';
import 'package:goat/data/data.dart';
import 'package:goat/pages/chat_page.dart';
import 'package:goat/widgets/dialog.dart';
import 'package:goat/widgets/snackbar.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);
  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  var _contacts = [];
  final _nameControler = TextEditingController();

  void _create() {
    String ids = "";
    for (final contact in _contacts) {
      if (contact["is_checked"] == true) {
        ids += "${contact["id"]} ";
      }
    }
    Data.create(_nameControler.text.trim(), ids).then((ls) {
      if (ls.first.containsKey("m")) {
        showMessageDialog(context, ls.first["m"], "");
      } else {
        Navigator.pop(context);
        showSnackBar(context, "Created");
      }
    });
  }

  void _tappedContact(int index) {
    if (Data.pageType == PageType.person) {
      Data.selectedId = _contacts[index]["id"];
      Data.selectedName = _contacts[index]["name"];
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatPage(),
        ),
      );
    } else {
      setState(() {
        _contacts[index]["is_checked"] = _contacts[index]["is_checked"] != true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Data.getContacts().then((ls) {
      if (_contacts != ls) {
        setState(() {
          _contacts = ls;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Data.pageType == PageType.person
            ? "Message Contacts"
            : Data.pageType == PageType.group
                ? "Create Group"
                : "Create Broadcast"),
      ),
      body: (_contacts.isNotEmpty && _contacts.first.containsKey("m"))
          ? Center(
              child: Text(_contacts.first["m"]),
            )
          : Column(
              children: [
                Data.pageType == PageType.group
                    ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 1,
                          controller: _nameControler,
                          decoration: const InputDecoration(hintText: 'Name'),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 10),
                Data.pageType != PageType.person
                    ? Text(
                        "Selected ${_contacts.where((item) => item["is_checked"] == true).length} contacts")
                    : const SizedBox(),
                Expanded(
                  child: _contacts.isEmpty
                      ? const Center(child: Text("No contacts"))
                      : ListView.builder(
                          itemCount: _contacts.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(50),
                                foregroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: Text(_contacts[index]["name"]
                                    .toString()
                                    .substring(0, 2)),
                              ),
                              title: Text(_contacts[index]["name"]),
                              subtitle: Text(_contacts[index]["phone"]),
                              trailing: _contacts[index]["is_checked"] == true
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.green[600],
                                    )
                                  : const SizedBox(),
                              onTap: () => _tappedContact(index),
                            );
                          },
                        ),
                ),
                Data.pageType != PageType.person
                    ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                            onPressed: _create, child: const Text("Create")),
                      )
                    : const SizedBox()
              ],
            ),
    );
  }
}
