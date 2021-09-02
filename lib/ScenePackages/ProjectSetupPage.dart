import 'package:flutter/cupertino.dart';

class ProjectSetupPage extends StatefulWidget {

  double height;
  double width;

  ProjectSetupPage(this.height,this.width);

  @override
  _ProjectSetupPageState createState() => _ProjectSetupPageState(height,width);
}

class _ProjectSetupPageState extends State<ProjectSetupPage> {

  double _height;
  double _width;

  _ProjectSetupPageState(this._height,this._width);

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}

