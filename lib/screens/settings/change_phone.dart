import 'package:flutter/material.dart';
import 'package:goat/component/reusable_component.dart';
class ChangePhone extends StatefulWidget {
  const ChangePhone({Key? key}) : super(key: key);

  @override
  State<ChangePhone> createState() => _ChangePhone();
}

class _ChangePhone extends State<ChangePhone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Phone"),
      ),
      body:  Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  onTap: () {},
                  decoration: const InputDecoration(
                    label: Text("Old Phone Number "),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  onFieldSubmitted: (value) {},
                ),
                defualtVersticalSizedBox(height: 20.0),
                TextFormField(
                  onTap: () {},
                  decoration: const InputDecoration(
                    label: Text("New Phone Number"),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
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