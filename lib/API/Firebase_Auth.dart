import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseAPI
{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<FirebaseUser> get user{
    return _auth.onAuthStateChanged;
  }

  bool isUserLoggedIn({@required FirebaseUser firebaseUser}){
    return firebaseUser == null ?  false : true;
  }

  Future<FirebaseUser> loginWithEmailAndPassword(String email,String password)async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    }
    catch(e)
    {
     // print("Error logging in : " + e);
      return null;
    }
  }

  Future<FirebaseUser> signInAnon()async{
    try{
      AuthResult result= await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    }
    catch(e)
    {
      print("Error im Guest Login (Backend) : " + e);
      return null;
    }
  }

  Future<String> uidThroughAuth() async                                          /// UID provided by auth is the same as document id for each user
  {
    FirebaseUser user  = await _auth.currentUser();
    if(user == null)
      return null;
    else
      return user.uid;
  }

  Future signOut()async{
    try{
      print("Sign out called");
      return await _auth.signOut();
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }
}
