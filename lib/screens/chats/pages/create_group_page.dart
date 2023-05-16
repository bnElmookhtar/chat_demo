import 'package:flutter/material.dart';
import 'package:goat/server/session.dart';
import 'package:goat/server/request.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);
  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  var nameControler = TextEditingController();
  var items = [
  ];

  List<String> _fruitList = ['Apple', 'Banana', 'Orange', 'Mango'];
  List<String> _selectedFruits = [];

  @override
  void initState() {
    super.initState();
    nameControler.addListener(() { });
  }

  final ScrollController _scrollController = ScrollController();
  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Create Group"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20), 
          child: Column(
            children: [
              TextField( 
                keyboardType: TextInputType.text,
                maxLines: 1,
                maxLength: 29,
                controller: nameControler,
                decoration: InputDecoration(
                  hintText: 'Group Name',
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: (){
                  // final name = nameControler.text.toString().trim().replaceAll("'", "''");
                }, 
                child: Text("Create"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
