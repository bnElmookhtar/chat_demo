import 'package:flutter/material.dart';
import 'package:goat/server/session.dart';
import 'package:goat/server/request.dart';
import 'package:goat/screens/chats/pages/chat_page.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  var items = [];

  @override
  void initState() {
    super.initState();

    request(context, 
    {"q":"contacts", "user_id": Session.userId}
    ).then((ls) { setState((){ items = ls; });});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(title: Text("Add contact")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text(items[index]["name"].toString().substring(0, 2)),
            ),
            title: Text(items[index]["name"]),
            subtitle: Text(items[index]["phone"]),
            onTap: () {
              Session.selectedId = items[index]["id"].toString();
              Session.selectedName = items[index]["name"];
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
