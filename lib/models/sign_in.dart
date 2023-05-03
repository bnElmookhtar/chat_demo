import 'package:flutter/material.dart';
import 'package:goat/component/reusable_component.dart';
import 'package:goat/models/sign_up.dart';
import 'package:goat/styles/colors.dart';

class SignIn extends StatelessWidget {
  var phoneNum = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue_1000,
      appBar: AppBar(
        title: defualtText(
          txt: "WELCOME IN SIGNIN PAGE ",
        ),
        backgroundColor: blk_200,
      ),
      body: SingleChildScrollView(
          child: Padding(        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            defualtVersticalSizedBox(height: 40.0),
            defualtText(
              txt: "SIGNIN",
              fontwit: FontWeight.bold,
              color: wit_300,
            ),
            defualtVersticalSizedBox(height: 40.0),
            defualtTextForm(
              onTap: () {},
              decoration: InputDecoration(
                label: defualtText(
                  txt: "Phone Number",
                  color: wit_300,
                ),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.phone),

              ),
              controller: phoneNum,
              keyboardType: TextInputType.phone,
              onSubmit: (value) {
                phoneNum = value;
              },
            ),
            MaterialButton(
              onPressed: () {
              },
              child: defualtText(txt: "Sign In", color: wit_300),
              color: blk_100,
              minWidth: double.infinity,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                defualtText(
                  txt: "dont have an account ? ",
                  color: wit_300,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (Context) => SignUp(),
                        ));
                  },
                  child: Text("create one"),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
