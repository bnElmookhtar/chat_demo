import 'package:flutter/material.dart';
import 'package:goat/screens/chats/pages/group_page.dart';
import 'package:goat/screens/register/sign_in.dart';
import 'package:goat/screens/register/sign_up.dart';
import 'package:goat/server/session.dart';
import 'package:goat/server/request.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);
  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  var nameControler = TextEditingController();
  var phoneControler = TextEditingController();
  var items = [];

  @override
  void initState() {
    super.initState();
    request(context, 
    {"q":"user", "user_id": Session.userId}
    ).then((ls) { setState((){ items = ls; });});
    nameControler.addListener(() { });
    phoneControler.addListener(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Account Settings"),
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
                  hintText: '${items[0]["name"]}',
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: (){
                  final name = nameControler.text.toString().trim().replaceAll("'", "''");
                  request(context, 
                  {"q":"update_name", "user_id":Session.userId, "name":name.toString()}).then((ls){ 
                    if (ls == null) {
                      return;
                    }
                    nameControler.clear();
                    setState((){});});

                }, 
                child: Text("Update"),
              ),
              SizedBox(height: 40,),
              TextField( 
                keyboardType: TextInputType.number,
                maxLines: 1,
                maxLength: 11,
                controller: phoneControler,
                decoration: InputDecoration(
                  hintText: '${items[0]["phone"]}',
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: (){
                  final phone = phoneControler.text.toString().trim().replaceAll("'", "''");
                  request(context, 
                  {"q":"update_phone", "user_id":Session.userId, "phone":phone.toString()}).then((ls){ 
                    if (ls == null) {
                      return;
                    }
                    phoneControler.clear();
                    setState((){});
                  });
                }, 
                child: Text("Update"),
              ),
              SizedBox(height: 100,),
              Center( 
                child: OutlinedButton(
                  onPressed: (){
                    request(context, {"q":"delete_user", "user_id":Session.userId}).then((ls)  {
                      if (ls==null) {
                        return;
                      }
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ),
                      );
                    });
                  }, 
                  child: Text("Delete my account"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
