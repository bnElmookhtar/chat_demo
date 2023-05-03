import 'package:flutter/material.dart';
import 'package:goat/component/reusable_component.dart';
import 'package:goat/models/sign_in.dart';
import 'package:goat/styles/colors.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var name = TextEditingController(),
      phoneNum = TextEditingController(),
      confirmPhone = TextEditingController();
  Color wit = wit_300;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue_1000,
      appBar: AppBar(
        title: defualtText(
          txt: "WELCOME IN SIGNUP PAGE ",
        ),
        backgroundColor: blk_200,
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
              color: wit,
            ),
            defualtVersticalSizedBox(height: 40.0),
            defualtTextForm(
                onTap: () {},
                decoration: InputDecoration(
                  label: defualtText(txt: "Name",color: wit),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                ),
                controller: name,
                keyboardType: TextInputType.text,
                onSubmit: (value) {
                  name = value;
                }),
            defualtVersticalSizedBox(height: 40.0),
            defualtTextForm(
              onTap: () {},
              decoration: InputDecoration(
                label: defualtText(
                  txt: "Phone Number",
                  color: wit,
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
            defualtVersticalSizedBox(height: 40.0),
            defualtTextForm(
                onTap: () {},
                decoration: InputDecoration(
                    label: defualtText(
                      txt: "Confirm Phone Number",
                      color: wit,
                    ),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.phone)),
                controller: confirmPhone,
                keyboardType: TextInputType.phone,
                onSubmit: (value) {
                  confirmPhone = value;
                }),
            MaterialButton(
              onPressed: () {
                print(name.text);
              },
              child: defualtText(txt: "REGISTER", color: wit),
              color: blk_100,
              minWidth: double.infinity,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                defualtText(
                  txt: "have an account ? ",
                  color: wit,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (Context) => SignIn(),
                        ));
                  },
                  child: Text("sign in "),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
