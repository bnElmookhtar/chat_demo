import 'package:flutter/material.dart';
import 'package:goat/component/reusable_component.dart';
class ChangeName extends StatefulWidget {
  final String? userId ;
  const ChangeName({Key? key,this.userId}) : super(key: key);
  @override
  State<ChangeName> createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  var oldName = TextEditingController(),newName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Name"),
      ),
      body:  Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  onTap: () {},
                  decoration: const InputDecoration(
                    label: Text("Old Name "),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit),
                  ),
                  controller:  oldName,
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (value) {
                    setState(() {
                      value = oldName.toString();
                    });
                  },
                ),
                defualtVersticalSizedBox(height: 20.0),
                TextFormField(
                  onTap: () {},
                  decoration: const InputDecoration(
                    label: Text("New Name "),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit),
                  ),
                  controller: newName,
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (value) {
                    setState(() {
                      value = newName.toString();
                    });
                  },
                ),
                defualtVersticalSizedBox(height: 20.0),
                MaterialButton(
                  onPressed: () {},
                  color: Colors.blue,
                  minWidth: double.infinity,
                  child: const Text("Confirm"),
                ),
              ],
            ),
          ),
    );
  }
}
