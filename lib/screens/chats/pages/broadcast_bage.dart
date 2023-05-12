import 'package:flutter/material.dart';
import 'package:goat/models/broadcast_model.dart';
class BroadcastPAge extends StatefulWidget {
  const BroadcastPAge({Key? key, required this.broadcastModel}) : super(key: key);
  final BroadcastModel broadcastModel;
  @override
  State<BroadcastPAge> createState() => _BroadcastPAge();
}

class _BroadcastPAge extends State<BroadcastPAge> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.broadcastModel.broadName),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.blue, width: 1.0),
                          ),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 2.0, color: Colors.blue),
                          ),
                          hintText: 'Enter your new message',
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.camera_alt),
                          ),
                        ),
                        onSubmitted: (value) {
                        },
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.blue),
                          onPressed: () {
                          },
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
