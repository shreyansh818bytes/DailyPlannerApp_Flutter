import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

var uuidGenerator = Uuid();

class GoogleAPIHandler {
  String uuid; // unique instance identifier

  final GoogleSignIn googleSignIn = GoogleSignIn(
    // clientId: <CLIENT_ID_KEY>,
    scopes: [
      CalendarApi.calendarEventsScope,
      CalendarApi.calendarScope,
      CalendarApi.calendarSettingsReadonlyScope,
    ],
  );

  GoogleSignInAccount currentUser;

  auth.AuthClient client;

  // Build custom caching service for this handler
  static final List<GoogleAPIHandler> _cache = [];

  factory GoogleAPIHandler() {
    if (_cache.length == 0) {
      print('Creating new instance');

      var uuid = uuidGenerator.v4(); // genenrate a new random UUID string
      var instance = GoogleAPIHandler._createInstance(uuid);

      _cache.add(instance); // Cache instance
    }

    return _cache[_cache.length - 1];
  }

  GoogleAPIHandler._createInstance(this.uuid);

  // Future<void> _handleGetCalendarsList(GoogleSignInAccount user) async {
  //   setState(() {
  //     _calendarsText = 'Loading contact info...';
  //   });
  //   final http.Response response = await http.get(
  //     Uri.parse('https://www.googleapis.com/calendar/v3/users/me/calendarList'),
  //     headers: await user.authHeaders,
  //   );

  //   // TODO Handle API response exception
  //   if (response.statusCode != 200) {
  //     setState(() {
  //       _calendarsText = 'People API gave a ${response.statusCode} '
  //           'response. Check logs for details.';
  //     });
  //     print('People API ${response.statusCode} response: ${response.body}');
  //     return;
  //   }
  //   List<Calendar> calendars;

  //   final Map<String, dynamic> data =
  //       json.decode(response.body) as Map<String, dynamic>;

  //   final List<dynamic> calendarItems = data["items"] as List<dynamic>;

  //   for (dynamic item in calendarItems) {

  //   }

  //   setState(() {
  //     if (namedContact != null) {
  //       _calendarsText = ;
  //     } else {
  //       _calendarsText = 'No contacts to display.';
  //     }
  //   });
  // }

  // String _calendarListMapper(Map<String, dynamic> data) {
  //   final List<dynamic> calendarItems = data['items'] as List<dynamic>;
  //   final Map<List<String>, List<dynamic>> contact = calendarItems != null
  //       ? calendarItems.map((calendar) => )
  //       : null;
  //   if (contact != null) {
  //     final Map<String, dynamic> name = contact['names'].firstWhere(
  //       (dynamic name) => name['displayName'] != null,
  //       orElse: () => null,
  //     );
  //     if (name != null) {
  //       return name['displayName'] as String;
  //     }
  //   }
  //   return null;
  // }

  // Future<void> signOut() => _googleSignIn.disconnect();
}
