import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/all.dart';

class User extends ChangeNotifier{
  
  get user => StreamProvider((ref) => FirebaseAuth.instance.userChanges(),name: "user");


}