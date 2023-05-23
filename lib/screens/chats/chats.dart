import 'package:flutter/material.dart';
import 'package:goat/screens/chats/pages/chat_page.dart';
import 'package:goat/screens/chats/pages/contacts_page.dart';
import 'package:goat/server/request.dart';
import 'package:goat/server/session.dart';
class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  var items = [];

  @override
  void initState() {
    super.initState();

    request(context, 
    {"q":"chats", "user_id": Session.userId}
    ).then((ls) { setState((){ items = ls; });});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactsPage(),
            ),
          );
        }, 
        child: Icon(Icons.search),
      ),
      body: Padding( 
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: 
        ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Text(items[index]["name"].toString().substring(0, 2)),
              ),
              title: Text(items[index]["name"]),
              subtitle: Text(items[index]["last_message"]),
              trailing: Text(items[index]["timestamp"].replaceFirst(" ", "\n")),
              onTap: () {
                Session.selectedId = items[index]["id"].toString();
                Session.selectedName = items[index]["name"];
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
      )
    );
  }

}
