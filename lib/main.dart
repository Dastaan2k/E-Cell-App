import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testappog/API/Firebase_Auth.dart';
import 'package:testappog/SavedUser.dart';
import 'package:testappog/SceneManager.dart';

import 'Test.dart';
import 'Wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return StreamProvider<FirebaseUser>.value(
      value: FirebaseAPI().user,
      child: ChangeNotifierProvider<SavedUser>(
        create: (_) => SavedUser(),
        child: MaterialApp(
          home: Wrapper(),
        ),
      ),
    );
  }
}

// Firestore().updateData();      to update profile etc