import 'package:flutter/material.dart';
import 'package:goat/component/select_group_card.dart';
class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (builder)=>SelectGroup()));
        },
        child: Icon(Icons.add_box),
      ),
    );
  }
}
