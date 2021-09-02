import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testappog/CustomColor.dart';
import 'package:testappog/DataModel/TagSearchResult.dart';

class FieldTagSheet extends StatelessWidget {

  double height;
  double width;
  int indexOpened;

  FieldTagSheet({this.height,this.width,this.indexOpened});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      color: HexColor("#141414"),
      child: Column(
        children: [
          Container(
            height: height * 0.05,
            width: width,
            child: Center(
              child: Container(height: 3,width: width * 0.4,color: Colors.white,),
            ),
          ),
          Container(
            height: height * 0.175,
            width: width,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey,width: 1.5)),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText("Select tags related to your Project : ",maxLines:1,style: TextStyle(color: Colors.greenAccent,fontWeight: FontWeight.bold,fontFamily: "Roboto",fontSize: height * 0.055),),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.05),
            child: Container(
              height: height * 0.75,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  InkWell(onTap:(){
                    Navigator.pop(context,TagSearchResult(index: indexOpened,resultTag: "Clear Tag"));
                  },child: _tagCard(Icons.clear,"Clear Tag")),
                  InkWell(onTap:(){
                    Navigator.pop(context,TagSearchResult(index: indexOpened,resultTag: "App. Dev."));
                  },child: _tagCard(Icons.code,"App Development")),
                  InkWell(onTap:(){
                    Navigator.pop(context,TagSearchResult(index: indexOpened,resultTag: "Game. Dev."));
                  },child: _tagCard(Icons.videogame_asset, "Game Development")),
                  InkWell(onTap:(){
                    Navigator.pop(context,TagSearchResult(index: indexOpened,resultTag: "UI/UX"));
                  },child: _tagCard(Icons.image, "UI/UX Designing")),
                  InkWell(onTap:(){
                    Navigator.pop(context,TagSearchResult(index: indexOpened,resultTag: "IOT"));
                  },child: _tagCard(Icons.wifi_tethering, "IOT")),
                  InkWell(onTap:(){
                    Navigator.pop(context,TagSearchResult(index: indexOpened,resultTag: "Electronics"));
                  },child: _tagCard(Icons.lightbulb_outline, "Electronics")),
                  InkWell(onTap:(){
                    Navigator.pop(context,TagSearchResult(index: indexOpened,resultTag: "Web. Dev."));
                  },child: _tagCard(Icons.http, "Web Development")),
                 /* InkWell(onTap: (){
                      Navigator.pop(context,"None");
                    }, child: Text("  Clear",style: TextStyle(color: Colors.white,fontSize: height * 0.05)),
                  ), */
                ],
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  height:50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Icon(Icons.clear,color: Colors.grey[900],size: 25,),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagCard(IconData icon,String tag)
  {
    return Container(
      height: height * 0.15,
      width: width,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[800],width: 1.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(width: width * 0.1,child: Center(child: Icon(icon,color: icon == Icons.clear ? Colors.red : Colors.greenAccent,))),
          AutoSizeText(tag,maxLines:1,style: TextStyle(color: Colors.white,fontSize: height * 0.05),),
        ],
      ),
    );
  }
}
