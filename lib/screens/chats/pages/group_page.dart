import 'package:flutter/material.dart';
import 'package:goat/models/groups_model.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key, required this.groupModel}) : super(key: key);
  final GroupModel groupModel;
  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  var newMessage = TextEditingController();
  var searchTerm = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newMessage.addListener(() { });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupModel.name),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        controller: newMessage,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.blue, width: 1.0),
                          ),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 2.0, color: Colors.blue),
                          ),
                          hintText: 'Enter your new message',
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.camera_alt),
                          ),
                        ),
                        onSubmitted: (value) {
                          newMessage = value as TextEditingController;

                        },
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.blue),
                          onPressed: () {
                            print(newMessage.text);
                          },
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
