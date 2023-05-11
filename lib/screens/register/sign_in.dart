import 'package:flutter/material.dart';
import 'package:goat/layout/home_screen.dart';
import 'package:goat/screens//register/sign_up.dart';
import 'package:goat/component/reusable_component.dart';
import 'package:goat/server/request.dart';

class SignIn extends StatelessWidget {
  var phoneNum = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(25),bottomStart:Radius.circular(25) ),
        ),
        title: const Text("WELCOME IN SIGNIN PAGE "),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            defualtVersticalSizedBox(height: 40.0),
            defualtText(
              txt: "SIGNIN",
              fontwit: FontWeight.bold,
            ),
            defualtVersticalSizedBox(height: 40.0),
            TextFormField(
              onTap: () {},
              decoration: const InputDecoration(
                label: Text("Phone Number"),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              controller: phoneNum,
              keyboardType: TextInputType.phone,
              onFieldSubmitted: (value) {},
              ),
              MaterialButton(
                onPressed: () async {
                  final String phone = phoneNum.text.trim();
                  request({
                    "q": "login", 
                    "phone": phone,
                  }).then((ls) {
                    if (ls == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not connect')),
                      );
                    } else if (ls[0].keys.contains("error")) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(ls[0]["error"])),
                        );
                      } else {
                        final userId = ls[0]["id"];
                        Navigator.push(
                          context, MaterialPageRoute(builder: (builder) => const HomeScreen()));
                      }
                  });
                },
                color: Colors.blue,
                minWidth: double.infinity,
                child: const Text("Sign In"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("dont have an account ? "),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ));
                  },
                  child: const Text("create one"),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
