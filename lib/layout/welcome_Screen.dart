import 'package:flutter/material.dart';
import 'package:goat/component/reusable_component.dart';
import 'package:goat/models/sign_in.dart';
import 'package:goat/styles/colors.dart';

import '../models/sign_up.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: blue_1000,
      appBar:AppBar(
        title: defualtText(txt: "GOAT",fontwit: FontWeight.bold,),
        backgroundColor: blk_200,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            child: Image.asset('assets/imgs/app_logo.png'),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 50.0,end: 50.0),
            child:  Column(
              children: [
                Row(
                  children: [
                    defualtText(txt: "already have an account ?",fontwit: FontWeight.w300,color: wit_300),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder:(contex)=>SignIn(),),);
                    }, child: defualtText(txt: "sign in",fontwit: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    defualtText(txt: "or you can create one by clicking ",fontwit: FontWeight.w300,color: wit_300),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder:(contex)=>SignUp(),),);
                    }, child: defualtText(txt: "sign up",fontwit: FontWeight.bold))
                  ],
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}
