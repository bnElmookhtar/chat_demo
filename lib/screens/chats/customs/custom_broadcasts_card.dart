import 'package:flutter/material.dart';
import 'package:goat/models/broadcasts_model.dart';
import 'package:goat/screens/chats/pages/broadcasts_page.dart';

class CustomBroadcastsCard extends StatelessWidget {
  const CustomBroadcastsCard({Key? key,required this.broadmodel}) : super(key: key);
  final BroadcastsModel broadmodel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (builder)=>BroadcastsPage(broadcastModel: broadmodel),),);
      },
      child: Column(
        children: [
          ListTile(
            title: Text(broadmodel.broadName),
            subtitle: Text(broadmodel.lastMsg),
            leading: const CircleAvatar(
              radius: 30.0,
              child: Icon(Icons.group_work),
            ),
            trailing: Text(broadmodel.time),

          )
        ],
      ),
    );
  }
}
