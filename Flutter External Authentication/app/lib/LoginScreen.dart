import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.setIsLoggedIn});

  final Function(bool isLoggedIn) setIsLoggedIn;

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription? sub;

  Future<void> handleRedirectOnMobile() async {
    // use app links instead:
    sub = _appLinks.uriLinkStream.listen((url) async {
      // check token is correct or not
      final token = url.queryParameters['token']; // get the token from the url
      final username =
          url.queryParameters['username']; // get the username from the url
      if (token != null && username != null) {
        // both of them are present
        // now we verify the token and the username with the server
        // this step will be done later
        widget.setIsLoggedIn(true);
      } else {
        print("Login failed!!");
      }
    });
  }

  Future<void> redirectToWebAuth() async {
    final isMobile = Platform.isAndroid || Platform.isIOS;
    final Uri uriWithParams = Uri.parse(
      "http://192.168.29.191:3000?${isMobile ? "redirectTo=external-auth-app" : "port=56430"}",
    );
    if (!await launchUrl(uriWithParams, mode: LaunchMode.externalApplication)) {
      print("Failed to launch the url!");
    }
    if (Platform.isAndroid || Platform.isIOS) {
      // ensure nothing below happens in a mobile device
      return;
    }
    final tokenIsCorrect = await listen();
    if (tokenIsCorrect) {
      print("Correct token!");
      widget.setIsLoggedIn(true);
    } else {
      print("Incorrect token!");
    }
  }

  Future<bool> listen() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 56430);
    print("Listening on port 56430!");
    await for (HttpRequest request in server) {
      request.response.headers.add(
        "Access-Control-Allow-Origin",
        "*",
      ); // to prevent CORS from interfering
      request.response.headers.add(
        "Access-Control-Allow-Methods",
        "GET",
      ); // only get request is allowed, others are blocked
      request.response.headers.add(
        "Access-Control-Allow-Headers",
        "*",
      ); // allow headers to pass safely
      final uri = request.uri;
      final token = uri.queryParameters['token']; // get the token from the url
      final username =
          uri.queryParameters['username']; // get the username from the url

      if (token != null && username != null) {
        // both of them are present
        // now we verify the token and the username with the server
        // this step will be done later
        request.response
          ..statusCode = 200
          ..headers.set("Content-Type", "application/json")
          ..write("{'status': 'success', 'data': 'Valid Token'}")
          ..close();
        await server.close();
        return true;
      } else {
        request.response
          ..statusCode = 404
          ..headers.set('Content-Type', 'application/json')
          ..write("{'status': 'error', 'data': 'Token or Username not found'}")
          ..close();
      }
    }
    return false;
  }

  @override
  void initState() {
    handleRedirectOnMobile();
    super.initState();
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
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
