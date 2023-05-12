import 'package:flutter/material.dart';
import 'package:goat/models/broadcast_model.dart';
import 'package:goat/screens/chats/pages/broadcast_bage.dart';

class CustomBroadcasrCard extends StatelessWidget {
  const CustomBroadcasrCard({Key? key,required this.broadmodel}) : super(key: key);
  final BroadcastModel broadmodel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (builder)=>BroadcastPAge(broadcastModel: broadmodel),),);
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
