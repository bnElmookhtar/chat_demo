import 'package:flutter/material.dart';
import 'package:goat/models/groups_model.dart';
import 'package:goat/screens/chats/customs/custom_group.dart';
import 'package:goat/screens/chats/group_particibate.dart';
class SelectGroup extends StatefulWidget {
  const SelectGroup({Key? key}) : super(key: key);

  @override
  State<SelectGroup> createState() => _SelectGroupState();
}

class _SelectGroupState extends State<SelectGroup> {
  List<GroupModel> groups = [
    GroupModel(name: "measure", icon: "icon", lastMsg: "lastMsg", time: "time"),
    GroupModel(name: "usa", icon: "icon", lastMsg: "lastMsg", time: "time"),
    GroupModel(name: "micro", icon: "icon", lastMsg: "lastMsg", time: "time"),
    GroupModel(name: "machines", icon: "icon", lastMsg: "lastMsg", time: "time"),
    GroupModel(name: "systems", icon: "icon", lastMsg: "lastMsg", time: "time"),
    GroupModel(name: "or", icon: "icon", lastMsg: "lastMsg", time: "time"),
    GroupModel(name: "arch", icon: "icon", lastMsg: "lastMsg", time: "time"),

  ];
  var searchQueryController = TextEditingController();
  bool isSearching = false;
  String searchQuery = "Search query";
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          leading: Container(),
          title: isSearching ? buildSearchField() : const Text("Select Group"),
          actions: isSearching ? buildActions() : [
            ElevatedButton(
              onPressed: (){
                  startSearch();
              },
              child: Icon(Icons.search,size: 30.0,),
            ),
          ],
      ),
      body: ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context,index){
            if(index ==0 ){
              return const BottomCard();
            }

            else if(index ==1)
              {
                return const Text("      Groups on GOAT");
              }
            return CustomGroup(groupModel: groups[index], );
          }
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
     // onChanged: (query) => updateSearchQuery(query),
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
class BottomCard extends StatefulWidget {
  const BottomCard({Key? key}) : super(key: key);

  @override
  State<BottomCard> createState() => _BottomCardState();
}

class _BottomCardState extends State<BottomCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: (){
          Navigator.push(context,MaterialPageRoute(builder: (builder)=>const NewGroupParticipate()),);
        },
        title: const Text(
          "New Group",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          radius: 25.0,
          child: Icon(Icons.group),
        )
    );
  }

}

