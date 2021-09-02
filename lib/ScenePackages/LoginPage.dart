import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testappog/API/Firebase_Auth.dart';
import 'package:testappog/API/Firestore.dart';
import 'package:testappog/DataModel/Project.dart';

import '../CustomColor.dart';
import '../SavedUser.dart';



class LoginPageDesign extends StatefulWidget {

  final Function toggleView;
  LoginPageDesign(this.toggleView);

  @override
  _LoginPageDesignState createState() => _LoginPageDesignState();
}

class _LoginPageDesignState extends State<LoginPageDesign> {

  double _height;
  double _width;
  double _logoContainerHeight;
  double _logoContainerWidth;
  double _midStackUserIconHeight;
  double _midStackUpperPadding;
  double _midCardHeight;
  double _midCardWidth;
  double _loginButttonHeight;
  double _loginButtomWidth;
  double _genralFontSize;

  FirebaseAPI _firebaseAPI = FirebaseAPI();
  FirestoreAPI _firestoreAPI = FirestoreAPI();
  SavedUser _user;

  final  CollectionReference collectionReference = Firestore.instance.collection('User');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  FocusNode nodeUser;
  FocusNode nodePass;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();


  void _requestFocus(){
    setState(() {
      if(nodeUser.hasFocus)
        FocusScope.of(context).requestFocus(nodePass);
      else
        FocusScope.of(context).requestFocus(nodeUser);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nodeUser = FocusNode();
    nodePass = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nodeUser.dispose();
    nodePass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _user = Provider.of<SavedUser>(context);

    return LayoutBuilder(
      builder: (context,constraints){

        print("Login Page Called");

        _height = constraints.constrainHeight();
        _width = constraints.constrainWidth();
        _midStackUpperPadding = _height * 0.06;
        _midStackUserIconHeight = _height * 0.12;
        _logoContainerHeight = _height * 0.32;
        _logoContainerWidth = _width * 0.7;
        _midCardHeight = _height * 0.35;
        _midCardWidth = _width * 0.95;
      //  _textFieldUpperPadding = _midCardHeight * 0.08;
        _loginButttonHeight = _height * 0.075;
        _loginButtomWidth = _width * 0.9;
        _genralFontSize = _height * 0.02;

        return Scaffold(
          key: _scaffoldKey,
            backgroundColor: CustomColor.darkBackgroundBack,
            body : Container(
              width: _width,
              height: _height,
              color: CustomColor.darkBackgroundFront,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height : _logoContainerHeight,
                      width:  _logoContainerWidth,
                      child: Center(
                        child: Container(
                          width: _logoContainerWidth,
                          height: _logoContainerHeight/1.75,
                          child: Image.asset("assets/ecellLogoDark.png"),
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: _midStackUpperPadding),
                          child: Container(
                            height: _midCardHeight,
                            width: _midCardWidth,
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(
                                width: 1,
                                color: CustomColor.borderWhite,
                              )
                              ),
                              color: CustomColor.formCardColor,
                              child: Padding(
                                padding: EdgeInsets.only(left : _midCardWidth * 0.05,right : _midCardWidth * 0.05,top: _midCardHeight * 0.15,bottom: _midCardHeight * 0.1),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: _midCardHeight *0.3,
                                        child: TextFormField(
                                          controller: email,
                                          focusNode: nodeUser,
                                          validator: (val) => val.isEmpty ? 'Field must be filled' : null,
                                          onTap: _requestFocus,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                              labelText: 'Email-id',
                                              labelStyle: TextStyle(
                                                color:  nodeUser.hasFocus ? Colors.greenAccent : Colors.white,
                                              ),
                                              fillColor: Colors.grey[800],
                                              filled: true,
                                              hintText: 'Email-id',
                                              hintStyle: TextStyle(color: Colors.grey),
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  )
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                  borderSide : BorderSide(
                                                    color: Colors.greenAccent,
                                                  )
                                              )
                                          ),
                                        ),
                                      ),
                                      Container(height: _height * 0.015,),
                                      Container(
                                        height: _midCardHeight * 0.3,
                                        child: TextFormField(
                                        controller: pass,
                                        focusNode: nodePass,
                                        validator: (val) => val.isEmpty ? 'Field must be filled' : null,
                                        onTap: _requestFocus,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            labelText: 'Password',
                                            hintStyle: TextStyle(color: Colors.grey),
                                            labelStyle: TextStyle(
                                              color:  nodePass.hasFocus ? Colors.greenAccent : Colors.white,
                                            ),
                                            fillColor: Colors.grey[800],
                                            filled: true,
                                            hintText: 'Password',
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey,
                                                )
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide : BorderSide(
                                                  color: CustomColor.textGreen,
                                                )
                                            )
                                        ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: _midStackUserIconHeight,
                          height: _midStackUserIconHeight,
                          decoration:
                          ShapeDecoration(shape: CircleBorder(), color: CustomColor.darkBackgroundBack),
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                                shape: CircleBorder(),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image : AssetImage('assets/Group8.png'),
                                )),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: _height * 0.03),
                      child: Container(
                        width : _loginButtomWidth  * 0.9,
                        height : _loginButttonHeight,
                        child: RaisedButton(
                          onPressed: ()async {
                            if (_formKey.currentState.validate()) {
                              print(email.text + pass.text);
                              _firebaseAPI.loginWithEmailAndPassword(email.text, pass.text).then((result) async {
                                if(result == null){
                                  print("Error logging in");
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please re-check your email and password and try again"),duration: Duration(seconds: 2),));
                                }
                                else{
                                  print("Successful Log in");
                                /*  (_firestoreAPI.getUserInfoFromDatabase(result.uid)).then(
                                          (userDetails){
                                            _firestoreAPI.getUserProjectFromDatabase(userDetails.name).then(
                                                    (projects){
                                                      _user.setUser(userDetails,projects);
                                                    }
                                                );
                                          });  */
                                  (_firestoreAPI.getUserInfoFromDatabase(result.uid)).then(
                                          (userDetails){
                                              if(userDetails == null)
                                                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Error in Firestore Call"),duration: Duration(seconds: 2),));
                                              else{
                                                _user.setUser(userDetails,List<Project>());
                                              }
                                      });
                                }
                              });
                            }
                          },
                          elevation: 2,
                          color: CustomColor.neonGreen,
                          child: ButtonTheme(
                            child: Text("Login",style: TextStyle(color: Colors.white),),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: _height * 0.1,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Container(
                              width: _width * 0.32,
                              child: Row(
                                children: [
                                  Text("Login as ",style: TextStyle(color: Colors.white,fontSize: _genralFontSize),),
                                  InkWell(
                                    onTap: ()async{
                                      print("Guest Logged in");
                                    /*  dynamic result = await _auth.signInAnon().then((value){_manager.setUser(null);});
                                      if(result == null)
                                      {
                                        print("Error in login");
                                      } */
                                    },
                                    child: Text("Guest",style: TextStyle(color: CustomColor.textGreen,fontSize: _genralFontSize,decoration: TextDecoration.underline),),
                                  ),
                                  Text(" ? ",style: TextStyle(color: Colors.white,fontSize: _genralFontSize),),
                                ],
                              ),
                            ),
                          ),
                          Text("Or",style: TextStyle(color: Colors.white,fontSize: _genralFontSize),),
                          InkWell(
                            onTap: ()async {
                              widget.toggleView();
                            },
                            child: Text("Register",style: TextStyle(color: CustomColor.textGreen,fontSize: _genralFontSize,decoration: TextDecoration.underline),),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
        );
      },
    );
  }
}

