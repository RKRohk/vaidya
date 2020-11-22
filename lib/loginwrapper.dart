import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:vaidya/Screens/getstarted.dart';
import 'package:vaidya/main.dart';

import 'file:///C:/Users/Rohan/AndroidStudioProjects/vaidya/lib/Screens/homepage.dart';

class LoginWrapper extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<User> user = useProvider(userProvider);
    return user.when(
        data: (user) {
          if (user != null) {
            return HomePage();
          } else {
            return GetStarted();
          }
        },
        loading: () => CircularProgressIndicator(),
        error: (err, stack) => Container());
  }
}
