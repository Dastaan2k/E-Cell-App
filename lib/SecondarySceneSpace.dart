import 'DataModel/Project.dart';
import 'DataModel/User.dart';

class SecondarySceneSpace
{
  List<User> _pendingUserList = [];
  List<Project> _pendingProjectList = [];

  List<User> get pendingUserList => _pendingUserList;
  List<Project> get pendingProjectList => _pendingProjectList;

  bool isPendingUserListEmpty()
  {
    return _pendingUserList.length == 0 ? true : false;
  }

  bool isPendingProjectListEmpty()
  {
    return _pendingProjectList.length == 0 ? true : false;
  }
}