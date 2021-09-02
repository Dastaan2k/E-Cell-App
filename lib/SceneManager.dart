import 'package:flutter/cupertino.dart';
import 'package:testappog/ScenePackages/AttendancePage.dart';
import 'package:testappog/ScenePackages/ProjectPage.dart';

import 'DataModel/User.dart';
import 'ScenePackages/AutomationPage.dart';
import 'ScenePackages/HomePage.dart';
import 'ScenePackages/OtherScene.dart';
import 'ScenePackages/ProfilePage.dart';


class SceneManager with ChangeNotifier{

  String _scene = "Home Page";

  String get scene  => _scene;

  void setScene(String newScene)
  {
    _scene = newScene;
    notifyListeners();
  }

  String get sceneName => _scene;


  Widget returnScene() {

    if (_scene == "Home Page")
      return HomePage();
    else if(_scene == "My Projects")
      return ProjectPage();
    else if(_scene == "Profile")
      return ProfilePage();
    else if(_scene == "Attendance")
      return AttendancePage();
    else if(_scene == "Automation")
      return AutomationPage();
    else
      return OtherScene();
  }
}
