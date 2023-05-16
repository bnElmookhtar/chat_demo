import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goat/layout/home_screen.dart';
import 'package:goat/screens//register/sign_up.dart';
import 'package:goat/component/reusable_component.dart';
import 'package:goat/server/request.dart';
import 'package:goat/server/session.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var phoneNum = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.login_outlined, size: 30, color: Colors.grey,),
              SizedBox(height: 30,),
              Text("Welcome on"),
              Text(
                "GOAT Messanger", 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 80),
              TextFormField(
                onTap: () {},
                decoration: const InputDecoration(
                  label: Text("Phone Number"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),

                controller: phoneNum,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (value) {},
                maxLength: 11,
                maxLines: 1,
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                onPressed: (){
                  final String phone = phoneNum.text.trim();
                  request(context, {
                    "q": "sign_in",
                    "phone": phone,
                  }).then((ls) {
                    if (ls != null) {
                      Session.userId = ls[0]["id"].toString();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => HomeScreen()));
                    }
                  });
                },
                child: const Text("LOGIN"),
              ),
              SizedBox(height: 90,),
              Text("Haven't registered yet?"),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUp(),
                    ));
                },
                child: const Text("Create Account"),
              ),
            ],
          ),
        )),
    );
  }
}
