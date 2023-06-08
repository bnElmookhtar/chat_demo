import 'package:flutter/material.dart';
import 'package:goat/screens/chats/pages/group_page.dart';
import 'package:goat/screens/chats/pages/yes_no_dialog.dart';
import 'package:goat/screens/register/sign_in.dart';
import 'package:goat/screens/register/sign_up.dart';
import 'package:goat/server/session.dart';
import 'package:goat/server/request.dart';

class GroupSettingsPage extends StatefulWidget {
  const GroupSettingsPage({Key? key}) : super(key: key);
  @override
  State<GroupSettingsPage> createState() => _GroupSettingsPageState();
}

class _GroupSettingsPageState extends State<GroupSettingsPage> {
  var nameControler = TextEditingController();
  // var items = [];

  @override
  void initState() {
    super.initState();
    nameControler.addListener(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Group Settings"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField( 
                keyboardType: TextInputType.text,
                maxLines: 1,
                maxLength: 29,
                controller: nameControler,
                decoration: InputDecoration(
                  hintText: Session.selectedName.toString(),
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: (){
                  final name = nameControler.text.toString().trim().replaceAll("'", "''");
                  request(context, 
                  {"q":"update_group_name", "selected_id":Session.selectedId, "name":name.toString()}).then((ls){ 
                    if (ls == null) {
                      return;
                    }
                    Session.selectedName = name.toString();
                    nameControler.clear();
                    setState((){});});

                }, 
                child: Text("Update"),
              ),
              SizedBox(height: 100,),
              Center( 
                child: OutlinedButton(
                  onPressed: (){
                   
                    showConfirmationDialog(context, "Do you want delete this group forever?",(){
                    request(context, {"q":"delete_group", "selected_id":Session.selectedId}).then((ls)  {
                      if (ls==null) {
                        return;
                      }
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  });

                  }, 
                  child: Text("Delete group"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
