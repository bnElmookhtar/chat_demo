import 'package:flutter/material.dart';
class Search extends StatefulWidget {

 const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}
class _SearchState extends State<Search> {
 late TextEditingController searchQueryController;
bool isSearching = false;
String searchQuery = "Search query";
  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: isSearching ? const BackButton() : Container(),
        title:buildSearchField() ,
        actions: buildActions(),
      );
  }
    Widget buildSearchField() {
      return TextField(
        controller: searchQueryController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Search Data...",
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
      });
    }

}
