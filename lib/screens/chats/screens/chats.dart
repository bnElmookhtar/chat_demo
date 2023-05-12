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
  List<ChatModel> chats =[];
  @override
  Widget build(BuildContext context) {
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
