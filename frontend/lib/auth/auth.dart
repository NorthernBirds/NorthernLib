import 'package:flutter/material.dart';
import 'package:frontend/api_requests.dart';
import 'package:frontend/dashboards/signInDashboard.dart';
import 'package:frontend/config.dart';
import 'dart:isolate';

void Logout({required BuildContext context}) {
  signOut();
  session = {};
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginDashboard()),
  );
}

void startDurationHeartbeat() {
  Isolate.spawn(_durationHeartbeatLoop, null);
}

void _durationHeartbeatLoop(dynamic _) async {
  while (true) {
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (session.containsKey("duration")) {
        session["duration"] = session["duration"] + 1;

        if (session["duration"] >= 3000) {
          session.clear();

          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginDashboard()),
            (route) => false,
          );

          break;
        }
      }
    } catch (e) {}
  }
}

void resetDuration() {
  if (session.containsKey("duration")) {
    session["duration"] = 0;
  }
}
