import 'Project.dart';

class User
{
  String uid;
  String name;
  String email;
  String password;
  String phone;
  String branch;
  String status;
  String profileImage;
  List<Project> projects;

  User({this.uid = "Default uid",
    this.name = "Default name",
    this.branch = "Default",
    this.password = "Default",
    this.email = "Default email",
    this.status = "Default Status",
    this.profileImage = "assets/d2k.jpg",
    this.projects,
    this.phone = "Default Phone"});
}