import 'package:flutter/material.dart';
import 'package:goat/data/data.dart';
import 'package:goat/data/session.dart';
import 'package:goat/pages/members_page.dart';
import 'package:goat/widgets/dialog.dart';
import 'package:goat/widgets/snackbar.dart';

class ChatSettingsPage extends StatefulWidget {
  const ChatSettingsPage({super.key});

  @override
  State<ChatSettingsPage> createState() => _ChatSettingsPageState();
}

class _ChatSettingsPageState extends State<ChatSettingsPage> {
  var _settingsData = [];

  final _groupNameControler = TextEditingController();
  var isUserAdmin = false;

  void _updateGroupName() {
    String name = _groupNameControler.text.trim();
    if (name == Data.selectedName || name.isEmpty) {
      showMessageDialog(context, "Not a new name", "");
      return;
    }
    Data.updateGroupName(name).then((ls) {
      if (ls.isNotEmpty && ls[0].containsKey("m")) {
        showMessageDialog(context, ls[0]["m"], "");
      } else {
        showSnackBar(context, "Updated name");
        Data.selectedName = name;
        _groupNameControler.text = "";
        _refresh();
      }
    });
  }

  void _leaveGroup() {
    if (isUserAdmin) {
      final adminsCount = _settingsData
          .where((row) =>
              row["id"] == Session.userId && row["is_admin"].toString() == '1')
          .length;
      if (adminsCount == 1) {
        showMessageDialog(context, "You are the only admin",
            "You can delete the group instead");
        return;
      }
    }
    showConfirmationDialog(
        context,
        "Do leave group?",
        "",
        () => Data.leaveGroup().then((ls) {
              if (ls.isNotEmpty && ls[0].containsKey("m")) {
                showMessageDialog(context, ls[0]["m"], "");
              } else {
                showSnackBar(context, "Leaved ${Data.selectedName}");
                Navigator.pop(context);
                Navigator.pop(context);
              }
            }));
  }

  void _delete() {
    showConfirmationDialog(
        context,
        Data.pageType == PageType.group ? "Delete Group" : "Delete Broadcast",
        "This action cannot be undone",
        () => Data.delete().then((ls) {
              if (ls.isNotEmpty && ls[0].containsKey("m")) {
                showMessageDialog(context, ls[0]["m"], "");
              } else {
                showSnackBar(context, "Deleted ${Data.selectedName}");
                Navigator.pop(context);
                Navigator.pop(context);
              }
            }));
  }

  void _blockPerson() {
    if (_settingsData.isEmpty) return;
    if (_settingsData.first["is_blocker"].toString() == '1') {
      showConfirmationDialog(
          context,
          "Do unblock ${Data.selectedName}?",
          "",
          () => Data.unblockUser().then((ls) {
                if (ls.isNotEmpty && ls[0].containsKey("m")) {
                  showMessageDialog(context, ls[0]["m"], "");
                } else {
                  showSnackBar(context, "Unblocked ${Data.selectedName}");
                  _refresh();
                }
              }));
    } else {
      showConfirmationDialog(
          context,
          "Do block ${Data.selectedName}?",
          "You and them cannot send or receive messages",
          () => Data.blockUser().then((ls) {
                if (ls.isNotEmpty && ls[0].containsKey("m")) {
                  showMessageDialog(context, ls[0]["m"], "");
                } else {
                  showSnackBar(context, "Blocked ${Data.selectedName}");
                  _refresh();
                }
              }));
    }
  }

  void _deleteChat() {
    showConfirmationDialog(
        context,
        "Do delete all messages?",
        Data.pageType == PageType.person
            ? "Chat is deleted for both of you"
            : "Chat is deleted for you and all users",
        () => Data.deleteChat().then((ls) {
              if (ls.isNotEmpty && ls[0].containsKey("m")) {
                showMessageDialog(context, ls[0]["m"], "");
              } else {
                showSnackBar(context, "Deleted messages");
              }
            }));
  }

  void _refresh() {
    Data.getSettings().then((ls) {
      if (ls[0].containsKey("m")) {
        Navigator.pop(context);
        Navigator.pop(context);
        return;
      }
      _settingsData = ls;
      if (Data.pageType == PageType.group) {
        for (final row in _settingsData) {
          if (row["id"] == Session.userId &&
              row["is_admin"].toString() == '1') {
            isUserAdmin = true;
            break;
          }
        }
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(Data.pageType == PageType.group
              ? "Group Settings"
              : Data.pageType == PageType.broadcast
                  ? "Broadcast Settings"
                  : "Chat Settings")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withAlpha(50),
                foregroundColor: Theme.of(context).colorScheme.primary,
                child: (Data.pageType == PageType.person ||
                        Data.pageType == PageType.group)
                    ? Text(Data.selectedName.toString().substring(0, 2))
                    : const Icon(Icons.people),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              Data.selectedName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          isUserAdmin
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(),
                      TextField(
                        maxLines: 1,
                        controller: _groupNameControler,
                        decoration: const InputDecoration(hintText: 'New name'),
                      ),
                      const SizedBox(),
                    ],
                  ),
                )
              : const SizedBox(),
          isUserAdmin
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: OutlinedButton(
                      onPressed: _updateGroupName, child: const Text("Update")),
                )
              : const SizedBox(),
          Data.pageType != PageType.group || isUserAdmin
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: OutlinedButton(
                      onPressed: _deleteChat,
                      child: const Text("Delete Messages")),
                )
              : const SizedBox(),
          Data.pageType == PageType.group
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: OutlinedButton(
                      onPressed: _leaveGroup, child: const Text("Leave Group")),
                )
              : const SizedBox(),
          Data.pageType == PageType.person
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: OutlinedButton(
                    onPressed: _blockPerson,
                    child: Text(_settingsData.isNotEmpty &&
                            _settingsData.first["is_blocker"].toString() == '1'
                        ? "Unblock"
                        : "Block"),
                  ),
                )
              : const SizedBox(),
          Data.pageType == PageType.broadcast || isUserAdmin
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: OutlinedButton(
                    onPressed: _delete,
                    child: Text(Data.pageType == PageType.group
                        ? "Delete Group"
                        : "Delete Broadcast"),
                  ),
                )
              : const SizedBox(),
          Data.pageType != PageType.person
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MembersPage(),
                      ),
                    ),
                    child: Text(Data.pageType == PageType.group
                        ? "Show Members"
                        : "Show Receivers"),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
