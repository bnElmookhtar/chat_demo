import 'package:flutter/material.dart';
import 'package:goat/screens/chats/broadcasts.dart';
import 'package:goat/screens/chats/chats.dart';
import 'package:goat/screens/chats/groups.dart';
import 'package:goat/screens/register/sign_in.dart';
import 'package:goat/screens/settings/account_settings.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  TabController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this,initialIndex: 1);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Container(),
        title: const Text("GOAT Messenger"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle_outlined),
            color: Theme.of(context).secondaryHeaderColor,
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => AccountSettingsPage(),
                ),
              );
            }),
        ],
        bottom: TabBar(
          controller: _controller,
          tabs: const [
            Tab(text: "BROADCASTS",),
            Tab(text: "CHATS"),
            Tab(text: "GROUPS"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: const [
          Broadcasts(),
          Chats(),
          Groups(),
        ],
      ),
    );
  }
}
