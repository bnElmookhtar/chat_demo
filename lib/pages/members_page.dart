import 'package:flutter/material.dart';
import 'package:goat/data/data.dart';
import 'package:goat/data/session.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({Key? key}) : super(key: key);
  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  var _members = [];
  var isUserAdmin = false;

  void _refresh() {
    Data.getSettings().then((ls) {
      if (ls[0].containsKey("m")) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        return;
      }
      _members = ls;
      if (Data.pageType == PageType.group) {
        for (final row in _members) {
          if (row["id"] == Session.userId &&
              row["is_admin"].toString() == '1') {
            isUserAdmin = true;
            break;
          }
        }
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Data.pageType == PageType.group
            ? "Group Members"
            : "Broadcast Receivers"),
      ),
      body: (_members.isNotEmpty && _members.first.containsKey("m"))
          ? Center(
              child: Text(_members.first["m"]),
            )
          : Column(
              children: [
                Expanded(
                  child: _members.isEmpty
                      ? const Center(child: Text("No contacts"))
                      : ListView.builder(
                          itemCount: _members.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(50),
                                foregroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: Text(_members[index]["name"]
                                    .toString()
                                    .substring(0, 2)),
                              ),
                              title: Text(_members[index]["name"]),
                              subtitle: Text(_members[index]["phone"]),
                              trailing: _members[index]["is_admin"].toString() == '1'
                                  ? Icon(
                                      Icons.stars_outlined,
                                      color: Colors.orange[900],
                                    )
                                  : const SizedBox(),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
