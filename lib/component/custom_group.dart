import 'package:flutter/material.dart';
import 'package:goat/models/groups_model.dart';
import 'package:goat/screens/chats/pages/group_page.dart';
class CustomGroup extends StatelessWidget {
  CustomGroup({Key? key,required this.groupModel}) : super(key: key);
  final GroupModel groupModel;
  String userName = "karim";

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){        Navigator.push(context, MaterialPageRoute(builder: (builder)=>GroupPage(groupModel: groupModel,),),);
      },
      child: Column(
        children: [
          ListTile(
            title: Text(groupModel.name),
            subtitle: Text(groupModel.lastMsg),
            leading: CircleAvatar(
              child: Icon(Icons.group),
              radius: 30.0,
            ),
            trailing: Text(groupModel.time),
          )
        ],
      ),
    );

  }
}
