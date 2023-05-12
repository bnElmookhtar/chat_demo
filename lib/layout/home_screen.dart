import 'package:flutter/material.dart';
import 'package:goat/screens/chats/screens/brouadcast.dart';
import 'package:goat/screens/chats/screens/chats.dart';
import 'package:goat/screens/chats/screens/groups.dart';
import 'package:goat/styles/colors.dart';
import '../screens/settings/settings.dart';
class HomeScreen extends StatefulWidget {
  final String? userId ;
 const HomeScreen({Key? key,this.userId}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  TabController? _controller; 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 3, vsync: this,initialIndex: 1);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("GOAT"),
        actions: [
          IconButton(onPressed: (){}, icon:const Icon(Icons.search_rounded,size: 30.0,),),
          PopupMenuButton<String>(
           onSelected: (value)=>debugPrint(value),
             itemBuilder: (itemBuilder)=>[
                PopupMenuItem(value: "settings",child:  Text("settings"), onTap: (){
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Settings();
                        },
                      ),
                    );
                  });
                }),
              const PopupMenuItem(value: "started message",child: Text("started messages"),),
         ]),
        ],
        bottom:   TabBar(
          controller: _controller,
          indicatorColor: blk_200,
          labelStyle:  const TextStyle(fontSize: 20.0),
          tabs: const [
            Tab(text: "Broadcast",),
            Tab(text: "CHATS"),
            Tab(text: "GROUPS"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: const [
          BroadCast(userId: "id"),
          Chats(userId: "id"),
          Groups(userId: "id"),
        ],
      ),
    );
  }
}
