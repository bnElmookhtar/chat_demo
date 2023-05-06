import 'package:flutter/material.dart';
import 'package:goat/component/select_contact_card.dart';
import 'package:goat/component/custom_user.dart';
import 'package:goat/models/chats_model.dart';
class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<ChatModel> chats =[
    ChatModel(name: "karim", icon: "icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "mohamed", icon: "Icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "youssef", icon: "Icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "ali", icon: "icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "nany", icon: "Icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "taha", icon: "Icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "awis", icon: "icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "lamy", icon: "Icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "radwa", icon: "Icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "karim", icon: "icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "mohamed", icon: "Icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "youssef", icon: "Icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "ali", icon: "icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "nany", icon: "Icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "taha", icon: "Icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "awis", icon: "icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "lamy", icon: "Icon", lastMsg: "lastMsg", time: "time"),
    ChatModel(name: "radwa", icon: "Icon", lastMsg: "lastMsg", time: "time"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (builder)=>SelectContact()));
        },
        child: const Icon(Icons.message),
      ),
      body: ListView.builder(itemBuilder: (context,index)=>CustomUser(chatModel: chats[index],),itemCount: chats.length,)
    );
  }
}
