import 'package:flutter/material.dart';
import 'package:goat/models/chats_model.dart';
import 'package:goat/screens/chats/pages/chat_page.dart';
class CustomUser extends StatelessWidget {
   CustomUser({Key? key,required this.chatModel}) : super(key: key);
  final ChatModel chatModel;
  String userName = "karim";

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (builder)=>ChatPage(chatModel: chatModel,),),);
      },
      child: Column(
        children: [
          ListTile(
            title: Text(chatModel.name),
            subtitle: Text(chatModel.lastMsg),
            leading: Icon(Icons.person),
            trailing: Text(chatModel.time),

          )
        ],
      ),
    );

  }
}
