import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testappog/API/Firestore.dart';
import 'package:testappog/CustomWidgets/FieldSelectBottomSheet.dart';
import 'package:testappog/CustomWidgets/FieldTagSheet.dart';
import 'package:testappog/DataModel/TagSearchResult.dart';
import 'package:testappog/SavedUser.dart';

import '../CustomColor.dart';

class ProjectRegBottomSheet extends StatefulWidget {

  final double height;
  final double width;

  ProjectRegBottomSheet({this.height,this.width});

  @override
  _ProjectRegBottomSheetState createState() => _ProjectRegBottomSheetState(height,width);
}

class _ProjectRegBottomSheetState extends State<ProjectRegBottomSheet> {

  double _height;
  double _width;


  FirestoreAPI _firestoreAPI = FirestoreAPI();

  SavedUser _savedUser;

  TextEditingController _projectNameController;
  TextEditingController _descriptionController;
  int _memberListLength = 0;
  List<TextEditingController> _memberNamesControllerList;

  String _fieldText = "";

  TextEditingController _memberController;

  FocusNode _projectNameNode = FocusNode(skipTraversal: true);
  FocusNode _descriptionNode = FocusNode(canRequestFocus: true);
  FocusNode _memberNode = FocusNode(canRequestFocus: true);

  bool _isMemberControllerEmpty = true;
  bool _isMemberDetailExpanded = false;

  List<String> _tagList = [null,null,null];

  GlobalKey<FormState> _formKey;

  _ProjectRegBottomSheetState(this._height,this._width);


  @override
  void initState() {
    // TODO: implement initState
    _formKey = GlobalKey<FormState>();
    _memberController = TextEditingController();
    _projectNameController = TextEditingController();
    _descriptionController =  TextEditingController();
    super.initState();
    _memberController.addListener(() {
      if(_memberController.text != ""){
        setState(() {
          _isMemberControllerEmpty = false;
        });
      }
      else
        setState(() {
          _isMemberControllerEmpty = true;
        });
    });
    _memberNamesControllerList = List.generate(10, (index) => TextEditingController(text: ""));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _memberNode.dispose();
    _projectNameNode.dispose();
    _memberController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _savedUser = Provider.of<SavedUser>(context);

    return GestureDetector(
      onTap: (){
        _descriptionNode.unfocus();
        _projectNameNode.unfocus();
        _memberNode.unfocus();
      },
      child: Container(
        height: _height,
        width: _height,
        padding: EdgeInsets.symmetric(horizontal: _width * 0.05),
        color: HexColor("#151515",),
        child: Column(
          children: [
            Container(
              height: 30,
              width: _width,
              child: Center(
                child: Container(height: 3,width: _width * 0.4,color: Colors.white,),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: _height * 0.15,
                width: _width * 0.75,
                child: Align(alignment : Alignment.centerLeft,child: AutoSizeText("Register your Project : ",maxLines: 1,style: TextStyle(color: Colors.greenAccent,fontWeight: FontWeight.bold,fontFamily: "Roboto",fontSize: 30),)),
              ),
            ),
            Container(
              height: _height * 0.8,
              width: _width,
              decoration: BoxDecoration(color: HexColor("#222222"),borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.only(top: 10,bottom: 20,left: 20,right: 20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Container(
                      height: 80,
                      width: _width,
                      child: Center(
                        child: TextFormField(
                          maxLines: 1,
                       //   expands: true,
                          controller: _projectNameController,
                          focusNode: _projectNameNode,
                          validator: (val) => val.isEmpty ? "Field cant be kep empty" : null,
                       //   autofocus: false,
                       //   autovalidate: true,
                          style: TextStyle(color: Colors.white,fontSize: 17.5),
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(0.075),
                              borderSide: BorderSide(color: Colors.white,width: 1.5),
                            ),
                            alignLabelWithHint: true,
                            hintText: "Your Project Name (eg : E-cell App)",
                            labelText: "Project Name",
                           // floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle: TextStyle(color: Colors.greenAccent,fontSize: 17),
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 15),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(0.075),
                              borderSide: BorderSide(color: Colors.greenAccent,width: 1.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(child: AutoSizeText("Field : ",style: TextStyle(color: Colors.greenAccent,fontSize: 20),),width: _width * 0.2,),
                            Expanded(
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Colors.grey,width: 1.5)),
                                        ),
                                        child: Align(alignment: Alignment.centerLeft,child: Text(_fieldText,maxLines: 1,style: TextStyle(color: Colors.white,fontSize: 20),),),
                                      ),
                                    ),
                                    InkWell(
                                      onTap:()async{
                                        String x = await showModalBottomSheet(
                                            clipBehavior: Clip.antiAlias,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(_width * 0.1),topLeft: Radius.circular(_width * 0.1)),
                                            ),
                                            context: context,
                                            barrierColor: Colors.grey[900].withOpacity(0.4),
                                            isScrollControlled: true,
                                            builder: (context){
                                              return FractionallySizedBox(
                                                child: FieldSelectBottomSheet(_height * 0.9,_width),
                                                heightFactor: 0.9,
                                              );
                                            });
                                        if(x != null){
                                          _projectNameNode.unfocus();
                                          setState(() {
                                            _descriptionNode.unfocus();

                                                _fieldText = x;
                                          });
                                        }
                                      },
                                      child: Container(
                                        child: Center(child: Icon(Icons.add,color: Colors.greenAccent,),),
                                        width: _width * 0.075,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: _fieldText == "" ? 0 : 100,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(child: AutoSizeText("Tags related to your project : ",maxLines:1,style: TextStyle(color: Colors.greenAccent,fontSize : 20,fontFamily: "Roboto"),),width: _width * 0.77,),
                          Container(
                            height: _fieldText == "" ? 0 : 70,
                            child:  Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap:()async{
                                      TagSearchResult x = await showModalBottomSheet(
                                          clipBehavior: Clip.antiAlias,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(_width * 0.1),topLeft: Radius.circular(_width * 0.1)),
                                          ),
                                          context: context,
                                          barrierColor: Colors.grey[900].withOpacity(0.4),
                                          isScrollControlled: true,
                                          builder: (context){
                                            return FractionallySizedBox(
                                              child: FieldTagSheet(width: _width,height: _height * 0.9,indexOpened: 0,),
                                              heightFactor: 0.9,
                                            );
                                          });
                                      if(x.resultTag == "Clear Tag"){
                                        setState(() {
                                          _tagList[x.index] = null;
                                          _descriptionNode.unfocus();
                                          _projectNameNode.unfocus();
                                        });
                                      }
                                      else if(x.resultTag != null){
                                        setState(() {
                                          _tagList[x.index] = x.resultTag;
                                          _projectNameNode.unfocus();
                                          _descriptionNode.unfocus();
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 40,width: _width * 0.24,//0.275,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(_width * 0.1),
                                          color: _tagList[0] == null ? Colors.transparent : Colors.grey[850],
                                          border: Border.all(color: _tagList[0] == null ? Colors.transparent : Colors.greenAccent,width: 2)),
                                      child: Center(child: _tagList[0] == null ? Icon(Icons.add,color: Colors.grey[300],size: 30,) : Text(_tagList[0],style: TextStyle(color: Colors.white,fontSize: 15),),),
                                    )
                                ),
                                InkWell(
                                    onTap:()async{
                                      TagSearchResult x = await showModalBottomSheet(
                                          clipBehavior: Clip.antiAlias,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(_width * 0.1),topLeft: Radius.circular(_width * 0.1)),
                                          ),
                                          context: context,
                                          barrierColor: Colors.grey[900].withOpacity(0.4),
                                          isScrollControlled: true,
                                          builder: (context){
                                            return FractionallySizedBox(
                                              child: FieldTagSheet(width: _width,height: _height * 0.9,indexOpened: 1,),
                                              heightFactor: 0.9,
                                            );
                                          });
                                      if(x.resultTag == "Clear Tag"){
                                        setState(() {
                                          _tagList[x.index] = null;
                                          _descriptionNode.unfocus();
                                          _projectNameNode.unfocus();
                                        });
                                      }
                                      else if(x.resultTag != null){
                                        setState(() {
                                          _projectNameNode.unfocus();
                                          _tagList[x.index] = x.resultTag;
                                          _descriptionNode.unfocus();
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 40,width: _width * 0.24,//0.275,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(_width * 0.1),
                                          color: _tagList[1] == null ? Colors.transparent : Colors.grey[850],
                                          border: Border.all(color: _tagList[1] == null ? Colors.transparent : Colors.greenAccent,width: 2)),
                                      child: Center(child: _tagList[1] == null ? Icon(Icons.add,color: Colors.grey[300],size: 30,) : Text(_tagList[1],style: TextStyle(color: Colors.white,fontSize: 15),),),
                                    )
                                ),
                                InkWell(
                                    onTap:()async{
                                      TagSearchResult x = await showModalBottomSheet(
                                          clipBehavior: Clip.antiAlias,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(_width * 0.1),topLeft: Radius.circular(_width * 0.1)),
                                          ),
                                          context: context,
                                          barrierColor: Colors.grey[900].withOpacity(0.4),
                                          isScrollControlled: true,
                                          builder: (context){
                                            return FractionallySizedBox(
                                              child: FieldTagSheet(width: _width,height: _height * 0.9,indexOpened: 2,),
                                              heightFactor: 0.9,
                                            );
                                          });
                                      if(x.resultTag == "Clear Tag"){
                                        setState(() {
                                          _tagList[x.index] = null;
                                          _descriptionNode.unfocus();
                                          _projectNameNode.unfocus();
                                        });
                                      }
                                      else if(x.resultTag != null){
                                        setState(() {
                                          _projectNameNode.unfocus();
                                          _descriptionNode.unfocus();
                                          _tagList[x.index] = x.resultTag;
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 40,width: _width * 0.24,//0.275,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(_width * 0.1),
                                          color: _tagList[2] == null ? Colors.transparent : Colors.grey[850],
                                          border: Border.all(color: _tagList[2] == null ? Colors.transparent : Colors.greenAccent,width: 2)),
                                      child: Center(child: _tagList[2] == null ? Icon(Icons.add,color: Colors.grey[300],size: 30,) : Text(_tagList[2],style: TextStyle(color: Colors.white,fontSize: 15),),),
                                    )
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ),
                    Container(
                      height: 250,
                      padding: EdgeInsets.symmetric(vertical: _height * 0.0275),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: _height * 0.08,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Project Description : ",style: TextStyle(color: Colors.greenAccent,fontSize: 22.5,),),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: TextFormField(
                                  controller: _descriptionController,
                                  focusNode: _descriptionNode,
                                  cursorColor: Colors.greenAccent,
                                  validator: (val) => val.isEmpty ? "Field cant be kept empty" : null,
                                  decoration: InputDecoration(
                                    counterStyle: TextStyle(color: Colors.greenAccent),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.grey,width: 1.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.grey,width: 1.5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.grey[200],width: 1.5),
                                    ),
                                  ),
                                  style: TextStyle(color: Colors.white,fontSize: 15,),
                                  maxLines: 5,
                                  maxLengthEnforced: true,
                                  maxLength: 200,
                                ),
                            ))
                          ],
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: _isMemberDetailExpanded ? EdgeInsets.all(_width * 0.05) : EdgeInsets.all(0),
                      height: _isMemberDetailExpanded ? 300 : 100,
                      decoration: BoxDecoration(
                        color: _isMemberDetailExpanded ? Colors.grey[800] : Colors.transparent,
                        borderRadius: BorderRadius.circular(_width * 0.03),
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(child: Center(child: AutoSizeText("Number of members : ",maxLines:1,style: TextStyle(color: Colors.greenAccent,fontSize: 25,fontFamily: "Roboto"),)),width: _width * 0.5,height: 40),
                                Container(
                                  width: _width * 0.15,
                                  height: 30,
                                  child: TextFormField(
                                    focusNode: _memberNode,
                                  //  validator: (val) => val.isEmpty ? "Field cant be kep empty" : null,
                                    enabled: _isMemberDetailExpanded ? false : true,
                                    controller: _memberController,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize:25,color: Colors.white),
                                    keyboardType: TextInputType.number,
                                    decoration : InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey,width: 1.5),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white,width: 1.5),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    child: InkWell(
                                      onTap:(){
                                        if(!_isMemberControllerEmpty){
                                          setState(() {
                                            _projectNameNode.unfocus();
                                            _memberNode.unfocus();
                                            _descriptionNode.unfocus();
                                            _isMemberDetailExpanded = !_isMemberDetailExpanded;
                                            _memberListLength = int.parse(_memberController.text);
                                          });
                                        }
                                      },
                                      child: Icon(_isMemberDetailExpanded ? Icons.keyboard_arrow_up:Icons.arrow_drop_down_circle,color: _isMemberControllerEmpty ? Colors.grey : Colors.greenAccent,size: 30,),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            _isMemberDetailExpanded ? Container(
                              height: 200,
                              width: _width,
                              child: ListView.builder(
                                primary: true,
                                scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: int.parse(_memberController.text),
                                  itemBuilder: (context,index){
                                    return TextFormField(
                                      controller: _memberNamesControllerList[index],
                                      style: TextStyle(color: Colors.white),
                                      enabled: true,
                                      decoration: InputDecoration(
                                        hintText: "Member " + (index + 1).toString(),
                                        hintStyle: TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white,width: 1.5),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.greenAccent,width: 1.5),
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            ) : Container()
                          ],
                        ),
                      ),
                    ),
                    Container(height: 20,)
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Container(height: _height * 0.06,child: AutoSizeText("* After registration of the project a request will be sent to respective admin, your project will be successfully registered once the admin accepts it",style: TextStyle(color: Colors.white),maxLines: 2,)),
                  InkWell(
                    onTap: (){
                      if(_formKey.currentState.validate()){
                        print("vali");
                                List<dynamic> proxyListMember = [];
                                List<dynamic> tagListProxy = [];

                                print(_tagList);

                                _tagList.forEach((element) {
                                    if(element != null){
                                      tagListProxy.add(element);
                                    }
                                });

                                for(int i=0;i<_memberListLength;i++){
                                proxyListMember.add(_memberNamesControllerList[i].text);
                                }

                                _firestoreAPI.sendProjectToPending(_projectNameController.text, _descriptionController.text, _fieldText, tagListProxy, proxyListMember,_savedUser.user.name).then((x){
                                print("Sent to pending");
                                });

                                Navigator.pop(context);
                        }
                    },
                    child: Container(
                      height: 50,
                      width: _width * 0.8,
                      child: Center(child: AutoSizeText("Send Request to Admin",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(_width * 0.025),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
