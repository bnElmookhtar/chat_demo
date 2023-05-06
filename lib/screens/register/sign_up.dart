import 'package:flutter/material.dart';
import 'package:goat/component/reusable_component.dart';
import 'package:goat/screens//register/sign_in.dart';
class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {
  var name = TextEditingController(),
      phoneNum = TextEditingController(),
      confirmPhone = TextEditingController();
  var nameValdate ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(25),bottomStart:Radius.circular(25) ),
        ),
        title:Text("WELCOME IN SIGNUP PAGE "),
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
                prefixIcon: const Icon(Icons.email),
              ),
              validator:(nameValiate){},
              controller: name,
              keyboardType: TextInputType.text,
              onFieldSubmitted: (value){},
            ),
            defualtVersticalSizedBox(height: 40.0),
            TextFormField(
              onTap: () {},
              decoration: InputDecoration(
                label:const Text("Phone Number"),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.phone),
              ),
              validator:(phoneValiate){},
              controller: phoneNum,
              keyboardType: TextInputType.phone,
              onFieldSubmitted: (value){phoneNum = value as TextEditingController;print(phoneNum.toString());},
            ),
            defualtVersticalSizedBox(height: 40.0),
            TextFormField(
              onTap: () {},
              decoration: InputDecoration(
                label:const Text("Confirm Phone Number"),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.phone),
              ),
              validator:(confirmPhoneValiate){},
              controller: confirmPhone,
              keyboardType: TextInputType.phone,
              onFieldSubmitted:(value){},
            ),
            MaterialButton(
              onPressed: () {
                print(name.text);
                print(phoneNum.text);
              },
              child: defualtText(txt: "REGISTER" ),
              color: Colors.blue,
              minWidth: double.infinity,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                defualtText(
                  txt: "have an account ? ",

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
