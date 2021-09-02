import 'package:flutter/cupertino.dart';
import 'DataModel/Project.dart';
import 'DataModel/User.dart';

class SavedUser with ChangeNotifier
{
  User _user;

  void setUser(User user,List<Project> projects){
    _user = user;
    _user.projects = projects;
    notifyListeners();
  }


  User get user => _user;

}