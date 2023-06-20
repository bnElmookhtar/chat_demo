import 'package:flutter/material.dart';
import 'package:goat/data/data.dart';
import 'package:goat/pages/chat_page.dart';
import 'package:goat/pages/create_page.dart';
import 'package:goat/tools/formatted_text.dart';
import 'package:goat/tools/formatted_timestamp.dart';
import 'dart:async';

class ChatsView extends StatefulWidget {
  const ChatsView({Key? key}) : super(key: key);

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  var _chats = [];
  Timer? _timer;

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void _refresh() {
    Data.getChats().then((ls) {
      if (ls.isNotEmpty && ls[0].containsKey("m")) {
        Navigator.pop(context);
        return;
      }
      if (Data.pageType == PageType.broadcast) {
        List<dynamic> chats = [];
        for (int index = 0; index < ls.length; index++) {
          final lsRow = ls[index];
          if (index == 0 || lsRow["id"] != chats.last["id"]) {
            chats.add({
              "id": lsRow["id"],
              "name": lsRow["name"],
              "text": lsRow["text"],
              "timestamp": lsRow["timestamp"],
            });
          } else {
            chats.last["name"] = "${chats.last["name"]}, ${lsRow['name']}";
          }
        }
        if (chats != _chats) {
          _chats = chats;
          if (mounted) setState(() {});
        }
      } else if (ls != _chats) {
        _chats = ls;
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _refresh());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreatePage(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: _chats.isEmpty
            ? const Center(child: Text("No chats"))
            : ListView.builder(
                itemCount: _chats.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primary.withAlpha(50),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      child: (Data.pageType == PageType.person ||
                              Data.pageType == PageType.group)
                          ? Text(
                              _chats[index]["name"].toString().substring(0, 2))
                          : const Icon(Icons.people),
                    ),
                    title: Text(formattedText(_chats[index]["name"])),
                    subtitle: Text((_chats[index]["is_sender"] == 1
                            ? "You: "
                            : (Data.pageType == PageType.group &&
                                    _chats[index]["sender_name"] != null)
                                ? "${_chats[index]["sender_name"]}: "
                                : "") +
                        formattedText(_chats[index]["text"])),
                    trailing: Text(
                        formattedTimestamp(_chats[index]["timestamp"], true)),
                    onTap: () {
                      Data.selectedName = formattedText(_chats[index]["name"]);
                      Data.selectedId = _chats[index]["id"];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatPage(),
                        ),
                      );
                    },
                  );
                },
              ),
      );
}
