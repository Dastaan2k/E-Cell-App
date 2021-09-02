import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testappog/API/Firebase_Auth.dart';
import 'package:testappog/SavedUser.dart';
import 'package:testappog/SceneManager.dart';

class PrimaryScene extends StatefulWidget {

  Function _toggleAnimation;

  PrimaryScene(this._toggleAnimation);

  @override
  _PrimarySceneState createState() => _PrimarySceneState(_toggleAnimation);
}

class _PrimarySceneState extends State<PrimaryScene> {   /// ADD THE SAME ANIMATION ALGO AS THE WARAPPER FOR ONPRESSED OF HAMBURGER IN APPBAR

  Function _toggleAnimation;

  _PrimarySceneState(this._toggleAnimation);

  FirebaseAPI _firebaseAPI = FirebaseAPI();

  double _height;
  double _width;

  double _midButtonDiameter;

  SceneManager _manager;

  String _activeScene;

  SavedUser _user;

  @override
  Widget build(BuildContext context) {

    _user = Provider.of<SavedUser>(context);

    return LayoutBuilder(
      builder: (context,constraints){

        _height = constraints.constrainHeight();
        _width = constraints.constrainWidth();

        _midButtonDiameter = _width * 0.275;

        _manager = Provider.of<SceneManager>(context);

        _activeScene = _manager.scene;


        return Scaffold(
          backgroundColor: Colors.grey[800],
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(_height * 0.1),
            child: AppBar(
              leading: IconButton(icon: Icon(Icons.dehaze,color: Colors.grey,size: _height * 0.04,),onPressed: (){_toggleAnimation();},),
              centerTitle: true,
              backgroundColor: Colors.grey[850],
              title: Center(child: Text(_activeScene,style: TextStyle(color: Colors.greenAccent,fontWeight: FontWeight.bold,fontFamily:"Roboto",fontSize: _height * 0.035),)),
              actions: [IconButton(icon: Icon(Icons.tune,color: Colors.grey,size: _height * 0.04,),onPressed: (){
                _firebaseAPI.signOut();
                _user.setUser(null, null);
              },)],
            ),
          ),
          body: Stack(
            children: [
              _manager.returnScene(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      height: _height * 0.085,
                      width: _width,
                      color: Colors.grey[850],
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: _height * 0.085,width: (_width/2) - (_midButtonDiameter/2.25),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: Center(
                                    child: InkWell(
                                      onTap: (){
                                        print("Home");_manager.setScene("Home Page");},
                                      child: Icon(Icons.home,color: _activeScene == "Home Page" ? Colors.greenAccent : Colors.white,size: _height * 0.04,),
                                    ),
                                  ),
                                  width: ((_width/2) - (_midButtonDiameter/2.25))/2,
                                  height: _height * 0.085,
                                ),
                                Container(
                                  child: Center(
                                    child: InkWell(
                                      onTap: (){print("Projects");_manager.setScene("My Projects");},
                                      child: Icon(Icons.account_balance,color: _activeScene == "My Projects" ? Colors.greenAccent : Colors.white,size: _height * 0.04,),
                                    ),
                                  ),
                                  width: ((_width/2) - (_midButtonDiameter/2.25))/2,
                                  height: _height * 0.085,
                                ),
                              ],
                            )
                          ),
                          Container(
                            height: _height * 0.085,width: (_width/2) - (_midButtonDiameter/2.25),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: Center(
                                    child: InkWell(
                                      onTap: (){print("Attendance");_manager.setScene("Attendance");},
                                      child: Icon(Icons.book,color: _activeScene == "Attendance" ? Colors.greenAccent : Colors.white,size: _height * 0.04,),
                                    ),
                                  ),
                                  width: ((_width/2) - (_midButtonDiameter/2.25))/2,
                                  height: _height * 0.085,
                                ),
                                Container(
                                  child: Center(
                                    child: InkWell(
                                      onTap: (){print("Profile");_manager.setScene("Profile");},
                                      child: Icon(Icons.perm_identity,color: _activeScene == "Profile" ? Colors.greenAccent : Colors.white,size: _height * 0.04,),
                                    ),
                                  ),
                                  width: ((_width/2) - (_midButtonDiameter/2.25))/2,
                                  height: _height * 0.085,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: _width * 0.5 - _midButtonDiameter/2,
                bottom: _height * 0.01,
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Container(
                    width: _midButtonDiameter,
                    height: _midButtonDiameter,
                    decoration: BoxDecoration(
                      color: _activeScene == "Automation"? Colors.white : Colors.greenAccent ,
                      borderRadius: BorderRadius.all(Radius.circular(_midButtonDiameter/2)),
                      border: Border.all(color: Colors.grey[800],width: _width * 0.025),
                    ),
                    child: Icon(Icons.lightbulb_outline,color: _activeScene == "Automation"?Colors.greenAccent : Colors.white,size: _midButtonDiameter/2,),
                  ),
                  onTap: (){_manager.setScene("Automation");},
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


// child: _manager.returnScene()