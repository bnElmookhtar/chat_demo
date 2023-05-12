import 'package:flutter/material.dart';
import 'package:goat/models/broadcast_model.dart';
import 'package:goat/screens/chats/customs/custom_broadcast_card.dart';
import '../customs/select_contact_card.dart';

class BroadCast extends StatefulWidget {
  const BroadCast({Key? key}) : super(key: key);

  @override
  State<BroadCast> createState() => _BroadCast();
}

class _BroadCast extends State<BroadCast> {
  List<BroadcastModel> broadModel = [
    BroadcastModel(broadName: "eslamic", lastMsg: "صل على النبي وتبسم ", time: "any time"),
    BroadcastModel(broadName: "friends ", lastMsg: "their is no message yet", time: "any time"),
    BroadcastModel(broadName: "notes", lastMsg: "صل على النبي وتبسم ", time: "any time"),
    BroadcastModel(broadName: "advices", lastMsg: "صل على النبي وتبسم ", time: "any time"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (builder)=>const SelectContact()));
        },
        child: const Icon(Icons.add),
      ),
     body: ListView.builder(itemBuilder: (context,index)=>CustomBroadcasrCard(broadmodel: broadModel[index]),itemCount: broadModel.length,)
    );
  }
}
