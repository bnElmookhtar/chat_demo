import 'package:flutter/material.dart';
import 'package:goat/screens/register/sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
      home: SignIn(),
      debugShowCheckedModeBanner:false,
    );
  }
}
