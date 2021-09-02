import 'package:flutter/cupertino.dart';
import 'package:testappog/ScenePackages/LoginPage.dart';
import 'package:testappog/ScenePackages/RegistrationPage.dart';

class PreLoginWrapper extends StatefulWidget {
  @override
  _PreLoginWrapperState createState() => _PreLoginWrapperState();
}

class _PreLoginWrapperState extends State<PreLoginWrapper> {

  bool _showLoginPage = true;

  void togglePage()
  {
    setState(() {
      _showLoginPage = !_showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showLoginPage ? LoginPageDesign(togglePage) : RegistrationPage(togglePage);
  }
}
