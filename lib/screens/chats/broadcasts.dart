import 'dart:async';
import 'package:flutter/material.dart';
import 'package:goat/screens/chats/pages/broadcast_page.dart';
import 'package:goat/screens/chats/pages/create_broadcast_page.dart';
import 'package:goat/server/request.dart';
import 'package:goat/server/session.dart';

class Broadcasts extends StatefulWidget {
  const Broadcasts({Key? key}) : super(key: key);

  @override
  State<Broadcasts> createState() => _BroadcastsState();
}

class _BroadcastsState extends State<Broadcasts> {
  var items = [];

  late Timer timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void refresh() {
    request(context, 
    {"q":"broadcasts", "user_id": Session.userId}
    ).then((ls) { setState((){ 
      items.clear();
      outer_loop: 
      for (int j, i=0; i<ls.length; i++) {
        for (j=0; j<items.length; j++) {
          if (items[j]["id"] == ls[i]["id"]) {
            items[j]["name"] += ', ${ls[i]["name"]}';
            continue outer_loop;
          }
        }
        items.add(ls[i]);
      }
    });
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      refresh();
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
              builder: (context) => CreateBroadcastPage(),
            ),
          );
        }, 
        child: Icon(Icons.add),
      ),
      body: Padding( 
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: 
        ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.reply_all),
              ),
              title: Text(items[index]["name"] ?? "No receivers"),
              subtitle: Text(items[index]["last_message"] ?? "No messages"),
              trailing: Text(items[index]["timestamp"]?.replaceFirst(" ", "\n") ?? ""),
              onTap: () {
                Session.selectedId = items[index]["id"].toString();
                Session.selectedName = items[index]["name"] ?? "No receivers";
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BroadcastPage(),
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
