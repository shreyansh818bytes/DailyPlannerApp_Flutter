import 'dart:async';

import 'package:daily_planner_app/global.dart';
import 'package:daily_planner_app/helper/google_api_handler.dart';
import 'package:daily_planner_app/models/assets.dart';
import 'package:flutter/material.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninHandlerScreen extends StatefulWidget {
  @override
  State createState() => SigninHandlerScreenState();
}

class SigninHandlerScreenState extends State<SigninHandlerScreen> {
  GoogleAPIHandler api = GoogleAPIHandler();

  @override
  void initState() {
    super.initState();
    api.googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      api.currentUser = account;
      if (api.currentUser != null) {
        _handleSignedIn();
      }
    });
    api.googleSignIn.signInSilently();
    api.currentUser = api.googleSignIn.currentUser;
    if (api.currentUser != null) {
      _handleSignedIn();
    }
  }

  void _handleSignedIn() {
    // Build Snack Bar
    var userEmail = api.currentUser.email;
    final SnackBar snackBar = SnackBar(
        content: Text("Signed-in to $userEmail account successfully!"));

    // Show Snack Bar
    scaffoldMessengerKey.currentState.showSnackBar(snackBar);
    // Navigate to next screen
    navigatorKey.currentState.pushReplacementNamed('/home');
  }

  Future<void> _handleSignIn() async {
    try {
      await api.googleSignIn.signIn();

      // Set API Client
      api.client = await api.googleSignIn.authenticatedClient();

      _handleSignedIn();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            AssetIcons.appIconLarge,
            height: 128,
          ),
          SizedBox(
            height: 35.0,
          ),
          Text(
            'Daily Planner',
            style: TextStyle(fontFamily: 'Futura', fontSize: 36),
          ),
          SizedBox(
            height: 185.0,
          ),
          ElevatedButton(
            child: const Text('SIGN IN',
                style: TextStyle(
                  fontFamily: 'Futura',
                  fontSize: 38,
                )),
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.only(top: 15, left: 40, bottom: 15, right: 40)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ))),
            onPressed: () => _handleSignIn(),
          ),
        ],
      )),
    );
  }
}
