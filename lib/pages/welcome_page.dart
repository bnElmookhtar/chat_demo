import 'package:flutter/material.dart';
import 'package:goat/data/session.dart';
import 'package:goat/pages/home_page.dart';
import 'package:goat/widgets/dialog.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _phoneControler = TextEditingController();
  final _nameControler = TextEditingController();
  var _isRegistering = false;

  void submit() {
    final phone = _phoneControler.text;
    if (_isRegistering) {
      final name = _nameControler.text.trim();
      Session.register(name, phone).then((ls) {
        if (ls.isNotEmpty && ls[0].containsKey('m')) {
          showMessageDialog(context, ls[0]["m"], "");
        } else {
          showMessageDialog(
            context,
            "Created your account",
            "Go to login and use it",
          );
        }
      });
    } else {
      Session.login(phone).then((ls) {
        if (ls.isNotEmpty && ls[0].containsKey('m')) {
          showMessageDialog(context, ls[0]["m"], "");
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.message_outlined,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text("Welcome on"),
            Text(
              "GOAT Messanger",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 80),
            Text(_isRegistering
                ? "Enter your phone and name to register"
                : "Enter your phone to login"),
            const SizedBox(height: 20),
            TextFormField(
              onTap: () {},
              decoration: const InputDecoration(
                label: Text("Your Phone"),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              controller: _phoneControler,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (value) {},
              maxLength: 11,
              maxLines: 1,
            ),
            _isRegistering ? const SizedBox(height: 5) : const SizedBox(),
            _isRegistering
                ? TextFormField(
                    onTap: () {},
                    decoration: const InputDecoration(
                      label: Text("Your Name"),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    controller: _nameControler,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (value) {},
                    maxLength: 30,
                    maxLines: 1,
                  )
                : const SizedBox(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submit,
              child: Text(_isRegistering ? "Create Account" : "Login"),
            ),
            const SizedBox(
              height: 90,
            ),
            Text(_isRegistering
                ? "Already have account?"
                : "Haven't registered yet?"),
            TextButton(
              onPressed: () {
                setState(() {
                  _isRegistering = !_isRegistering;
                });
              },
              child: Text(_isRegistering ? "Back to Login" : "Create Account"),
            ),
          ],
        ),
      )),
    );
  }
}
