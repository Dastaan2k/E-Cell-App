import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:testappog/API/Firebase_Auth.dart';
import 'package:testappog/API/Firestore.dart';
import 'package:testappog/CustomColor.dart';
import 'package:testappog/DataModel/User.dart';

import '../SavedUser.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

/*

After turning edit mode on ........ If the use turning the edit mode of (after editing his data) ........ cross check is the data is same a before turning the edit mode on.
If the data isnt cahnged mean no changes have been done to the profile ...... In that case dont perform a write operation as its useless.
Only perform the write operation if any changes are done in profile data.

 */




class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin{

  SavedUser _savedUser;
  FirebaseAPI _firebaseAPI = FirebaseAPI();
  FirestoreAPI _firestoreAPI = FirestoreAPI();

  User _preUpdateStatus = User();

  double _height;
  double _width;
  double _upperExpandedContainerHeight;
  double _upperContainerContractedHeight;
  double _profilePicDiameter;
  double _profilePicContainerContracted;
  double _logoutButtonHeight;
  double _logOutButtonOuterOffset;
  double _cardContractedHeight;
  double _cardExpandedHeight;
  double _cardWidth;
  double _cardLabelHeight;
  double _cardLabelContractedWidth;
  double _cardLabelExpandedWidth;
  double _listExpandedHeight;
  double _listContractedHeight;

  bool _isGeneralDetailsExpanded = false;
  bool _isExtraCard1Expanded = false;
  bool _isExtraCard2Expanded = false;
  bool _isUpperContainerExpanded = true;
  bool _notAtStartUpdateLock = false;
  bool _pseudoInitStateToggle = false;
  bool _isEditable = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  final Tween<double> _tweenRotation = Tween<double>(
    begin: 0,
    end: -0.25,
  );

  final Tween<double> _tweenRotation1 = Tween<double>(
    begin: 0,
    end: -0.25,
  );

  final Tween<double> _tweenRotation2 = Tween<double>(
    begin: 0,
    end: -0.25,
  );

  AnimationController _animationController;
  AnimationController _animationController1;
  AnimationController _animationController2;

  ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _animationController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _animationController2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {

    _savedUser = Provider.of<SavedUser>(context);

    return LayoutBuilder(
        builder: (context,constraints){

          _width = constraints.constrainWidth();
          _height =constraints.constrainHeight();
          _upperExpandedContainerHeight = _height * 0.425;
          _upperContainerContractedHeight = _height * 0.15;
          _profilePicDiameter = _height * 0.2;
          _profilePicContainerContracted = _height * 0.1;
          _logoutButtonHeight = _height * 0.1;
          _logOutButtonOuterOffset = _height * 0.025;
          _cardContractedHeight = _height * 0.1;
          _cardExpandedHeight = _height * 0.5;
          _cardLabelHeight = _height * 0.1;
          _cardLabelContractedWidth = _cardWidth;
          _cardLabelExpandedWidth = _cardExpandedHeight;
          _cardWidth = _width * 0.9;
          _listContractedHeight =  _height - (_upperContainerContractedHeight + _height * 0.085) - _height * 0.05;       // height - (upperContainerContractedHeight  + bottomNavBarHeight)   // Actually its expanded list height
          _listExpandedHeight = _height - (_upperExpandedContainerHeight + _logoutButtonHeight + _logOutButtonOuterOffset);

          if(!_pseudoInitStateToggle){
            _nameController.text = _savedUser.user.name;
            _emailController.text = _savedUser.user.email;
            _passController.text = _savedUser.user.password;
            _phoneController.text = _savedUser.user.phone;

            _pseudoInitStateToggle = true;
          }

          return SingleChildScrollView(
            child: Stack(
                alignment: Alignment.topCenter,
                children: [
                 Container(height: _height * 0.9,),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 200),
                    top: _isUpperContainerExpanded ? _upperExpandedContainerHeight + _logoutButtonHeight/2 + _logOutButtonOuterOffset : _upperContainerContractedHeight + _logOutButtonOuterOffset,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: _isUpperContainerExpanded ? _listExpandedHeight : _listContractedHeight,
                      width: _cardWidth,
                      child: ListView(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(bottom: _height * 0.02),
                              child: _generalInfoCard(),                                                                         /// /////////
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: _height * 0.02),
                            child: _extraCard1(),                                                                         /// /////////
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: _height * 0.02),
                            child: _extraCard2(),                                                                         /// /////////
                          ),
                        ],
                      ),
                    ),
                  ),
                 Stack(
                 alignment: Alignment.topCenter,
                 children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          height: _isUpperContainerExpanded ? _upperExpandedContainerHeight : _upperContainerContractedHeight,
                          width: _width,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.grey[900],blurRadius: 7.5,spreadRadius: 2)],
                            color: HexColor("#141414"),
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(_isUpperContainerExpanded ? 30 : 15),bottomLeft: Radius.circular(_isUpperContainerExpanded ? 30 : 15)),
                          ),
                        ),
                        AnimatedPositioned(
                          left: _isUpperContainerExpanded ? _width * 0.5 - _profilePicDiameter/2 : _width * 0.05,
                          duration: Duration(milliseconds: 200),
                          top: _isUpperContainerExpanded ? _height * 0.05 : _height * 0.025,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            height: _isUpperContainerExpanded ? _profilePicDiameter : _profilePicContainerContracted,
                            width:_isUpperContainerExpanded ? _profilePicDiameter : _profilePicContainerContracted,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(_profilePicDiameter/2),
                              border: Border.all(color: Colors.greenAccent,width: 3),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(_savedUser.user.profileImage,),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: IconButton(
                              onPressed: (){
                                if(_isEditable){
                                  if(_preUpdateStatus.name == _nameController.text && _preUpdateStatus.email == _emailController.text && _preUpdateStatus.phone == _phoneController.text && _preUpdateStatus.password == _passController.text){
                                    _isEditable = false;
                                    print("No write");
                                  }
                                  else{
                                    showModalBottomSheet(context: context, builder: (context){
                                      return FractionallySizedBox(
                                        heightFactor: 0.2,
                                        child: Container(
                                          color: Colors.grey[900],
                                          padding: EdgeInsets.all(10),
                                          height: _height * 0.2,
                                          width: _width,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text("Confirm changes ? ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                              IconButton(
                                                icon: Icon(Icons.check,color: Colors.greenAccent,),
                                                onPressed: (){
                                                  _firestoreAPI.editProfile(_savedUser.user.uid, _nameController.text, _emailController.text, _phoneController.text, _passController.text).then((value){
                                                    _savedUser.user.name = _nameController.text;
                                                    _savedUser.user.phone = _phoneController.text;
                                                    _savedUser.user.email = _emailController.text;
                                                    _savedUser.user.password = _passController.text;
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      _isEditable = false;
                                                    });
                                                  });
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.clear,color: Colors.redAccent,),
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    _isEditable = false;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                  }
                                }
                                else{
                                  _preUpdateStatus = User(name: _savedUser.user.name,email: _savedUser.user.email,password: _savedUser.user.password,phone: _savedUser.user.phone);
                                  _cardStateCheck(0);
                                  _isExtraCard1Expanded = false;
                                  _isExtraCard2Expanded = false;
                                  _isGeneralDetailsExpanded = true;
                                  _isUpperContainerExpanded = false;
                                  if(!_isGeneralDetailsExpanded && !_isExtraCard1Expanded && !_isExtraCard2Expanded)
                                    _isUpperContainerExpanded = true;
                                  if(!_isGeneralDetailsExpanded)
                                    _animationController.reverse();
                                  else
                                    _animationController.forward();
                                  setState(() {
                                    _isEditable = true;
                                  });
                                }
                              },
                              icon: Icon(Icons.edit,color: _isEditable? Colors.greenAccent : Colors.grey,size: _height * 0.05,),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 200),
                          top: _isUpperContainerExpanded ? (_height * 0.08) + _profilePicDiameter : _upperContainerContractedHeight * 0.15,
                          child: Text(_savedUser.user.name,style: TextStyle(color: Colors.greenAccent,fontSize: _height * 0.04,fontWeight: FontWeight.bold,fontFamily: "Roboto",)),
                        ),
                    ],
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 200),
                    top: _isUpperContainerExpanded ? _upperExpandedContainerHeight - _height * 0.05 - _logOutButtonOuterOffset/2 : _upperContainerContractedHeight * 0.56,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: _isUpperContainerExpanded ? _logoutButtonHeight + _logOutButtonOuterOffset : _height * 0.05,
                      width: _isUpperContainerExpanded ? _width * 0.6 + _logOutButtonOuterOffset : _width * 0.3,
                      decoration: BoxDecoration(
                        color: _isUpperContainerExpanded? Colors.grey[800] : Colors.transparent,
                        borderRadius: BorderRadius.circular(_isUpperContainerExpanded ? _logoutButtonHeight/2 + 10 : 5),
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: (){_firebaseAPI.signOut();_savedUser.setUser(null,null);},
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            height: _logoutButtonHeight,
                            width: _width * 0.6,
                            decoration: BoxDecoration(
                              color: _isUpperContainerExpanded ? Colors.grey[900] : Colors.grey[700],
                              border: Border.all(color: Colors.grey[900],width: 1),
                              borderRadius: BorderRadius.circular(_isUpperContainerExpanded ? _logoutButtonHeight/2 : 5),
                            ),
                            child: Center(child: AutoSizeText("Logout",maxLines: 1,style: TextStyle(color: _isUpperContainerExpanded ? Colors.greenAccent : Colors.grey[200],fontSize: _isUpperContainerExpanded ? _logoutButtonHeight /2.5 : _height * 0.03,fontFamily: "Roboto",fontWeight: _isUpperContainerExpanded? FontWeight.bold : FontWeight.normal),)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

          );
        }
    );
  }

  _scrollListener()
  {
      if(_scrollController.offset >= _scrollController.position.maxScrollExtent  &&  !_scrollController.position.outOfRange) {
        print("End of List");
      }
      else if(_scrollController.offset > _scrollController.position.minScrollExtent){
        setState(() {
          if(!_notAtStartUpdateLock)
            print("Not at Start of List");
          _isUpperContainerExpanded = false;
          _notAtStartUpdateLock = true;
        });
      }
      else if(_scrollController.offset <= _scrollController.position.minScrollExtent  && !_scrollController.position.outOfRange){
        print("Start of List");
        setState(() {
          _isUpperContainerExpanded = true;
          _notAtStartUpdateLock = false;
        });
      }
  }







  Widget _generalInfoCard()
  {

    print("IsGenenral : " + _isGeneralDetailsExpanded.toString());

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: _isGeneralDetailsExpanded ? _cardExpandedHeight : _cardContractedHeight,
          width: _cardWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: _isGeneralDetailsExpanded ? Colors.transparent : Colors.grey[850],
                blurRadius: 5,
                spreadRadius: 2.5,
              //  offset: Offset(5,5),
              ),
            ],
            color: Colors.grey[900],
          ),
          child: Container(
            padding: EdgeInsets.only(left: _height * 0.125,right: _width * 0.05),                         /// ////////////////////
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _isEditable ? Container(
                  height: _cardExpandedHeight * 0.16,
                  width: _width * 0.6,
                  child: TextField(
                    controller: _nameController,
                    style: TextStyle(color: Colors.white),
                    enabled: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      labelText: "Name",
                      labelStyle: TextStyle(color: Colors.greenAccent),
                      hintText: "Name ",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,width: 1.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent,width: 1.5),
                      ),
                    ),
                  ),
                ) : AutoSizeText("Name : " + _savedUser.user.name,style: TextStyle(color: Colors.white,fontSize: _cardExpandedHeight * 0.06,),maxLines: 1,),
                _isEditable ? Container(
                  height: _cardExpandedHeight * 0.16,
                  width: _width * 0.6,
                  child: TextField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white),
                    enabled: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      labelText: "Email-id",
                      labelStyle: TextStyle(color: Colors.greenAccent),
                      hintText: "Email-id ",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,width: 1.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent,width: 1.5),
                      ),
                    ),
                  ),
                ) : AutoSizeText("Email-id : " + _savedUser.user.email,style: TextStyle(color: Colors.white,fontSize: _cardExpandedHeight * 0.06),maxLines: 1,),
                _isEditable ? Container(
                  height: _cardExpandedHeight * 0.16,
                  width: _width * 0.6,
                  child: TextField(
                    controller: _passController,
                    style: TextStyle(color: Colors.white),
                    enabled: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.greenAccent),
                      hintText: "Password ",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,width: 1.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent,width: 1.5),
                      ),
                    ),
                  ),
                ) : AutoSizeText("Password : " + _savedUser.user.password,style: TextStyle(color: Colors.white,fontSize: _cardExpandedHeight * 0.06),maxLines: 1,),
                _isEditable ? Container(
                  height: _cardExpandedHeight * 0.16,
                  width: _width * 0.6,
                  child: TextField(
                    controller: _phoneController,
                    style: TextStyle(color: Colors.white),
                    enabled: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      labelText: "Phone",
                      labelStyle: TextStyle(color: Colors.greenAccent),
                      hintText: "Phone No. ",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,width: 1.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent,width: 1.5),
                      ),
                    ),
                  ),
                ) : AutoSizeText("Phone : " + _savedUser.user.phone,style: TextStyle(color: Colors.white,fontSize: _cardExpandedHeight * 0.06),maxLines: 1,),
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 200),
          left: _isGeneralDetailsExpanded ? -_height * 0.20 : 0,
          child: RotationTransition(
            turns: _tweenRotation.animate(_animationController),
            child: InkWell(
              onTap: (){
                if(_isGeneralDetailsExpanded)
                  _animationController.reverse();
                else
                  _animationController.forward();
                setState(() {
                    _cardStateCheck(0);
                    _isExtraCard1Expanded = false;
                    _isExtraCard2Expanded = false;
                    _isGeneralDetailsExpanded = !_isGeneralDetailsExpanded;
                    _isUpperContainerExpanded = false;
                    if(!_isGeneralDetailsExpanded && !_isExtraCard1Expanded && !_isExtraCard2Expanded)
                      _isUpperContainerExpanded = true;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.greenAccent,
                  border: Border.all(color: Colors.grey[900],width: 1)
                ),
                height: _cardLabelHeight,
                width: _isGeneralDetailsExpanded ? _cardLabelExpandedWidth : _width * 0.9, // = _cardLabelContractedWidth,
                child: Center(child: Text("General Info.",style: TextStyle(color: Colors.grey[900],fontWeight: FontWeight.bold,fontSize: _cardLabelHeight * 0.4),),),
              ),
            ),
          ),
        ),
      ],
    );
  }



  Widget _extraCard1()
  {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: _isExtraCard1Expanded ? _cardExpandedHeight : _cardContractedHeight,
          width: _cardWidth,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: _isExtraCard1Expanded ? Colors.transparent : Colors.grey[850],
                blurRadius: 5,
                spreadRadius: 2.5,
               // offset: Offset(5,5),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.grey[900],
          ),
          child: Container(
            padding: EdgeInsets.only(left: _height * 0.125,right: _width * 0.05),                         /// ////////////////////
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: _cardExpandedHeight * 0.16,
                  width: _width * 0.6,
                  child:TextField(
                    style: TextStyle(color: Colors.white),
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: "Linkedn ID :  ",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,width: 1.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent,width: 1.5),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: _cardExpandedHeight * 0.16,
                  width: _width * 0.6,
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: "GitHub ID ",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,width: 1.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent,width: 1.5),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: _cardExpandedHeight * 0.16,
                  width: _width * 0.6,
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: "Some Other ID ",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,width: 1.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent,width: 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 200),
          left: _isExtraCard1Expanded ? -_height * 0.20 : 0,
          child: RotationTransition(
            turns: _tweenRotation1.animate(_animationController1),
            child: InkWell(
              onTap: (){
                if(_isExtraCard1Expanded)
                  _animationController1.reverse();
                else
                  _animationController1.forward();
                setState(() {
                    _cardStateCheck(1);
                    _isGeneralDetailsExpanded = false;
                    _isExtraCard2Expanded = false;
                    _isExtraCard1Expanded = !_isExtraCard1Expanded;
                    _isUpperContainerExpanded = false;
                    if(!_isGeneralDetailsExpanded && !_isExtraCard1Expanded && !_isExtraCard2Expanded)
                      _isUpperContainerExpanded = true;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.greenAccent,border: Border.all(color: Colors.grey[900],width: 2)),
                height: _cardLabelHeight,
                width: _isExtraCard1Expanded ? _cardLabelExpandedWidth : _width * 0.9, // = _cardLabelContractedWidth,
                child: Center(child: Text("Profile Links",style: TextStyle(color: Colors.grey[900],fontWeight: FontWeight.bold,fontSize: _cardLabelHeight * 0.4),),),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _extraCard2()
  {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: _isExtraCard2Expanded ? _cardExpandedHeight : _cardContractedHeight,
          width: _cardWidth,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: _isExtraCard2Expanded ? Colors.transparent : Colors.grey[850],
                blurRadius: 5,
                spreadRadius: 2.5,
             //   offset: Offset(5,5),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.grey[900],
          ),
          child: Container(
              padding: EdgeInsets.only(left: _height * 0.125,right: _width * 0.05),                         /// ////////////////////
              child: Container(color: Colors.grey,)
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 200),
          left: _isExtraCard2Expanded ? -_height * 0.20 : 0,
          child: RotationTransition(
            turns: _tweenRotation2.animate(_animationController2),
            child: InkWell(
              onTap: (){
                if(_isExtraCard2Expanded)
                  _animationController2.reverse();
                else
                  _animationController2.forward();
                setState(() {
                    _cardStateCheck(2);
                    _isGeneralDetailsExpanded = false;
                    _isExtraCard1Expanded = false;
                    _isExtraCard2Expanded = !_isExtraCard2Expanded;
                    _isUpperContainerExpanded = false;
                    if(!_isGeneralDetailsExpanded && !_isExtraCard1Expanded && !_isExtraCard2Expanded)
                      _isUpperContainerExpanded = true;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.greenAccent,border: Border.all(color: Colors.grey[900],width: 2)),
                height: _cardLabelHeight,
                width: _isExtraCard2Expanded ? _cardLabelExpandedWidth : _width * 0.9, // = _cardLabelContractedWidth,
                child: Center(child: Text("Some Other Info.",style: TextStyle(color: Colors.grey[900],fontWeight: FontWeight.bold,fontSize: _cardLabelHeight * 0.4),),),
              ),
            ),
          ),
        ),
      ],
    );
  }


  void _cardStateCheck(int index)                 // i = {0,1,2} : i => i+1 th card index is expanded
  {
    if(index == 0){
      if(_isExtraCard2Expanded)
        _animationController2.reverse();
      if(_isExtraCard1Expanded)
        _animationController1.reverse();
    }
    else if(index == 1){
      if(_isExtraCard2Expanded)
        _animationController2.reverse();
      if(_isGeneralDetailsExpanded)
        _animationController.reverse();
    }
    else if(index == 2){
      if(_isGeneralDetailsExpanded)
        _animationController.reverse();
      if(_isExtraCard1Expanded)
        _animationController1.reverse();
    }
  }
}





// FlatButton(onPressed: (){_firebaseAPI.signOut();_savedUser.setUser(null);},color: Colors.greenAccent,child: Text("Logout",style: TextStyle(color: Colors.black),),)



/*

NotificationListener(
                    onNotification: (notification){
                      if( notification is ScrollStartNotification)            // if u start scrolling
                        print("scroll Start");
                      else if(notification is ScrollEndNotification)          // if your scroll motion ends
                        print("scroll End");
                      return true;
                    },
                    child: ListView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      children: [
                        Container(height: _height * 0.5,color: Colors.redAccent,),
                        Container(height: _height * 0.5,color: Colors.yellowAccent,),
                      ],
                    ),
                  ),

 */

