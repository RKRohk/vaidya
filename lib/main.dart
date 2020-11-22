import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:vaidya/constants.dart';
import 'package:vaidya/loginwrapper.dart';

final userProvider =
    StreamProvider<User>((ref) => FirebaseAuth.instance.userChanges());

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Splash(),
  ));
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        navigateAfterSeconds: new MyApp(),
        image: new Image.asset('assets/images/splash_screen.png'),
        backgroundColor: kPrimaryColour,
        seconds: 5,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 200.0,
        loaderColor: Colors.orange);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.orange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: LoginWrapper()),
    );
  }
}
