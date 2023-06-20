import 'package:flutter/material.dart';
import 'package:goat/data/session.dart';
import 'package:goat/pages/welcome_page.dart';
import 'package:goat/widgets/dialog.dart';
import 'package:goat/widgets/snackbar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _nameControler = TextEditingController();
  final _phoneControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameControler.addListener(() {});
    _phoneControler.addListener(() {});
  }

  void updateName() =>
      Session.updateName(_nameControler.text.trim()).then((ls) {
        if (ls[0].containsKey("m")) {
          showMessageDialog(context, ls[0]["m"], "");
        } else {
          _nameControler.clear();
          setState(() {});
          showSnackBar(context, "Your name has been changed");
        }
      });

  void updatePhone() =>
      Session.updatePhone(_phoneControler.text.trim()).then((ls) {
        if (ls[0].containsKey("m")) {
          showMessageDialog(context, ls[0]["m"], "");
        } else {
          _phoneControler.clear();
          setState(() {});
          showSnackBar(context, "Your phone has been changed");
        }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text("Account Settings")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withAlpha(50),
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.account_circle),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    Session.userName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    Session.userPhone,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              keyboardType: TextInputType.text,
              maxLines: 1,
              maxLength: 29,
              controller: _nameControler,
              decoration: const InputDecoration(hintText: "New name"),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: updateName,
              child: const Text("Update"),
            ),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              maxLines: 1,
              maxLength: 11,
              controller: _phoneControler,
              decoration: const InputDecoration(hintText: "New phone"),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: updatePhone,
              child: const Text("Update"),
            ),
            const SizedBox(height: 10),
            Center(
              child: OutlinedButton(
                onPressed: () => showConfirmationDialog(
                  context,
                  "Do you want to logout?",
                  "",
                  () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomePage(),
                      ),
                    );
                  },
                ),
                child: const Text("Logout"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
