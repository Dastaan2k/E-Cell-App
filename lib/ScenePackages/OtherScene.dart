import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testappog/SceneManager.dart';

class OtherScene extends StatefulWidget {
  @override
  _OtherSceneState createState() => _OtherSceneState();
}

class _OtherSceneState extends State<OtherScene> {

  SceneManager _manager;

  @override
  Widget build(BuildContext context) {

    _manager = Provider.of<SceneManager>(context);

    return Container(
      child: Center(
        child: Column(
          children: [
            Text("The Other Scene",style: TextStyle(color: Colors.white),),
            FlatButton(
              onPressed: (){
              _manager.setScene("Home");
            },child: Text("Toggle View"),)
          ],
        ),
      ),
    );
  }
}
