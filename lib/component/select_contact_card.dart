import 'package:flutter/material.dart';

import '../models/chats_model.dart';
import 'custom_user.dart';
class SelectContact extends StatefulWidget {
  const SelectContact({Key? key}) : super(key: key);

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
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
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Select Contact"),
        actions: [
          Icon(Icons.search_rounded),
        ],
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context,index){
          if(index ==0 )
            return BottomCard();
          else if(index ==1)
            return Text("      Contacts on GOAT");
          return CustomUser(chatModel: chats[index],);

        }


      ),
    );
  }
}
class BottomCard extends StatefulWidget {
  const BottomCard({Key? key}) : super(key: key);

  @override
  State<BottomCard> createState() => _BottomCardState();
}

class _BottomCardState extends State<BottomCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){},
      title: Text(
        "New Contact",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: CircleAvatar(

        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        radius: 25.0,
        child: Icon(Icons.person),

      )
    );
  }
}

