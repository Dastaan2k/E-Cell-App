import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:testappog/API/Firestore.dart';

import '../CustomColor.dart';

class RegistrationPage extends StatefulWidget {

  Function toggleView;

  RegistrationPage(this.toggleView);

  @override
  _RegistrationPageState createState() => _RegistrationPageState(toggleView);
}

class _RegistrationPageState extends State<RegistrationPage> {

  Function toggleView;

  _RegistrationPageState(this.toggleView);

  double _width;
  double _height;
  double _logoContainerHeight;
  double _midStackHeight;
  double _logoContainerWidth;
  double _midStackWidth;
  double _registerButtonHeight;
  double _generalFontSize;

  FirestoreAPI _firestoreAPI = FirestoreAPI();

  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FieldFocus.isFieldFocused.length = 4;
    for (int i = 0; i < 4; i++) {
      FieldFocus.isFieldFocused[i] = false;
    }
    FieldFocus.activeIndex = 99;
    nameController.addListener(() {setState(() {});});
    branchController.addListener(() {setState(() {});});
    emailController.addListener(() {setState(() {});});
    passwordController.addListener(() {setState(() {});});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    branchController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("Registration Page Called");

    return LayoutBuilder(
      builder: (context1,constraints){

        _width = constraints.constrainWidth();
        _height = constraints.constrainHeight();

        _logoContainerHeight = _height * 0.15;
        _midStackHeight = _height * 0.6;
        _logoContainerWidth = _width * 0.4;
        _midStackWidth = _width * 0.9;
        _registerButtonHeight = _height * 0.08;
        _generalFontSize = _height * 0.02;

        return Scaffold(
          key: _key,
          backgroundColor: CustomColor.darkBackgroundBack,
          body: SingleChildScrollView(
            child: Container(
              color: CustomColor.darkBackgroundFront,
              width: _width,
              height: _height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: _height * 0.02),
                    child: Container(
                      width: _logoContainerWidth,
                      height: _logoContainerHeight,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage("assets/ecellLogoDark.png"),
                          alignment: Alignment.center,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: _midStackWidth,
                    height: _midStackHeight,
                    child: Stack(
                      children: [
                        Align(
                          child: Container(
                            height: _midStackHeight * 0.95,
                            width: _midStackWidth,
                            decoration: BoxDecoration(
                              color: CustomColor.formCardColor,
                              border: Border.all(color: CustomColor.borderWhite,width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(_height * 0.025)),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(top : _midStackHeight * 0.1,bottom: _midStackHeight * 0.05,left: _midStackWidth * 0.05,right: _midStackWidth * 0.05),
                              child: Form(
                                key: _formKey,
                                child: ListView(
                                  scrollDirection: Axis.vertical,
                                //  mainAxisAlignment : MainAxisAlignment.start,
                                  children: [
                                    Container(height: _midStackHeight * 0.215,child: CustomFormField(index: 0,labelText: "Name",hintText: "Enter your name",controller: nameController,type: "TEXT",)),
                                    Container(height: _midStackHeight * 0.215,child: CustomFormField(index: 1,labelText: "Year/Branch",hintText: "Enter your Year/Branch",controller: branchController,type: "TEXT",)),
                                    Container(height: _midStackHeight * 0.215,child: CustomFormField(index: 2, labelText: "Email-id",hintText: "Enter your email-id",controller: emailController,type: "EMAIL",)),
                                    Container(height: _midStackHeight * 0.215,child: CustomFormField(index: 3,labelText: "Password",hintText: "Enter your password (6+ Digits)",controller: passwordController,type: "TEXT",)),
                                    Container(height: _midStackHeight * 0.215,child: CustomFormField(index: 4,labelText: "Phone",hintText: "Enter your phone Number",controller: phoneController,type: "NUMBER",)),
                                  ],
                                ),
                              ),
                            )
                          ),
                          alignment: Alignment.bottomCenter,
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: _midStackWidth * 0.2,
                            height: _midStackWidth * 0.2,
                            decoration: ShapeDecoration(shape: CircleBorder(), color: CustomColor.darkBackgroundBack),
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                  shape: CircleBorder(),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image : AssetImage('assets/Group8.png'),
                                  )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: _height * 0.03),
                    child: Container(
                      width : _width  * 0.8,
                      height : _registerButtonHeight,
                      child: RaisedButton(
                        onPressed: () {
                          print("User Registered");
                          if (_formKey.currentState.validate()) {
                            print("User Registered");
                            _firestoreAPI.sendUserRegistrationtoPending(nameController.text,emailController.text,passwordController.text,branchController.text,phoneController.text).then((value){
                               /*   if(value == "Success")
                                    _key.currentState.showSnackBar(SnackBar(content: Text("Request sent to admin"),duration: Duration(seconds: 2),));
                                  else
                                    _key.currentState.showSnackBar(SnackBar(content: Text(value),duration: Duration(seconds: 2),)); */
                            });
                          }
                        },
                        elevation: 2,
                        color: CustomColor.neonGreen,
                        child: ButtonTheme(
                          child: Text("Register",style: TextStyle(color: Colors.white,fontSize: _registerButtonHeight * 0.3),),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: _width * 0.5,
                      child: Row(
                        children: [
                          Text("Already registered ? ",style: TextStyle(color: Colors.white,fontSize: _generalFontSize),),
                          InkWell(
                            onTap: (){
                              widget.toggleView();
                            },
                            child: Text("Login",style: TextStyle(color: CustomColor.textGreen,fontSize: _generalFontSize,decoration: TextDecoration.underline),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class CustomFormField extends StatefulWidget {

  int index;
  String labelText;
  String hintText;
  String errorText;
  String type;
  TextEditingController controller;

  CustomFormField({@required this.index,@required this.hintText,this.errorText,@required this.labelText,@required this.controller,@required this.type});

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState(index,labelText,errorText,hintText,controller,type);
}

class _CustomFormFieldState extends State<CustomFormField> {

  int index;
  String labelText;
  String hintText;
  String errorText;
  String type;
  TextEditingController controller;
  double _height;
  double _width;

  _CustomFormFieldState(this.index,this.labelText, this.errorText, this.hintText, this.controller,this.type);

  @override
  Widget build(BuildContext context) {


    void onFocused()
    {
      setState(() {
         FieldFocus.activeIndex = index;
         print("Active Index : " + FieldFocus.activeIndex.toString());
         for(int i=0;i<FieldFocus.isFieldFocused.length;i++){
           if(i == FieldFocus.activeIndex)
             FieldFocus.isFieldFocused[index] = true;
           else
             FieldFocus.isFieldFocused[index] = false;
         }
      });
    }

    return TextFormField(
          controller: controller,
          onTap: onFocused,
          keyboardType: type == "EMAIL" ? TextInputType.emailAddress : type == "NUMBER" ? TextInputType.number : TextInputType.text,
          validator: (val) => type == "EMAIL" ? (val.contains("@") ? null : "Invalid Email") : (val.isEmpty ? 'Field must be filled' : null),
          style: TextStyle(color: Colors.white, /*fontSize: _height * 0.2 */),
          decoration: InputDecoration(
              //contentPadding: EdgeInsets.all(),
              labelText: labelText,
              labelStyle: TextStyle(
                color: index == FieldFocus.activeIndex ? Colors.greenAccent : Colors.white,
               // fontSize: _height * 0.25,
              ),
              fillColor: Colors.grey[800],
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  )
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: CustomColor.textGreen,
                  )
              )
          ),
        );
  }
}


class FieldFocus
{
  static int activeIndex;
  static List<bool> isFieldFocused = [];
}