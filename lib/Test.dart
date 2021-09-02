import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {

  double _width;
  double _height;

  bool _animationToggle = false;

  Widget _backGround;
  Widget _frontScene;
  Widget _backDrawer;
  Widget _logoContainer;

  Widget _backLayer;
  Widget _mainLayer;

  double _frontSceneNewWidth;
  double _frontSceneNewHeight;

  int _activeNotifIndex = 0;

  @override
  Widget build(BuildContext context) {

    print("Active : " + _activeNotifIndex.toString());

    return GestureDetector(
      onPanUpdate: (details){
        if(details.delta.dx < 3){
          print("Right Swipe");
          setState(() {
            _animationToggle = false;
          });
        }
        else if(details.delta.dx > -3){
          print("Left Swipe");
          setState(() {
            _animationToggle = true;
          });
        }
      },
      child: LayoutBuilder(
        builder: (context,constraints){

          _width = constraints.constrainWidth();
          _height = constraints.constrainHeight();

          _frontSceneNewWidth = _width * 0.9;
          _frontSceneNewHeight = _height * 0.7;

          _backGround = Container(width: _width,height: _height,color: Colors.grey[900],);

          _mainLayer = AnimatedPositioned(
         //   curve: Curves.bounceOut,
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
                child: Scaffold(
                  backgroundColor: Colors.grey[700],
                  appBar: AppBar(
                    backgroundColor: Colors.grey[800],
                    title: Text("Home Page",style: TextStyle(color: Colors.greenAccent,fontWeight: FontWeight.bold,fontSize: _height * 0.035),),
                    actions: [IconButton(icon: Icon(Icons.perm_identity,color: Colors.grey,size: _height * 0.05,),onPressed: (){},)],
                  ),
                ),
              ),
            ),
          );


          _backLayer = Container(
            width: _width,
            height: _height,
            child: Row(
              children: [
                  Container(
                    width: _width * 0.7,
                    height: _height,
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                         borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
                    ),
                    child : Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(height: _height * 0.3,decoration: BoxDecoration(color: Colors.grey[800],borderRadius: BorderRadius.only(topRight: Radius.circular(30))),),
                        Expanded(child: Container(color: Colors.greenAccent,child: Center(child: Text("No recent notifications",style: TextStyle(color: Colors.grey[900]),),),),),
                        Container(
                          height: _height * 0.08,decoration: BoxDecoration(color: Colors.grey[700],borderRadius: BorderRadius.only(topLeft: Radius.circular(_height * 0.015),topRight: Radius.circular(_height * 0.015))),
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
                        });},
                        child: RotatedBox(
                            quarterTurns: 1,
                            child: Container(
                              child:Center(child: AutoSizeText("General",maxLines:1,style: TextStyle(color: _activeNotifIndex == 0?Colors.grey[900]:Colors.white,fontSize: _width * 0.04),)),
                              height: _width * 0.1,
                              width: _height * 0.2,
                              decoration: BoxDecoration(color: _activeNotifIndex == 0?Colors.greenAccent:Colors.transparent,borderRadius: BorderRadius.only(topRight: Radius.circular(_width * 0.08),topLeft: Radius.circular(_width * 0.08))),
                            )
                        )
                    ),
                    InkWell(
                        onTap: (){setState(() {
                          _activeNotifIndex = 1;
                        });},
                        child: RotatedBox(
                            quarterTurns: 1,
                            child: Container(
                              child:Center(child: AutoSizeText("Member Reg.",style: TextStyle(color:_activeNotifIndex == 1?Colors.grey[900]:Colors.white,fontSize: _width * 0.04))),
                              height: _width * 0.1,
                              width: _height * 0.2,
                              decoration: BoxDecoration(color: _activeNotifIndex == 1?Colors.greenAccent:Colors.transparent,borderRadius: BorderRadius.only(topRight: Radius.circular(_width * 0.08),topLeft: Radius.circular(_width * 0.08))),
                            )
                        )
                    ),
                    InkWell(
                        onTap: (){setState(() {
                          _activeNotifIndex = 2;
                        });},
                        child: RotatedBox(
                            quarterTurns: 1,
                            child: Container(
                              child:Center(child: AutoSizeText("Project Reg.",style: TextStyle(color: _activeNotifIndex == 2?Colors.grey[900]:Colors.white,fontSize: _width * 0.04))),
                              height: _width * 0.1,
                              width: _height * 0.2,
                              decoration: BoxDecoration(color: _activeNotifIndex == 2?Colors.greenAccent:Colors.transparent,borderRadius: BorderRadius.only(topRight: Radius.circular(_width * 0.08),topLeft: Radius.circular(_width * 0.08))),
                            )
                        )
                    ),
                  ],
                ))
              ],
            ),
          );

          _logoContainer = Container(
            width: _height* 0.2,
            height: _width * 0.2,
            decoration: BoxDecoration(
              color: Colors.orange,
              image: DecorationImage(
                image: AssetImage("assets/ecell_dark.png"),
                fit: BoxFit.fill,
              )
            ),
          );

          return Scaffold(
            body: Stack(
              alignment: Alignment.centerRight,
              children: [
                _backGround,
                _backLayer,
                _mainLayer,
              ],
            ),
          );
        },
      ),
    );
  }
}
