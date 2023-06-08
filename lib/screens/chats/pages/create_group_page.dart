import 'dart:async';
import 'package:flutter/material.dart';
import 'package:goat/screens/chats/pages/group_page.dart';
import 'package:goat/server/session.dart';
import 'package:goat/server/request.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);
  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  var nameControler = TextEditingController();
  var items = [];

  late Timer timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void refresh() {
     if (items.isEmpty) {
      request(context, 
      {"q":"contacts", "user_id": Session.userId}
      ).then((ls) { setState((){ items = ls; });});
    }
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Create Group"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20), 
          child: Column(
            children: [
              TextField( 
                keyboardType: TextInputType.text,
                maxLines: 1,
                maxLength: 29,
                controller: nameControler,
                decoration: InputDecoration(
                  hintText: 'Group Name',
                ),
              ),
              SizedBox(height: 30,),
              Text("Selected ${items.where((element) => element["choosen"] == true).length} users"),
              SizedBox(height: 20,),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(items[index]["name"].toString().substring(0, 2)),
                      ),
                      title: Text(items[index]["name"]),
                      subtitle: Text(items[index]["phone"]),
                      trailing: Icon(
                        items[index]["choosen"] == true ? Icons.check_box : Icons.check_box_outline_blank,
                        color: items[index]["choosen"] == true ? Theme.of(context).colorScheme.primary : Colors.grey,
                      ),
                      onTap: () {
                        items[index]["choosen"] = items[index]["choosen"] == true ? false : true;
                        setState(() { });
                      },
                    );
                  },
                ),

              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: (){
                  final name = nameControler.text.toString().trim().replaceAll("'", "''");
                  String ids = "";
                  for (var item in items) {
                    if (item["choosen"] == true) {
                      ids += "${item["id"]} "; 
                    }
                  }
                  request(context, {
                    "q": "create_group",
                    "name": name,
                    "user_id": Session.userId,
                    "ids": ids,
                  }).then((ls) {
                    if (ls != null) {
                      Session.selectedId = ls[0]["id"].toString();
                      Session.selectedName = ls[0]["name"];
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupPage(),
                        ),
                      );
                    }
                  });
                }, 
                child: Text("Create"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
