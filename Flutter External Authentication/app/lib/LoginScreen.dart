import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  Future<void> redirectToWebAuth() async {
    final Uri uriWithParams = Uri.parse("http://localhost:3000?port=56430");
    if (!await launchUrl(uriWithParams, mode: LaunchMode.externalApplication)) {
      print("Failed to launch the url!");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 30,
      children: [
        Text("Login Screen!"),
        TextButton(
          onPressed: redirectToWebAuth,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.white),
            padding: WidgetStatePropertyAll(EdgeInsets.all(16)),
          ),
          child: Text("Login!", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
