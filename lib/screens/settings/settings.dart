import 'package:flutter/material.dart';
import 'package:goat/component/reusable_component.dart';
import 'package:goat/layout/welcome_screen.dart';
import 'package:goat/screens/settings/change_name.dart';
import 'package:goat/screens/settings/change_phone.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            defualtVersticalSizedBox(height: 15.0),
            ListTile(
              title: Text("Change Phone Number"),
              leading: const CircleAvatar(
                radius: 30.0,
                child: Icon(Icons.phone_outlined),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>ChangePhone(),),);
              },
            ),
            defualtVersticalSizedBox(height: 15.0),
            ListTile(
              title: Text("Change my name"),
              leading: const CircleAvatar(
                radius: 30.0,
                child: Icon(Icons.person_outlined,size: 30,),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>ChangeName(),),);
              },
            ),
            defualtVersticalSizedBox(height: 15.0),
            ListTile(
              title: Text("Delete my account"),
              leading: const CircleAvatar(
                radius: 30.0,
                child: Icon(Icons.delete_forever_outlined),
              ),
              onTap: () {
                //sql function to delete account without any warning
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (builder)=>WelcomeScreen(),),
                );
              },
            ),
            defualtVersticalSizedBox(height: 15.0),
            ListTile(
              title: Text("About GOAT messenger"),
              leading: const CircleAvatar(
                radius: 30.0,
                child: Icon(Icons.info_outlined,size: 30,),
              ),
              onTap: (){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("I cant help you ")));},
            ),
          ],
        ),
      ),
    );
  }
}
