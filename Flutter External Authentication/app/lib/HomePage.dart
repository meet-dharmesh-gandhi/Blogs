import 'package:app/LoginScreen.dart';
import 'package:app/MainScreen.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Home Page!"),
        if (!isLoggedIn)
          LoginScreen(
            setIsLoggedIn:
                (bool newValue) => setState(() => isLoggedIn = newValue),
          ),
        if (isLoggedIn) MainScreen(),
      ],
    );
  }
}
