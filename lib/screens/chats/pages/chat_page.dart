import 'package:flutter/material.dart';
import 'package:goat/server/session.dart';
import 'package:goat/server/request.dart';
import 'package:goat/screens/chats/pages/yes_no_dialog.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var newMessage = TextEditingController();
  var items = [
  ];

  void refresh(){
    request(context, 
    {"q":"chat_page", "user_id": Session.userId, "selected_id": Session.selectedId}
    ).then((ls) { setState((){ if (ls != null) items = ls; });});

    request(context, 
    {"q":"is_blocker", "selected_id": Session.selectedId, "user_id": Session.userId}
    ).then((ls) { setState((){ Session.isBlocker = ls[0]["is_blocker"].toString(); }); });


    request(context, 
    {"q":"is_blocked", "selected_id": Session.selectedId, "user_id": Session.userId}
    ).then((ls) { setState((){ Session.isBlocked = ls[0]["is_blocked"].toString(); }); });

  }

  @override
  void initState() {
    super.initState();
    newMessage.addListener(() { });
    refresh();
  }

  final ScrollController _scrollController = ScrollController();
  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, (){ _scrollToEnd(); });
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(Session.selectedName),
        actions: [
          Session.isBlocked == "0" ? 
          IconButton(onPressed: (){
            showConfirmationDialog(context, "Do you want block ${Session.selectedName}?", (){
              request(context, {
                "q": "blocks_user",
                "user_id": Session.userId,
                "selected_id": Session.selectedId,
              }).then((ls) {Navigator.pop(context);});
            });
          }, icon: Icon(Icons.block_outlined)) : 
                    IconButton(onPressed: (){
            showConfirmationDialog(context, "Do you want unblock ${Session.selectedName}?", (){
              request(context, {
                "q": "unblocks_user",
                "user_id": Session.userId,
                "selected_id": Session.selectedId,
              }).then((ls) {Navigator.pop(context);});
            });
          }, icon: Icon(Icons.block_outlined)),

          IconButton(onPressed: (){
            showConfirmationDialog(context, "Do you want delete this conversation forever?", (){
              request(context, {
                "q": "delete_chat",
                "user_id": Session.userId,
                "selected_id": Session.selectedId,
              }).then((ls) {Navigator.pop(context);});
            });
          }, icon: Icon(Icons.delete_outlined)),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  bool isLeft = items[index]["sender_id"].toString() == Session.userId;
                  return Container( 
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: Column( 
                      crossAxisAlignment: isLeft ? CrossAxisAlignment.start:CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(items[index]["text"]??""),
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.all(5), 
                          child: Text(
                          items[index]["timestamp"].toString().replaceFirst(" ", "\n")??"",
                          style: TextStyle(fontSize: 10),
                          textAlign: isLeft ? TextAlign.left : TextAlign.right,
                        ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 0,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(5), 
                child: Session.isBlocker == "1" ? Text("This conversation is blocked by ${Session.selectedName}") :
                        Session.isBlocked == "1" ? Text("This conversation is blocked by you") :
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  minLines: 1,
                  controller: newMessage,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0,),
                    ),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 2.0, color: Theme.of(context).colorScheme.primary),
                    ),
                    hintText: 'Enter your new message',
                    suffixIcon: IconButton(
                      onPressed: (){
                        final message = newMessage.text.toString().trim().replaceAll("'", "''");
                        if (message.isEmpty) {
                          return;
                        }
                        newMessage.clear();
                        request(context, 
                        {
                          "q":"sends_user", 
                          "user_id": Session.userId, 
                          "selected_id": Session.selectedId,
                          "text": message,
                        }
                        ).then((ls) { setState((){ 
                          if(ls!=null){
                            refresh();
                          }
                        });});

                      }, 
                      icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primary,)
                    ),
                  ),
                  onSubmitted: (value) {
                    newMessage = value as TextEditingController;

                  },
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
