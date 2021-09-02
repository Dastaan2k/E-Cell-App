import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testappog/API/Firebase_Auth.dart';
import 'package:testappog/API/Firestore.dart';
import 'package:testappog/CustomColor.dart';
import 'package:testappog/DataModel/User.dart';
import 'package:testappog/SavedUser.dart';
import 'package:testappog/ScenePackages/ProjectPage.dart';

import 'DataModel/Project.dart';

class SecondaryScene extends StatefulWidget {
  @override
  _SecondarySceneState createState() => _SecondarySceneState();
}

class _SecondarySceneState extends State<SecondaryScene> {

  double _width;
  double _height;
  int _activeNotifIndex = 0;
  int _activeIndex = 99;

  FirestoreAPI _firestoreAPI = FirestoreAPI();

  Widget _pendingUserList;
  Widget _pendingProjectList;

  bool _pseudoInitState = false;

  bool _isPendingUserCardExpanded = false;
  bool _isPendingProjectCardExpanded = false;

  double _profileContainerHeight;
  double _profileContainerWidth;
  double _avatarDiameter;
  double _profileDetailContainerWidth;
  double _profileDetailContainerHeight;
  double _lowerProfileContainerHeight;
  double _notificationContainerHeight;
  double _notificationContainerWidth;

  Widget _activeNotificationContainer;

  Widget _memberRegContainer;
  Widget _projectRegContainer;
  Widget _generalNotificationContainer;

  List<dynamic> tempUserList = List<dynamic>();
  List<dynamic> tempProjectList = List<dynamic>();

  SavedUser _savedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _savedUser = Provider.of<SavedUser>(context);

    return LayoutBuilder(

        builder : (context,constraints){

          _width = constraints.constrainWidth();
          _height = constraints.constrainHeight();

          _profileContainerWidth = _width * 0.7;
          _profileContainerHeight = _height * 0.295;
          _avatarDiameter = _profileContainerWidth * 0.3;
          _profileDetailContainerHeight = _avatarDiameter;
          _profileDetailContainerWidth = _profileContainerWidth - _avatarDiameter - (_width * 0.03);
          _lowerProfileContainerHeight = _profileContainerHeight * 0.35;
          _notificationContainerHeight = _height * 0.625;
          _notificationContainerWidth = _width * 0.7;

          if(!_pseudoInitState){

         _pendingUserList = StreamBuilder<QuerySnapshot>(                                   ///  Consuming two reads ...... try calling it on onEnd
              stream: Firestore.instance.collection('Pending').snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshots){

                tempUserList.clear();

                if(snapshots.hasData){

                  snapshots.data.documents[0].data["Users"].forEach((user){
                    tempUserList.add(user);
                  });


                  return ListView.builder(
                    key: Key(Random.secure().nextDouble().toString()),
                    padding: EdgeInsets.only(top: 0),
                      itemCount: tempUserList.length,
                      itemBuilder: (BuildContext context,int index){

                    return _userNotificationCard(100, _notificationContainerWidth * 0.935,tempUserList[index],index);
                  });
                }
                else
                  return Container(child: Center(child: Text("No Data Available",style: TextStyle(color: Colors.white),),),);
              },
            );

          _pendingProjectList = StreamBuilder(
            stream: Firestore.instance.collection('Pending Projects').snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshots){

              tempProjectList.clear();

              if(snapshots.hasData){

                snapshots.data.documents[0].data["Projects"].forEach((project){
                  tempProjectList.add(project);
                });

                return ListView.builder(
                    key: Key(Random.secure().nextDouble().toString()),
                    padding: EdgeInsets.only(top: 0),
                    itemCount: tempProjectList.length,
                    itemBuilder: (BuildContext context,int index){
                  return _projectNotificationCard(100, _notificationContainerWidth * 0.935,tempProjectList[index],index);
                });
              }
              else
                return Container(child: Center(child: Text("No Data Available",style: TextStyle(color: Colors.white),),),);
            },
          );


          _pseudoInitState = true;
          }


          _generalNotificationContainer = Center(
            child: AutoSizeText("No new Notification",style: TextStyle(color: Colors.white),maxLines: 1,),
          );


          _memberRegContainer = Align(
            alignment: Alignment.topCenter,
            child: InkWell(
              onTap: (){
                setState(() {
                  _isPendingUserCardExpanded = true;
                });
              },
              child: AnimatedContainer(
                key: Key("MemberContainer"),
                padding: EdgeInsets.all(_isPendingUserCardExpanded ? 0 : 10),
                duration: Duration(milliseconds: 200),
                height: _isPendingUserCardExpanded ? _notificationContainerHeight : 50,
                width: _width * 0.65,
                decoration: BoxDecoration(
                  color: _isPendingUserCardExpanded ? Colors.transparent : Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _isPendingUserCardExpanded ? Colors.transparent : Colors.grey[900],width: 1),
                ),
                child: _isPendingUserCardExpanded  ? _pendingUserList : Center(child: AutoSizeText("Pending Users",style: TextStyle(color: Colors.grey[900]),maxLines: 1,)),
              ),
            ),
          );

         _projectRegContainer = Align(
            alignment: Alignment.topCenter,
            child: InkWell(
              onTap: (){
                setState(() {
                  _isPendingProjectCardExpanded = true;
                });
                /*  _firestoreAPI.getPendingProjects().then((projects){
                    setState(() {
                      for(int i=0;i<projects.length;i++){
                        _pendingProjectList.add(_projectNotificationCard(100, _notificationContainerWidth * 0.935));
                      }
                      _isPendingProjectCardExpanded = true;
                    });
                  });   */
              },
              child: AnimatedContainer(
                key: Key("ProjectContainer"),
                padding: EdgeInsets.all(_isPendingProjectCardExpanded ? 0 : 10),
                duration: Duration(milliseconds: 200),
                height: _isPendingProjectCardExpanded ? _notificationContainerHeight  : 50,
                width: _width * 0.65,
                decoration: BoxDecoration(
                  color: _isPendingProjectCardExpanded ? Colors.transparent/*Colors.blue*/ : Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _isPendingProjectCardExpanded ? Colors.transparent : Colors.grey[900],width: 1),
                ),
                child: _isPendingProjectCardExpanded  ? _pendingProjectList : Center(child: AutoSizeText("Pending Projects",style: TextStyle(color: Colors.grey[900]),maxLines: 1,)),
              ),
            ),
          );



          print(_activeNotifIndex);

         if(_activeNotifIndex == 0 ){
           _activeNotificationContainer = _memberRegContainer;
         }
         else if(_activeNotifIndex == 1){
             _activeNotificationContainer = _projectRegContainer;
         }
         else{
           _activeNotificationContainer = _generalNotificationContainer;
         }


          return Container(
            width: _width,
            height: _height,
            child: Row(
              children: [
                Container(
                  width: _width * 0.7,
                  height: _height,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
                  ),
                  child : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: _profileContainerWidth,
                        height: _profileContainerHeight,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(2,0),
                              color: Colors.black,
                              blurRadius: 5
                          ),],
                          color: HexColor("#2E2E2E"),borderRadius: BorderRadius.only(topRight: Radius.circular(30))),
                        child: Container(
                          width: _profileContainerWidth * 0.9,
                          height: _profileContainerHeight * 0.9,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                                Container(height: _profileContainerHeight * 0.9,width: _profileContainerWidth * 0.9),
                                Positioned(
                                  bottom: _profileContainerHeight * 0.4,
                                  left: _width * 0.03,
                                  child: Container(
                                    height: _avatarDiameter,width: _avatarDiameter,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(_avatarDiameter/2)),
                                      border: Border.all(color: Colors.greenAccent,width: 2),
                                      image: DecorationImage(
                                        image: AssetImage("assets/d2k.jpg"),
                                        fit: BoxFit.fill,
                                      )
                                    ),
                                  ),
                                ),
                              Positioned(
                                right: 0,
                                bottom: _profileContainerHeight * 0.4,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: _profileDetailContainerWidth * 0.1),
                                  width: _profileDetailContainerWidth,
                                  height: _profileDetailContainerHeight,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(_savedUser.user.name,style: TextStyle(color: Colors.greenAccent,fontSize: _profileDetailContainerWidth * 0.12,fontWeight: FontWeight.bold,fontFamily: "Roboto"),maxLines: 1,),
                                      Container(height: _profileDetailContainerHeight * 0.13,),
                                      AutoSizeText("Branch : " + _savedUser.user.branch,style: TextStyle(color: Colors.white,fontSize: _profileDetailContainerWidth * 0.07,fontFamily: "Roboto"),),
                                      AutoSizeText("Field    :  " + "Software",style: TextStyle(color: Colors.white,fontSize: _profileDetailContainerWidth * 0.07,fontFamily: "Roboto")),
                                      Padding(
                                        padding: EdgeInsets.only(top: _profileDetailContainerHeight * 0.16),
                                        child: Container(height: 1, width: _profileDetailContainerWidth * 0.9, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(0.5))),),
                                      ),
                                    ],
                                  ),
                                  ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding: EdgeInsets.only(bottom: _lowerProfileContainerHeight * 0.125,left: _width * 0.025,right: _width * 0.025),
                                  height: _lowerProfileContainerHeight,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(children: [Container(child: Center(child: Row(children: [Text("67",style: TextStyle(color: Colors.greenAccent,fontSize: _width * 0.05,fontFamily: "Roboto",fontWeight: FontWeight.bold),),Text("%",style: TextStyle(color: Colors.white,fontSize: _width * 0.035),)],mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.center,)),width: _width * 0.2,height: _lowerProfileContainerHeight*0.6,),Container(width: _width * 0.2,height: _lowerProfileContainerHeight * 0.2,child: Center(child: Text("Attendance",style: TextStyle(color: Colors.white,fontSize: _lowerProfileContainerHeight * 0.17),)),)],),
                                      Column(children: [Container(width: _width * 0.2,height: _lowerProfileContainerHeight*0.6,child: Center(child: Text("10",style: TextStyle(color: Colors.greenAccent,fontSize: _width * 0.05,fontWeight: FontWeight.bold,fontFamily: "Roboto"),),),),Container(width: _width * 0.2,height: _lowerProfileContainerHeight * 0.2,child: Center(child: Text("Projects",style: TextStyle(color: Colors.white,fontSize: _lowerProfileContainerHeight * 0.17))),)],),
                                      Column(children: [Container(width: _width * 0.2,height: _lowerProfileContainerHeight*0.6,child: Center(child: AutoSizeText("Active",maxLines:1,style: TextStyle(color: Colors.greenAccent,fontFamily: "Roboto",fontWeight: FontWeight.bold,fontSize: _width * 0.05),),),),Container(width: _width * 0.2,height: _lowerProfileContainerHeight * 0.2,child: Center(child: Text("Status",style: TextStyle(color: Colors.white,fontSize: _lowerProfileContainerHeight * 0.17))),)],),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ),
                      Expanded(
                        child : Container(
                            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                            child: _activeNotificationContainer
                        ),
                      ),
                      Container(
                        height: _height * 0.08,decoration: BoxDecoration(
                        boxShadow: [BoxShadow(
                            offset: Offset(2,0),
                            color: Colors.black,
                            blurRadius: 5
                        ),],
                        color: Colors.grey[850],),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Follow us on :    ",style: TextStyle(color: Colors.greenAccent,fontSize: _height * 0.025),),
                              InkWell(child: Icon(Icons.add,color: Colors.greenAccent,size: _height * 0.03,),onTap: (){},),
                              InkWell(child: Icon(Icons.add,color: Colors.greenAccent,size: _height * 0.03),onTap: (){},),
                              InkWell(child: Icon(Icons.add,color: Colors.greenAccent,size: _height * 0.03),onTap: (){},),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: _height * 0.3,
                      //   color: Colors.orange,
                      child: Container(
                        child: Transform.rotate(angle: 1.5707,child: Image.asset("assets/ecell_dark.png"),),
                      ),
                    ),
                    InkWell(
                        onTap: (){setState(() {
                          _activeNotifIndex = 0;
                          //_activeNotificationContainer = _memberNotifContainer;
                        });},
                        child: RotatedBox(
                            quarterTurns: 1,
                            child: Container(
                              child:Center(child: AutoSizeText("Member Reg.",style: TextStyle(color:_activeNotifIndex == 0?Colors.greenAccent:Colors.white,fontSize: _width * 0.04))),
                              height: _width * 0.1,
                              width: _height * 0.2,
                              decoration: BoxDecoration(
                                  boxShadow: [_activeNotifIndex == 0 ? BoxShadow(
                                      offset: Offset(0,-2.5),
                                      color: Colors.black,
                                      blurRadius: 1
                                  ) : BoxShadow(color: Colors.transparent)],
                                  color: _activeNotifIndex == 0?HexColor("#424242"):Colors.transparent,borderRadius: BorderRadius.only(topRight: Radius.circular(_width * 0.09),topLeft: Radius.circular(_width * 0.045))
                              ),
                            )
                        )
                    ),
                    InkWell(
                        onTap: (){
                          setState(() {
                            _activeNotifIndex = 1;
                          });
                        },
                        child: RotatedBox(
                            quarterTurns: 1,
                            child: Container(
                              child:Center(child: AutoSizeText("Project Reg.",style: TextStyle(color: _activeNotifIndex == 1?Colors.greenAccent:Colors.white,fontSize: _width * 0.04))),
                              height: _width * 0.1,
                              width: _height * 0.2,
                              decoration: BoxDecoration(
                                  boxShadow: [_activeNotifIndex == 1 ? BoxShadow(
                                      offset: Offset(0,-2.5),
                                      color: Colors.black,
                                      blurRadius: 1
                                  ) : BoxShadow(color: Colors.transparent)],
                                  color: _activeNotifIndex == 1?HexColor("#424242"):Colors.transparent,borderRadius: BorderRadius.only(topRight: Radius.circular(_width * 0.09),topLeft: Radius.circular(_width * 0.045))
                              ),
                            )
                        )
                    ),
                    InkWell(
                        onTap: (){setState(() {
                          _activeNotifIndex = 2;
                         // _activeNotificationContainer = _generalNotifContainer;
                        });},
                        child: RotatedBox(
                            quarterTurns: 1,
                            child: Container(
                              child:Center(child: AutoSizeText("General",maxLines:1,style: TextStyle(color: _activeNotifIndex == 2?Colors.greenAccent:Colors.white,fontSize: _width * 0.04),)),
                              height: _width * 0.1,
                              width: _height * 0.2,
                              decoration: BoxDecoration(
                                  boxShadow: [_activeNotifIndex == 2 ? BoxShadow(
                                      offset: Offset(0,-2.5),
                                      color: Colors.black,
                                      blurRadius: 1
                                  ) : BoxShadow(color: Colors.transparent)],
                                  color: _activeNotifIndex == 2?HexColor("#424242"):Colors.transparent,borderRadius: BorderRadius.only(topRight: Radius.circular(_width * 0.09),topLeft: Radius.circular(_width * 0.045))
                              ),
                            )
                        )
                    ),
                  ],
                ))
              ],
            ),
          );
        }
    );
  }


  Widget _userNotificationCard(double cardHeight,double cardWidth,Map<dynamic,dynamic> user,int index){

    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[900],width: 1),
          boxShadow: [
            BoxShadow(offset: Offset(0,5),color: Colors.grey[850],blurRadius: 5,spreadRadius: 2.5),
          ],
          color: HexColor("#2E2E2E"),
          borderRadius: BorderRadius.circular(10),
        ),
        width: cardWidth,
        height: cardHeight,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Align(alignment: Alignment.centerLeft,child: AutoSizeText(user["Name"],style: TextStyle(color: Colors.greenAccent,fontWeight: FontWeight.bold,fontSize: cardHeight * 0.2),maxLines: 1,)),
                    ),
                    Expanded(
                      flex: 4,     ///   /////////////////      This to be replaced by Branch and year of user
                      child: Align(alignment: Alignment.topLeft,child: AutoSizeText("TE-A COMPS",style: TextStyle(color: Colors.white,fontSize: cardHeight * 0.08),maxLines: 1,)),
                    ),
                ]
                    )
                ),
              ),
            Expanded(
              flex: 2,
              child: Center(
                child: InkWell(
                    onTap: (){
                      tempUserList.remove(tempUserList[index]);
                      _firestoreAPI.deleteUserFromPending(tempUserList);
                    },
                    child: Icon(Icons.clear,color: Colors.red,)
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: InkWell(
                    onTap: (){
                      tempUserList.remove(tempUserList[index]);
                      _firestoreAPI.registerUserFromPending(_savedUser.user.email,_savedUser.user.password,user["Name"], user["Email"], user["Password"], "Dummy Branch", user["Phone"],tempUserList).then((value){
                       //Scaffold.of(context).showSnackBar(SnackBar(content: Text(value),duration: Duration(seconds: 1),));
                      });
                    },
                    child: Icon(Icons.check,color: Colors.greenAccent,)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _projectNotificationCard(double cardHeight,double cardWidth,Map<dynamic,dynamic> project,int index){

    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[900],width: 1),
          boxShadow: [
            BoxShadow(offset: Offset(0,5),color: Colors.grey[850],blurRadius: 5,spreadRadius: 2.5),
          ],
          color: HexColor("#2E2E2E"),
          borderRadius: BorderRadius.circular(10),
        ),
        width: cardWidth,
        height: cardHeight,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Align(alignment: Alignment.centerLeft,child: AutoSizeText(project["Name"],style: TextStyle(color: Colors.greenAccent,fontWeight: FontWeight.bold,fontSize: cardHeight * 0.2),maxLines: 1,)),
                    ),
                    Expanded(
                      flex: 3,
                      child: Align(alignment: Alignment.centerLeft,child: AutoSizeText(project["Field"],style: TextStyle(color: Colors.white,fontSize: cardHeight * 0.08),maxLines: 1,)),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Align(alignment: Alignment.centerLeft,child: AutoSizeText("Registered by : " + project["CreatedBy"],style: TextStyle(color: Colors.grey,fontSize: cardHeight * 0.08),maxLines: 1,),),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: InkWell(
                    onTap: (){
                      tempProjectList.removeAt(index);
                      _firestoreAPI.deleteProjectFromPending(tempProjectList);
                    },
                    child: Icon(Icons.clear,color: Colors.red,)
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: InkWell(
                  onTap: (){
                    tempProjectList.removeAt(index);

                    _firestoreAPI.registerProjectFromPending(project["Name"], project["Field"], project["SubField"], project["Members"], project["CreatedBy"], project["Description"],tempProjectList);
                    },
                    child: Icon(Icons.check,color: Colors.greenAccent,)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}






