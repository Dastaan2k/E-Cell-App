import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testappog/SceneManager.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double _height;
  double _width;

  PageController _pageController = PageController();
  SceneManager _manager;

  List<Widget> _newsList;

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {

    _manager = Provider.of<SceneManager>(context);


    print("Home Page called by Sarvesh Dalvi");

    return LayoutBuilder(
      builder: (context,constraints){

        _height = constraints.constrainHeight();
        _width = constraints.constrainWidth();

        _newsList = [
          Container(height: _height/3,decoration: BoxDecoration(image: DecorationImage(image: Image.asset('assets/project_1.jpg'),fit: BoxFit.contain),)),
          Container(height: _height/3,decoration: BoxDecoration(image: DecorationImage(image: Image.asset('assets/project_2.jpg'),fit: BoxFit.contain),)),
          Container(height: _height/3,decoration: BoxDecoration(image: DecorationImage(image: Image.asset('assets/project_3.jpg'),fit: BoxFit.contain),)),
          Container(height: _height/3,decoration: BoxDecoration(image: DecorationImage(image: Image.asset('assets/project_1.jpg'),fit: BoxFit.contain),)),
          Container(height: _height/3,color: Colors.indigo,),
          Container(height: _height/3,color: Colors.grey,),
        ];

        return Container(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                  Padding(
                    padding: EdgeInsets.only(left: _width* 0.05,right: _width*0.05,top: _height * 0.05),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10),),
                      child: Container(
                        decoration: BoxDecoration(
                        ),
                        height: _height/3,
                        child: PageView(
                          onPageChanged: (index){
                            setState(() {
                                setState(() {
                                  activeIndex = index;
                                });
                            });
                          },
                          children: _newsList,
                        ),
                      ),
                    ),
                  ),
                Container(
                  width: _width,
                  height: _height * 0.08,
                //  color: Colors.yellowAccent,
                  child: Center(
                    child : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(6, (index){
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: index == activeIndex ? Colors.greenAccent : Colors.transparent,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.white,width: 2),
                            ),
                          ),
                        );
                      })
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: _width * 0.95,
                    height: _height * 0.35,
                   // color: Colors.orange,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: _width * 0.7,
                          height: _height * 0.1,
                          child: Align(alignment: Alignment.centerLeft,child: AutoSizeText("New Projects in E-Cell : ",style: TextStyle(color: Colors.greenAccent,fontWeight: FontWeight.bold,fontSize: _width * 0.06),)),
                        ),
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              projectCard(_height * 0.3, 250, "New Project", "Software"),
                              projectCard(_height * 0.3, 250, "Fitness App", "Software"),
                              projectCard(_height * 0.3, 250, "RFID", "Hardware"),
                              projectCard(_height * 0.3, 250, "Ecell Automation", "Hybrid"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
        );
      },
    );
  }
}


Widget projectCard(double height,double width,String title,String field)
{
  return Padding(
    padding: EdgeInsets.only(right: 15),
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.all(
          Radius.circular(height*0.05),
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(bottom: width * 0.05,left: width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: height * 0.1),),
              Text(field,style: TextStyle(color: Colors.white,fontSize: height * 0.08),)
            ],
          ),
        ),
      ),
    ),
  );
}