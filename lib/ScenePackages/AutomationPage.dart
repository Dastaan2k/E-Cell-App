import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutomationPage extends StatefulWidget {
  @override
  _AutomationPageState createState() => _AutomationPageState();
}

class _AutomationPageState extends State<AutomationPage> {

  List<Animation> _activeCardIndex = [Animation.DISABLE,Animation.DISABLE];

  double _height;
  double _width;

  double _expandedCardHeight;
  double _minCardHeight;

  Widget _minCardContent;
  Widget _expandedCardContent;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder : (context,constraints) {
          _height = constraints.constrainHeight();
          _width = constraints.constrainWidth();

          _minCardHeight = _height * 0.3  - (_height * 0.035) * 2.0;
          _expandedCardHeight = _height * 0.65 - _minCardHeight  - _height * 0.075 - _height * 0.035;

          _minCardContent = Container(
            height: _minCardHeight,
            width: _width * 0.8,
            child: Container(
            //  color: Colors.yellowAccent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Room 1 :",style: TextStyle(fontSize: _minCardHeight * 0.25,fontFamily: "Roboto",fontWeight: FontWeight.bold),),
                  Container(height: _minCardHeight * 0.1,),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Available Devices : ",style: TextStyle(fontSize: _minCardHeight * 0.15),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: Icon(Icons.airplay,color: Colors.grey[800],),onPressed: (){},color: Colors.grey,),
                            IconButton(icon: Icon(Icons.laptop_mac,color: Colors.grey[800],),onPressed: (){},color: Colors.grey,),
                            IconButton(icon: Icon(Icons.desktop_mac,color: Colors.grey[800],),onPressed: (){},color: Colors.grey,),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );

          _expandedCardContent = AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: _activeCardIndex[0] == Animation.DISABLE ? 0 : _expandedCardHeight,
            width: _width * 0.85,
          //  color: Colors.orange,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             //   mainAxisSize: MainAxisSize.min,
              children: [
                Text("Status : ",style: TextStyle(fontSize: _expandedCardHeight * 0.15,fontWeight: FontWeight.bold),),
                Row(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.start,children: [Text("Device 1   ",style: TextStyle(fontSize: _expandedCardHeight * 0.1),),Switch(onChanged: (val){},value: false,),],),
                Row(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.start,children: [Text("Device 2   ",style: TextStyle(fontSize: _expandedCardHeight * 0.1),),Switch(onChanged: (val){},value: false,),],),
                Row(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.start,children: [Text("Device 3   ",style: TextStyle(fontSize: _expandedCardHeight * 0.1),),Switch(onChanged: (val){},value: false,),],),
              ],
            ),
          );






          return Container(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: _width * 0.05,right: _width * 0.05,top: _height * 0.05),
                      child: AnimatedContainer(
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.all(Radius.circular(_width * 0.03))
                        ),
                        padding: EdgeInsets.symmetric(vertical: _height * 0.035,horizontal: _width * 0.05),
                        duration: Duration(milliseconds: 200),
                    //    height: _activeCardIndex[0] == Animation.DISABLE ? 0 : _height * 0.3,
                        height: _activeCardIndex[0] == Animation.DISABLE ? _height * 0.3 : _height * 0.65,
                        child: Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            _minCardContent,
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _minCardContent,
                                AnimatedContainer(duration: Duration(milliseconds: 200),height: _activeCardIndex[0] == Animation.DISABLE? 0 : _height * 0.035,),
                                _expandedCardContent,
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Transform.rotate(
                                angle: _activeCardIndex[0] == Animation.DISABLE ? 0 : 3.14,
                                child: InkWell(onTap: (){setState(() {
                                  if(_activeCardIndex[0] == Animation.DISABLE)
                                    _activeCardIndex[0] = Animation.ENABLE;
                                  else
                                    _activeCardIndex[0] = Animation.DISABLE;
                                });},
                                    child: Icon(Icons.details,color: Colors.grey[900],)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ]
            ),
          );

        }
    );
  }
}

enum Animation
{
  DISABLE,
  IN_PROGRESS,
  ENABLE,
}