import 'dart:async';

import 'package:daily_planner_app/global.dart';
import 'package:daily_planner_app/helper/google_api_handler.dart';
import 'package:daily_planner_app/models/assets.dart';
import 'package:flutter/material.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class SigninHandlerScreen extends StatefulWidget {
  @override
  State createState() => _SigninHandlerScreenState();
}

class _SigninHandlerScreenState extends State<SigninHandlerScreen> {
  GoogleAPIHandler _api = GoogleAPIHandler();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _handleAutoSignin();
  }

  void _handleAutoSignin() async {
    try {
      await _api.googleSignIn.signInSilently();

      // Check signed-in
      var user = _api.googleSignIn.currentUser;
      if (user != null) {
        _handleSignedIn("auto");
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  void _handleSignedIn(String type) async {
    // Set Current user
    _api.currentUser = _api.googleSignIn.currentUser;
    // Set API Client
    _api.client = await _api.googleSignIn.authenticatedClient();

    // Show Signed-in Snack Bar
    var userEmail = _api.currentUser.email;
    final SnackBar snackBar =
        SnackBar(content: Text("Signed-in as $userEmail."));
    scaffoldMessengerKey.currentState.showSnackBar(snackBar);

    // // Navigate to next screen based on sign in type
    if (type == "auto")
      navigatorKey.currentState.pushReplacementNamed('/home');
    else if (type == "manual")
      navigatorKey.currentState.pushReplacementNamed('/choose_calendar');
  }

  Future<void> _onPressSignIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _api.googleSignIn.signIn();

      // Check signed-in
      var user = _api.googleSignIn.currentUser;
      if (user != null) {
        _handleSignedIn("manual");
      } else {
        // Show Sign-in Failed Snackbar
        final SnackBar snackbar =
            SnackBar(content: Text("Couldn't sign-in. Please try again."));
        scaffoldMessengerKey.currentState.showSnackBar(snackbar);

        setState(() {
          _isLoading = false;
        });
      }
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
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 80.0, minWidth: 75.0),
            child: (_isLoading
                ? SizedBox(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      strokeWidth: 6.0,
                    ),
                    height: 80.0,
                    width: 80.0,
                  )
                : TextButton(
                    child: const Text('SIGN IN',
                        style: TextStyle(
                          fontFamily: 'Futura',
                          fontSize: 38,
                        )),
                    onPressed: () => _onPressSignIn(),
                  )),
          ),
        ],
      )),
    );
  }
}
