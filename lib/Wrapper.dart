import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:testappog/API/Firebase_Auth.dart';
import 'package:testappog/API/Firestore.dart';
import 'package:testappog/PreLoginWrapper.dart';
import 'package:testappog/PrimaryScene.dart';
import 'package:testappog/SavedUser.dart';
import 'package:testappog/SceneManager.dart';
import 'package:testappog/SecondaryScene.dart';

import 'DataModel/Project.dart';

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  bool _pseudoInitStateToggle = false;

  FirestoreAPI _firestoreAPI = FirestoreAPI();
  FirebaseAPI _firebaseAPI = FirebaseAPI();
  var _firebaseUser;
  SavedUser _savedUser;

  double _height;
  double _width;
  bool _animationToggle = false;

  Widget _loggedInScene;

  double _frontSceneNewHeight;
  double _frontSceneNewWidth;


  @override
  Widget build(BuildContext context) {

    print("Wrapper Called");

    _firebaseUser = Provider.of<FirebaseUser>(context);
    _savedUser = Provider.of<SavedUser>(context);


    if(!_pseudoInitStateToggle){

     // _pseudoInitState();

      _pseudoInitStateToggle = true;
    }

    if(_firebaseUser!= null && _savedUser.user == null){
      (_firestoreAPI.getUserInfoFromDatabase(_firebaseUser.uid)).then(
              (userDetails){
                _savedUser.setUser(userDetails, List<Project>());
         /*   _firestoreAPI.getUserProjectFromDatabase(userDetails.name).then(                     /// //// .....
                    (projects){
                  _savedUser.setUser(userDetails,projects);
                }
            ); */
          } );
    }


    return _firebaseAPI.isUserLoggedIn(firebaseUser: _firebaseUser) ?  _savedUser.user == null ?Container(color: Colors.yellowAccent,) : SwipeDetector(

     ///  Container(yellowAccent) to be replace by loading screen

     onSwipeLeft: (){
        setState(() {
          _animationToggle = false;
        });
      },
      swipeConfiguration: SwipeConfiguration(
        horizontalSwipeMinDisplacement: 30
      ),

      child: LayoutBuilder(
          builder: (context,constraints){

            _height = constraints.constrainHeight();
            _width = constraints.constrainWidth();

            _frontSceneNewWidth = _width * 0.9;
            _frontSceneNewHeight = _height * 0.7;


            return Scaffold(
              body: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(color: Colors.grey[900],width: _width,height: _height,),
                  SecondaryScene(),
                  AnimatedPositioned(
                    //curve: Curves.bounceOut,
                    duration: Duration(milliseconds: 200),
                    width: _animationToggle ? _frontSceneNewWidth : _width,
                    height: _animationToggle ? _frontSceneNewHeight : _height,
                    left: _animationToggle ? _width * 0.85 : 0,
                    top: _animationToggle ? _height * 0.3 : 0,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(
                            offset: Offset(0,20),
                            color: Colors.black,
                            blurRadius: 5
                        ),],
                        borderRadius: BorderRadius.all(Radius.circular(_animationToggle ? 20 : 0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(_animationToggle ? 20 : 0),
                        child: ChangeNotifierProvider<SceneManager>(
                          create: (_) => SceneManager(),
                          child: StreamProvider.value(value: _firestoreAPI.getProjectsFromStream(_savedUser.user.name),child: PrimaryScene(toggleAnimation)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
    ) : PreLoginWrapper();
  }


  void toggleAnimation(){
    setState(() {
      _animationToggle = !_animationToggle;
    });
  }
  /* void _pseudoInitState()
  {
      _loggedInScene =
  }   */
}
