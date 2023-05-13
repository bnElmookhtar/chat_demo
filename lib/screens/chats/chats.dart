import 'package:flutter/material.dart';
import 'package:goat/screens/chats/customs/select_contact_card.dart';
import 'package:goat/screens/chats/customs/custom_user.dart';
import 'package:goat/models/chats_model.dart';
class Chats extends StatefulWidget {
  final String? userId ;
  const Chats({Key? key,this.userId}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<Map<String, String>> chatsData = [
  {"id": "?", "name": "Ahmed Abdullah", "last_message": "Welcome back!", "timestamp": "May 14 02:01 AM" },
  {"id": "?", "name": "Ahmed Abdullah", "last_message": "Welcome back!", "timestamp": "May 14 02:01 AM" },
  ];
  List<ChatModel> chats = [];
// [
//     ChatModel(name: "karim", icon: "icon", lastMsg: "lastMsg", time: "time"),
//     ChatModel(name: "mohamed", icon: "Icon", lastMsg: "lastMsg", time: "time"),
//     ChatModel(name: "youssef", icon: "Icon", lastMsg: "lastMsg", time: "time"),
//     ChatModel(name: "ali", icon: "icon", lastMsg: "lastMsg", time: "time"),
//     ChatModel(name: "nany", icon: "Icon", lastMsg: "lastMsg", time: "time"),
//     ChatModel(name: "taha", icon: "Icon", lastMsg: "lastMsg", time: "time"),
//     ChatModel(name: "awis", icon: "icon", lastMsg: "lastMsg", time: "time"),
//     ChatModel(name: "lamy", icon: "Icon", lastMsg: "lastMsg", time: "time"),
//     ChatModel(name: "radwa", icon: "Icon", lastMsg: "lastMsg", time: "time"),
//   ];
  @override
  Widget build(BuildContext context) {
    for (final i in chatsData) {
    chats.add(ChatModel(id: i["id"], name: i["name"], 
      last_message: i["last_message"], timestamp: i["timestamp"]));
  }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (builder)=>const SelectContact()));
        },
        child: const Icon(Icons.message),
      ),
      body: ListView.builder(itemBuilder: (context,index)=>CustomUser(chatModel: chats[index],),itemCount: chats.length,)
    );
  }


  
}
