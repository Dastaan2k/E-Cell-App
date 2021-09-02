import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../CustomColor.dart';

class FieldSelectBottomSheet extends StatelessWidget {

  double height;
  double width;
  FieldSelectBottomSheet(this.height,this.width);

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
            height: height * 0.2,
            width: width,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey,width: 1.5)),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText("Select Project Field : ",maxLines:1,style: TextStyle(color: Colors.greenAccent,fontWeight: FontWeight.bold,fontFamily: "Roboto",fontSize: height * 0.055),),
            ),
          ),
          Column(
            children: [
              InkWell(
                onTap: (){Navigator.pop(context,"Software");},
                child: _tagCard(Icons.computer,"Software Development"),
              ),
              InkWell(
                onTap: (){Navigator.pop(context,"Hardware");},
                child: _tagCard(Icons.lightbulb_outline,"Hardware"),
              ),
              InkWell(
                onTap: (){Navigator.pop(context,"Graphics");},
                child: _tagCard(Icons.videocam,"Graphics"),
              ),
              InkWell(
                onTap: (){Navigator.pop(context,"Other");},
                child: _tagCard(Icons.videogame_asset,"Other"),
              ),
            ],
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            height: height * 0.2,
            width: width,
            child: Center(
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  height: width * 0.15,
                  width: width * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(width * 0.075)
                  ),
                  child: Center(
                    child: Icon(Icons.clear,color: Colors.grey[700],size: width * 0.08),
                  ),
                ),
              ),
            ),
          )
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
          Container(width: width * 0.1,child: Center(child: Icon(icon,color: Colors.greenAccent,))),
          AutoSizeText(tag,maxLines:1,style: TextStyle(color: Colors.white,fontSize: height * 0.05),),
        ],
      ),
    );
  }
}
