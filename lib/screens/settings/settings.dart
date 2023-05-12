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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              title: Text("user name"),
              leading: const CircleAvatar(
                radius: 30.0,
                child: Icon(Icons.person),
              ),
              onTap: () {},
            ),
            defualtVersticalSizedBox(height: 15.0),
            ListTile(
              title: Text("Delete my account"),
              leading: const CircleAvatar(
                radius: 30.0,
                child: Icon(Icons.delete_forever),
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
              title: Text("Change Phone Number"),
              leading: const CircleAvatar(
                radius: 30.0,
                child: Icon(Icons.phone),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>ChangePhone(),),);
              },
            ),
            defualtVersticalSizedBox(height: 15.0),
            ListTile(
              title: Text("Change User Name"),
              leading: const CircleAvatar(
                radius: 30.0,
                child: Icon(Icons.drive_file_rename_outline_outlined,size: 30,),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>ChangeName(),),);
              },
            ),
            defualtVersticalSizedBox(height: 15.0),
            ListTile(
              title: Text("Help"),
              leading: const CircleAvatar(
                radius: 30.0,
                child: Icon(Icons.help_outline_outlined,size: 30,),
              ),
              onTap: (){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("I cant help you ")));},
            ),
          ],
        ),
      ),
    );
  }
}
