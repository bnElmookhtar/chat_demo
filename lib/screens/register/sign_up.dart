import 'package:flutter/material.dart';
import 'package:goat/component/reusable_component.dart';
import 'package:goat/server/request.dart';
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
  State<SignUp> createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {
  var name = TextEditingController(),
      phoneNum = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(25),bottomStart:Radius.circular(25) ),
        ),
        title:Column(
          children: const [
            Text("WELCOME IN SIGNUP PAGE "),
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            defualtVersticalSizedBox(height: 40.0),
            defualtText(
              txt: "SIGN UP",
              fontwit: FontWeight.bold,
            ),
            defualtVersticalSizedBox(height: 40.0),
            TextFormField(
              onTap: () {},
              decoration: InputDecoration(
                label: defualtText(txt: "Name",),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
              validator:(nameValiate){if(nameValiate.toString().isEmpty){return "name must be submited ";}},
              controller: name,
              keyboardType: TextInputType.text,
              onFieldSubmitted: (value){},
            ),
            defualtVersticalSizedBox(height: 40.0),
            TextFormField(
              onTap: () {},
              decoration: const InputDecoration(
                label:Text("Phone Number"),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              validator:(phoneValiate){},
              controller: phoneNum,
              keyboardType: TextInputType.phone,
              onFieldSubmitted: (value){phoneNum = value as TextEditingController;debugPrint(phoneNum.toString());},
            ),
            defualtVersticalSizedBox(height: 40.0),
            MaterialButton(
              onPressed: () {
                  final String name_ = name.text.trim();
                  final String phone = phoneNum.text.trim();
                  request(context, {
                    "q": "register", 
                    "phone": phone,
                    "name": name_,
                  }).then((ls) {
                    if (ls != null) {
                        final userId = ls[0]["id"];
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Created a new account")),
                        );
                        Navigator.pop(context);
                      }
                  });
              },
              color: Colors.blue,
              minWidth: double.infinity,
              child: defualtText(txt: "REGISTER" ),
            ),
          ],
        ),
      )),
    );
  }
}
