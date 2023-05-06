import 'package:flutter/material.dart';
import 'package:goat/models/groups_model.dart';
import 'package:goat/component/custom_group.dart';
import '../screens/chats/screens/chats.dart';
class SelectGroup extends StatefulWidget {
  const SelectGroup({Key? key}) : super(key: key);

  @override
  State<SelectGroup> createState() => _SelectGroupState();
}

class _SelectGroupState extends State<SelectGroup> {
  List<GroupModel> groups = [
    GroupModel(name: "measure", icon: "icon", lastMsg: "lastMsg", time: "time"),
    GroupModel(name: "usa", icon: "icon", lastMsg: "lastMsg", time: "time"),
    GroupModel(name: "micro", icon: "icon", lastMsg: "lastMsg", time: "time"),
    GroupModel(name: "machines", icon: "icon", lastMsg: "lastMsg", time: "time"),
    GroupModel(name: "systems", icon: "icon", lastMsg: "lastMsg", time: "time"),
    GroupModel(name: "or", icon: "icon", lastMsg: "lastMsg", time: "time"),
    GroupModel(name: "arch", icon: "icon", lastMsg: "lastMsg", time: "time"),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Select Group"),
        actions: [
          Icon(Icons.search_rounded),
        ],
      ),
      body: ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context,index){
            if(index ==0 )
              return BottomCard();
            else if(index ==1)
              return Text("      Groups on GOAT");
            return CustomGroup(groupModel: groups[index], );
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
        onTap: (){
          Navigator.push(context,MaterialPageRoute(builder: (builder)=>Chats()),);
        },
        title: Text(
          "New Group",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          radius: 25.0,
          child: Icon(Icons.group),

        )
    );
  }
}

