import 'package:flutter/material.dart';
import 'package:goat/component/reusable_component.dart';
class ChangeName extends StatefulWidget {
  const ChangeName({Key? key}) : super(key: key);

  @override
  State<ChangeName> createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
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
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (value) {},
                ),
                defualtVersticalSizedBox(height: 20.0),
                TextFormField(
                  onTap: () {},
                  decoration: const InputDecoration(
                    label: Text("New Name "),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit),
                  ),
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (value) {},
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
