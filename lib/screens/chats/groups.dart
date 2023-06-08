import 'package:flutter/material.dart';
import 'package:goat/screens/chats/pages/group_page.dart';
import 'package:goat/screens/chats/pages/create_group_page.dart';
import 'package:goat/server/request.dart';
import 'package:goat/server/session.dart';
import 'dart:async';
class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  var items = [];

  late Timer timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

      request(context, 
      {"q":"groups", "user_id": Session.userId}
      ).then((ls) { setState((){ items = ls;});});
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      request(context, 
      {"q":"groups", "user_id": Session.userId}
      ).then((ls) { setState((){ items = ls;});});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateGroupPage(),
            ),
          );
        }, 
        child: Icon(Icons.add_outlined),
      ),
      body: Padding( 
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: 
        ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(child: Icon(Icons.group)),
              title: Text(items[index]["name"]),
              subtitle: Text(items[index]["text"] == null ? "No messages" : '${items[index]["sender_name"]}: ${items[index]["text"]}'),
              trailing: Text(items[index]["text"] == null ? "" :  items[index]["timestamp"].replaceFirst(" ", "\n")),
              onTap: () {
                Session.selectedId = items[index]["id"].toString();
                Session.selectedName = items[index]["name"];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupPage(),
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

