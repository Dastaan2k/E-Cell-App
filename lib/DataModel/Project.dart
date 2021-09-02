class Project
{
  String name;
  String field;
  List<dynamic> subField;
  int completionRate;
  List<dynamic> members;/// Map just for testing because we r just using the members name initially ..... After further testing with the reference object of database, we will convert that Map to a user model
  List<dynamic> memberRef;
  String createdBy;
  String description;

  Project({this.name = "a",this.completionRate,this.field = "x",this.members,this.subField,this.memberRef,this.createdBy = "Default",this.description = "Default Description"});
}