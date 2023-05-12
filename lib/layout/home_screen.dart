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
  var searchQueryController = TextEditingController();
  bool isSearching = false;
  String searchQuery = "Search query";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 3, vsync: this,initialIndex: 1);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        leading: Container(),
        title: isSearching ? buildSearchField() : const Text("GOAT"),
        actions: isSearching ? buildActions() : [
          IconButton(onPressed: () {
            setState(() {
              startSearch();
            });
          },
            icon: const Icon(Icons.search_rounded, size: 30.0,),),
          PopupMenuButton<String>(
              onSelected: (value) => debugPrint(value),
              itemBuilder: (itemBuilder) =>
              [
                PopupMenuItem(
                    value: "settings", child: Text("settings"), onTap: () {
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
                const PopupMenuItem(
                  value: "started message", child: Text("started messages"),),
              ]),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: blk_200,
          labelStyle: const TextStyle(fontSize: 20.0),
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
  Widget buildSearchField() {
    return TextField(
      controller: searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search for chat...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }
  List<Widget> buildActions() {
    if (isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (searchQueryController == null ||
                searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: startSearch,
      ),
    ];
  }
  void startSearch() {
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: startSearch),);
    setState(() {
      isSearching = true;
    });
  }
  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }
  void stopSearching() {
    clearSearchQuery();

    setState(() {
      isSearching = false;
    });
  }
  void clearSearchQuery() {
    setState(() {
      searchQueryController.clear();
      updateSearchQuery("");
      isSearching = false;
    });
  }
}
