import 'dart:async';
import 'package:flutter/material.dart';
import 'package:goat/data/data.dart';
import 'package:goat/data/session.dart';
import 'package:goat/pages/chat_settings_page.dart';
import 'package:goat/tools/formatted_text.dart';
import 'package:goat/tools/formatted_timestamp.dart';
import 'package:goat/widgets/dialog.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageControler = TextEditingController();
  var _messages = [], _messagesOldLength = 0, _blockSettings = [];
  Timer? _timer;

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void _refresh() {
    Data.getMessages().then((ls) {
      if (ls.isNotEmpty && ls[0].containsKey("m")) {
        Navigator.pop(context);
        return;
      }
      if (ls.length != _messages.length) {
        _messages = ls;
        setState(() {});
      }
    });
    Data.getSettings().then((ls) {
      if (ls != _blockSettings) {
        _blockSettings = ls;
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _refresh();
    _timer = Timer.periodic(
        const Duration(milliseconds: 500), (timer) => _refresh());
  }

  _sendText() {
    String text = _messageControler.text.trim();
    if (text.isNotEmpty) {
      Data.sendMessage(text).then((ls) {
        if (ls.isNotEmpty && ls[0].containsKey("m")) {
          showMessageDialog(context, ls[0]["m"], "");
        } else {
          _messageControler.clear();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_messagesOldLength != _messages.length) {
      Future.delayed(const Duration(milliseconds: 300), () => Session.scroll());
      _messagesOldLength = _messages.length;
    }
    final isBlocker = _blockSettings.isNotEmpty &&
        _blockSettings.first["is_blocker"].toString() == '1';
    final isBlocked = _blockSettings.isNotEmpty &&
        _blockSettings.first["is_blocked"].toString() == '1';
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          formattedText(Data.selectedName),
          softWrap: true,
          maxLines: 2,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatSettingsPage(),
                  ),
                );
              },
              icon: const Icon(Icons.settings_outlined))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text("No messages"))
                : ListView.builder(
                    itemCount: _messages.length,
                    controller: Session.scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      final timestamp =
                          formattedTimestamp(_messages[index]["timestamp"]);
                      final isSender = _messages[index]["is_sender"] == 1;
                      return Padding(
                        padding: EdgeInsets.fromLTRB(
                            isSender ? 5 : 80, 5, !isSender ? 5 : 80, 0),
                        child: Column(
                            crossAxisAlignment: isSender
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                            children: [
                              Card(
                                color:
                                    isSender ? Colors.grey[200] : Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (Data.pageType == PageType.group &&
                                              _messages[index]["is_sender"] !=
                                                  1)
                                          ? Text(
                                              "${_messages[index]['sender_name']}",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            )
                                          : const SizedBox(),
                                      Text(
                                        _messages[index]["text"],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      Text(
                                        timestamp,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ]),
                      );
                    },
                  ),
          ),
          Container(
            color: Theme.of(context).colorScheme.primary.withAlpha(30),
            padding: const EdgeInsets.all(10),
            child: isBlocker && isBlocked
                ? const Center(child: Text("You both have blocked each other"))
                : isBlocker
                    ? Center(
                        child: Text("You have blocked ${Data.selectedName}"))
                    : isBlocked
                        ? Center(
                            child: Text("${Data.selectedName} has blocked you"))
                        : Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  minLines: 1,
                                  controller: _messageControler,
                                  decoration: const InputDecoration(
                                      hintText: 'Message'),
                                ),
                              ),
                              IconButton(
                                onPressed: _sendText,
                                icon: const Icon(Icons.send),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
          ),
        ],
      ),
    );
  }
}
