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
        title:Column(
          children: const [
            Text("Create Account"),
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                maxLength: 29,
                maxLines: 1,
              ),
              SizedBox(height: 30.0),
              TextFormField(
                onTap: () {},
                maxLength: 11,
                maxLines: 1,
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
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  final String name_ = name.text.trim();
                  final String phone = phoneNum.text.trim();
                  request(context, {
                    "q": "sign_up", 
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
                child: defualtText(txt: "CREATE" ),
              ),
            ],
          ),
        )),
    );
  }
}
