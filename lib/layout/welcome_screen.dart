import 'package:flutter/material.dart';

import '../screens/register/sign_in.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffa4dcff),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(25),bottomStart:Radius.circular(25) ),
        ),
        title: Text(
          "WELCOME IN GOAT CHATS",
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "assets/imgs/welcome.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(bottom: 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60.0),
                  color: Color(0x8c2784e9),
                ),
                height: 60,
                width: 300,
                child: MaterialButton(

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => SignIn(),
                      ),
                    );
                  },
                  child: Text("GET STARTED",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                    color: Colors.white,

                  ),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
