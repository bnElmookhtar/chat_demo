import 'package:flutter/material.dart';
import 'package:goat/screens/chats/screens/chats.dart';
class NewGroupParticipate extends StatelessWidget {
  const NewGroupParticipate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select group paricibations "),
      ),
      body: Chats(),
    );
  }
}
