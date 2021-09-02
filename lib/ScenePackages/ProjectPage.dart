import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:testappog/API/Firestore.dart';
import 'package:testappog/CustomColor.dart';
import 'package:testappog/CustomWidgets/ProjectRegBottomSheet.dart';
import 'package:testappog/DataModel/Project.dart';

import '../SavedUser.dart';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {

  double _height;
  double _width;

  double _projectCardHeight;

  bool _pseudoInitStateToggle = false;

  QuerySnapshot _projectListSnapshotFromStream;

  bool _isTagSearchActive = false;
  bool _isSearchBarActive = false;



  Widget _activeTab;
  String _activeTabName;
  SavedUser _savedUser;

  List<ProjectCard> _suggestionList = [];

  List<Project> _allProjectList = [];
  List<Project> _softwareProjectList = [];
  List<Project> _hardwareProjectList = [];
  List<Project> _miscProjectList = [];
  List<Project> _graphicsProjectList = [];

  Widget _allProjectTab;
  Widget _softwareProjectTab;
  Widget _hardwareProjectTab;
  Widget _miscProjectTab;
  Widget _graphicsProjectTab;



  FocusNode _searchNode = FocusNode(canRequestFocus: true);
  TextEditingController _searchController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _activeTabName = "All";
    _searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
        builder : (context,constraints) {

          _height = constraints.constrainHeight();
          _width = constraints.constrainWidth();

          _projectCardHeight = 175;

          if(!_pseudoInitStateToggle)
          {
            print("PseudoInitState Called");
            _savedUser = Provider.of<SavedUser>(context);
            _pseudoInitStateToggle = true;
          }

          _projectListSnapshotFromStream = Provider.of<QuerySnapshot>(context);

          if(_projectListSnapshotFromStream != null){

            _savedUser.user.projects = [];

            _projectListSnapshotFromStream.documents.forEach((projectDocument) {

              _savedUser.user.projects.add(Project(
                name: projectDocument.documentID,
                completionRate: projectDocument.data["CR"],
                field: projectDocument.data["Field"],
                subField: projectDocument.data["SubField"],
                createdBy: projectDocument.data["CreatedBy"],
                members: projectDocument.data["Members"],
                memberRef: projectDocument.data["MemberRef"],
              ));
            });

            _allProjectList = [];
            _softwareProjectList = [];
            _hardwareProjectList = [];
            _graphicsProjectList = [];
            _miscProjectList = [];

            for(int i=0;i<_savedUser.user.projects.length;i++){

              _allProjectList.add(_savedUser.user.projects[i]);

              if(_savedUser.user.projects[i].field == "Software")
                _softwareProjectList.add(_savedUser.user.projects[i]);
              if(_savedUser.user.projects[i].field == "Hardware")
                _hardwareProjectList.add(_savedUser.user.projects[i]);
              if(_savedUser.user.projects[i].field == "Graphics")
                _graphicsProjectList.add(_savedUser.user.projects[i]);
              if(_savedUser.user.projects[i].field == "Miscellaneous")
                _miscProjectList.add(_savedUser.user.projects[i]);
            }


            _allProjectTab = _allProjectList.length == 0 ? Container(child: Center(child: Text("No Data available",style: TextStyle(color: Colors.white)),),) :
            ListView.builder(
              padding: EdgeInsets.only(top: 0),
                key: Key(Random.secure().nextDouble().toString()),
                itemCount: _allProjectList.length + 1,
                itemBuilder: (BuildContext context,int index){
                     return index == _allProjectList.length ? Container(width: _width,height: 75,) : ProjectCard(height: _projectCardHeight,globalWidth: _width,projectDetails: _allProjectList[index],);
            });

            _softwareProjectTab = _softwareProjectList.length == 0 ? Container(child: Center(child: Text("No Data available",style: TextStyle(color: Colors.white)),),) :
            ListView.builder(
                padding: EdgeInsets.only(top: 0),
                key: Key(Random.secure().nextDouble().toString()),
                itemCount: _softwareProjectList.length + 1,
                itemBuilder: (BuildContext context,int index){
                       return ProjectCard(height: _projectCardHeight,globalWidth: _width,projectDetails: _softwareProjectList[index],);
            });

            _hardwareProjectTab = _hardwareProjectList.length == 0 ? Container(child: Center(child: Text("No Data available",style: TextStyle(color: Colors.white),),),) :
            ListView.builder(
                padding: EdgeInsets.only(top: 0),
                key: Key(Random.secure().nextDouble().toString()),
                itemCount: _hardwareProjectList.length + 1,
                itemBuilder: (BuildContext context,int index){
                    return ProjectCard(height: _projectCardHeight,globalWidth: _width,projectDetails: _hardwareProjectList[index],);
            });

            _graphicsProjectTab = _graphicsProjectList.length == 0 ? Container(child: Center(child: Text("No Data available",style: TextStyle(color: Colors.white)),),) :
            ListView.builder(
                padding: EdgeInsets.only(top: 0),
                itemCount: _miscProjectList.length + 1,
                key: Key(Random.secure().nextDouble().toString()),
                itemBuilder: (BuildContext context,int index){
                    return ProjectCard(height: _projectCardHeight,globalWidth: _width,projectDetails: _graphicsProjectList[index],);
            });

            _miscProjectTab = _miscProjectList.length == 0 ? Container(child: Center(child: Text("No Data available",style: TextStyle(color: Colors.white)),),) :
            ListView.builder(
                padding: EdgeInsets.only(top: 0),
              itemCount: _miscProjectList.length + 1,
                key: Key(Random.secure().nextDouble().toString()),
                itemBuilder: (BuildContext context,int index){
                      return ProjectCard(height: _projectCardHeight,globalWidth: _width,projectDetails: _miscProjectList[index],);
            });

            if(_activeTabName == "All")
              _activeTab = _allProjectTab;
            else if(_activeTabName == "Software")
              _activeTab = _softwareProjectTab;
            else if(_activeTabName == "Hardware")
              _activeTab = _hardwareProjectTab;
            else if(_activeTabName == "Graphics")
              _activeTab = _graphicsProjectTab;
            else
              _activeTab = _miscProjectTab;
          }





          return _projectListSnapshotFromStream == null ? Container(child: Center(child: Text("Fetching Data"),),) : GestureDetector(
            onTap: (){
              if(_searchNode.hasFocus){
                _searchNode.unfocus();
              }
            },
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: _height * 0.9,
                      width: _isTagSearchActive ? _width * 0.85 : _width,
                      color: HexColor("#424242"),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Align(
                              child: Text(_activeTabName +" Projects : ",style: TextStyle(color: Colors.greenAccent,fontSize: _height * 0.0375,fontWeight: FontWeight.bold),),
                              alignment: Alignment.centerLeft,
                            ),
                            padding: EdgeInsets.only(left: _width * 0.065),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                            ),
                            height: _height * 0.08,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top:0),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: _width * 0.8,
                              height: _isSearchBarActive ? _height * 0.08 : 0,
                            //  color: Colors.orange,
                              child: ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                child: TextField(
                                  controller: _searchController,
                                  focusNode: _searchNode,
                                  onChanged: _updateResultBasedOnSearch,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.greenAccent),
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.greenAccent),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.transparent),
                                    ),
                                    hintText: "Enter your Project's name",
                                    enabled: true,
                                    filled: true,
                                    fillColor: Colors.grey[700],
                                    hintStyle: TextStyle(color: Colors.white)
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: _isSearchBarActive ? _suggestionList.isEmpty ? Container(child: Center(child: AutoSizeText("No Project matching with  : " + _searchController.text + "...",style: TextStyle(color: Colors.white),maxLines: 2,textAlign: TextAlign.start,)),)
                                : ListView(
                              padding: EdgeInsets.only(top: 0),
                              key: Key(Random.secure().nextDouble().toString()),
                              scrollDirection: Axis.vertical,
                              children: _suggestionList,) : _activeTab,//_activeTab,//_streamList,//
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: _height * 0.3,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: (){
                        setState(() {
                          _isTagSearchActive = true;
                        });
                      },
                      child: Container(
                        width: _width * 0.05,
                        height: _height * 0.125,
                        decoration: BoxDecoration(
                          color: HexColor("#212121"),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20))
                        ),
                        child: Center(
                          child: Icon(Icons.arrow_forward_ios,color: Colors.greenAccent,size: _width * 0.05 /1.5,),
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                        duration: Duration(milliseconds: 200),
                        left: _isTagSearchActive ? 0 : - _width * 0.155,
                        child: Container(
                          decoration: BoxDecoration(
                              color: HexColor("#212121"),
                              borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20))
                          ),
                          height: _height * 0.9,
                          width: _width * 0.155,
                          child: Column(
                            children: [
                              IconButton(icon: Icon(Icons.search,color: Colors.white,),onPressed: (){
                                setState(() {
                                  _isSearchBarActive = !_isSearchBarActive;
                                });
                              },highlightColor: Colors.transparent,splashColor: Colors.transparent,),
                              Container(height: 1,color: Colors.grey,width: _width * 0.155 * 0.8,),
                              Expanded(
                                child: ListView(
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    InkWell(onTap:(){
                                      setState(() {
                                        if(_searchNode.hasFocus)
                                          _searchNode.unfocus();
                                        _isSearchBarActive = false;
                                        _activeTabName = "All";
                                      });
                                    },child: Container(child: Center(child: Text("All",style: TextStyle(color: _activeTabName == "All" ? Colors.greenAccent : Colors.white,fontSize: _width * 0.03),)),width: _width * 0.155,height: _height * 0.08,)),
                                    IconButton(icon: Icon(Icons.code,color: _activeTabName == "Software" ? Colors.greenAccent : Colors.white,),onPressed: (){
                                      setState(() {
                                        if(_searchNode.hasFocus)
                                          _searchNode.unfocus();
                                        _isSearchBarActive = false;
                                        _activeTabName = "Software";
                                      });
                                    },highlightColor: Colors.transparent,splashColor: Colors.transparent,),
                                    IconButton(icon: Icon(Icons.lightbulb_outline,color: _activeTabName == "Hardware" ? Colors.greenAccent : Colors.white,),onPressed: (){
                                      setState(() {
                                        if(_searchNode.hasFocus)
                                          _searchNode.unfocus();
                                        _isSearchBarActive = false;
                                        _activeTabName = "Hardware";
                                      });
                                    },highlightColor: Colors.transparent,splashColor: Colors.transparent,),
                                    IconButton(icon: Icon(Icons.videocam,color: _activeTabName == "Graphics" ? Colors.greenAccent : Colors.white,),onPressed: (){
                                      setState(() {
                                        if(_searchNode.hasFocus)
                                          _searchNode.unfocus();
                                        _isSearchBarActive = false;
                                        _activeTabName = "Graphics";
                                      });
                                    },highlightColor: Colors.transparent,splashColor: Colors.transparent,),
                                    IconButton(icon: Icon(Icons.description,color: _activeTabName == "Miscellaneous" ? Colors.greenAccent : Colors.white,),onPressed: (){
                                      setState(() {
                                        if(_searchNode.hasFocus)
                                          _searchNode.unfocus();
                                        _isSearchBarActive = false;
                                        _activeTabName = "Miscellaneous";
                                      });
                                    },highlightColor: Colors.transparent,splashColor: Colors.transparent,),
                                  ],
                                ),
                              ),
                              Container(height: 1,color: Colors.grey,width: _width * 0.155 * 0.8,),
                              IconButton(icon: Icon(Icons.add,color: Colors.white,),onPressed: (){
                                setState(() {
                                  if(_searchNode.hasFocus)
                                    _searchNode.unfocus();
                                  _isSearchBarActive = false;
                                  _isTagSearchActive = false;
                                });
                                showModalBottomSheet(
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
                                    ),
                                    context: context,
                                    barrierColor: Colors.grey[900].withOpacity(0.4),
                                    isScrollControlled: true,
                                    isDismissible: false,
                                    builder: (context){
                                      return FractionallySizedBox(
                                        child: ProjectRegBottomSheet(height: _height * 0.925,width: _width,),
                                        heightFactor: 0.925,
                                      );
                                    });
                              },highlightColor: Colors.transparent,splashColor: Colors.transparent,),
                              IconButton(icon: Icon(Icons.clear,color: Colors.white,),onPressed: (){
                                setState(() {
                                if(_searchNode.hasFocus)
                                  _searchNode.unfocus();
                                _isSearchBarActive = false;
                                _isTagSearchActive = false;
                              });
                              },highlightColor: Colors.transparent,splashColor: Colors.transparent,),
                            ],
                          ),
                        ),
                      )
                ]
              ),
            ),
          );
        }
    );
  }


  void _updateResultBasedOnSearch(String text)
  {
        _suggestionList = [];
        List<Project> _activeList = [];

        if(_activeTabName == "All")
          _activeList = _allProjectList;
        else if(_activeTabName == "Software")
          _activeList = _softwareProjectList;
        else if(_activeTabName == "Hardware")
          _activeList = _hardwareProjectList;
        else if(_activeTabName == "Graphics")
          _activeList = _graphicsProjectList;
        else
          _activeList = _miscProjectList;

        if(text.length == 0){
          _activeList.forEach((element) { _suggestionList.add(ProjectCard(projectDetails: element, height: _projectCardHeight, globalWidth: _width));});
        }
        else{
          _activeList.forEach((element) {
            if(element.name.toLowerCase().contains(text.toLowerCase()))
              _suggestionList.add(ProjectCard(projectDetails: element, height: _projectCardHeight, globalWidth: _width));
          });
        }

        setState(() {
          _suggestionList.forEach((element) { print(element.projectDetails.name);});
        });
  }


}


class ProjectCard extends StatefulWidget {

  Project projectDetails;
  String field;
  double height;
  double globalWidth;

  ProjectCard({@required this.projectDetails,@required this.height,@required this.globalWidth});

  @override
  _ProjectCardState createState() => _ProjectCardState(projectDetails,height,globalWidth);
}

class _ProjectCardState extends State<ProjectCard> with SingleTickerProviderStateMixin{

  double _width;
  double _height;
  Project projectDetails;

  _ProjectCardState(this.projectDetails,this._height,this._width);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(left: _width * 0.05,right: _width * 0.05,top: _height * 0.1,),
      child: Container(
          height: _height,
          padding: EdgeInsets.all(_width * 0.05),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[900],width: 1),
            boxShadow: [
              BoxShadow(offset: Offset(5,5),color: Colors.grey[850],blurRadius: 5,spreadRadius: 2.5),
            ],
            color: HexColor("#2E2E2E"),
            borderRadius: BorderRadius.all(Radius.circular(_width * 0.035)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(projectDetails.name,style: TextStyle(color: Colors.greenAccent,fontSize: _width * 0.06,fontWeight: FontWeight.bold),maxLines: 1,),
                      AutoSizeText(projectDetails.field,style: TextStyle(color: Colors.grey[300],fontSize: _width * 0.035),maxLines: 1,),
                    ],
                  ),
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 500),
                    tween: Tween<double>(begin: 0,end: projectDetails.completionRate == null ? 0.0 : projectDetails.completionRate.toDouble()/100),
                    builder: (context,angle,child){
                      return CustomPaint(
                        foregroundPainter: CircleProgress(angle),
                        child: Container(
                          height: _width * 0.165,
                          width: _width * 0.165,
                          child: Center(
                            child: Text(projectDetails.completionRate == null ? "-" : projectDetails.completionRate.toString(),style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
              Container(
                  height: _height * 0.2,width: _width * 0.75,
                child: Align(alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        AutoSizeText("Members involved : ",style: TextStyle(color: Colors.grey[300],fontWeight: FontWeight.bold,fontSize: _width * 0.0425),maxLines: 1,),
                        AutoSizeText(projectDetails.members.length.toString(),style: TextStyle(color: Colors.greenAccent,fontWeight: FontWeight.bold,fontSize: _width * 0.0425),maxLines: 1,),
                      ],
                    ),
                )
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                          scrollDirection: Axis.horizontal,
                          itemCount: projectDetails.subField.length,
                          itemBuilder: (context,index){
                            return Padding(
                              padding: const EdgeInsets.only(right: 17.5),
                              child: Icon(getIconBasedonSubField(projectDetails.subField[index]),color: Colors.greenAccent,size: 20,),
                            );
                          }
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        if(projectDetails.completionRate == 0){
                          showModalBottomSheet(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
                              ),
                              context: context,
                              barrierColor: Colors.grey[900].withOpacity(0.4),
                              isScrollControlled: true,
                              isDismissible: false,
                              builder: (context){
                                return FractionallySizedBox(
                                  child: ProjectRegBottomSheet(height: _height * 0.925,width: _width,),
                                  heightFactor: 0.925,
                                );
                              });
                        }
                      },
                      child: Container(
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                AutoSizeText("Details ",style: TextStyle(color: Colors.white,fontSize: _height * 0.085,fontWeight: FontWeight.bold),),
                                Icon(Icons.assignment,size: _height * 0.085,color: Colors.white,),
                              ],
                            )
                        ),
                      ),
                    ),
                  ],
                )
              )
            ],
          )
      ),
    );
  }


  IconData getIconBasedonSubField(String subField){
    if(subField == "App. Dev.")
      return Icons.android;
    else if(subField == "Web. Dev.")
      return Icons.http;
    else if(subField == "Electronics")
      return Icons.lightbulb_outline;
    else if(subField == "UI/UX")
      return Icons.brush;
    else if(subField == "Game. Dev.")
      return Icons.videogame_asset;
    else
      return Icons.error;
  }
}


class CircleProgress extends CustomPainter
{
  double progress;

  CircleProgress(this.progress);

  void paint(Canvas canvas,Size size)
  {
    Paint _outerArc = Paint()
        ..color = Colors.grey
        ..strokeWidth = 7.5
        ..style = PaintingStyle.stroke;

    Paint _innerArc = Paint()
        ..color = Colors.greenAccent
        ..strokeWidth = 7.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width/2, size.height/2);
    double radius = min(size.width/2,size.height/2) - 10;

    canvas.drawCircle(center, radius, _outerArc); // this draws main outer circle

    double angle = 2 * pi * (progress);

    canvas.drawArc(Rect.fromCircle(center: center,radius: radius), -pi/2, angle, false, _innerArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
