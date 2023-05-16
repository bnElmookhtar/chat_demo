import 'package:flutter/material.dart';
import 'package:goat/models/broadcasts_model.dart';

class Broadcasts extends StatefulWidget {
  final String? userId ;
  const Broadcasts({Key? key,this.userId}) : super(key: key);

  @override
  State<Broadcasts> createState() => _Broadcasts();
}

class _Broadcasts extends State<Broadcasts> {
  List<BroadcastsModel> broadModel = [
    BroadcastsModel(broadName: "eslamic", lastMsg: "صل على النبي وتبسم ", time: "any time"),
    BroadcastsModel(broadName: "friends ", lastMsg: "their is no message yet", time: "any time"),
    BroadcastsModel(broadName: "notes", lastMsg: "صل على النبي وتبسم ", time: "any time"),
    BroadcastsModel(broadName: "advices", lastMsg: "صل على النبي وتبسم ", time: "any time"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // Navigator.push(context,MaterialPageRoute(builder: (builder)=>const SelectContact()));
        },
        child: const Icon(Icons.add),
      ),
     // body: ListView.builder(itemBuilder: (context,index)=>CustomBroadcastsCard(broadmodel: broadModel[index]),itemCount: broadModel.length,)
    );
  }
}
