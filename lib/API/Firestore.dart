import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testappog/DataModel/Project.dart';
import 'package:testappog/DataModel/User.dart';

import 'Firebase_Auth.dart';

class FirestoreAPI
{
  final databaseReference = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getProjectsFromStream(String username){
   // print(username);
   // print("Project Stream Accessed");
    return databaseReference.collection("Projects").where("Members",arrayContains: username).snapshots();
  }


  Future<dynamic> sendUserRegistrationtoPending(String name,String email,String password,String branch,String phone)
  {
    List temp = List();
     return Firestore.instance.collection('Pending').document('Pending Users').get().then((pendingUserList){

       print(pendingUserList.data);
       pendingUserList["Users"].forEach((data){
         temp.add(data);
       });
       temp.add(
           {
             "Name" : name,
             "Email" : email,
             "Password" : password,
             "Phone" : phone,
             "Branch" : branch,
           }
       );
       Firestore.instance.collection('Pending').document('Pending Users').setData(
           {"Users" : temp,}
       );
     });
  }

  Future<void> sendProjectToPending(String projectName,String description,String field,List<dynamic> subField,List<dynamic> members,String creatorsName)
  {
    List temp = List();

    return Firestore.instance.collection('Pending Projects').document('PendingProjects').get().then((pendingProjectList){

      pendingProjectList["Projects"].forEach((project){
        temp.add(project);
      });
      temp.add({
        "Name" : projectName,
        "CreatedBy" : creatorsName,
        "Field" : field,
        "Description" : description,
        "SubField" : subField,
        "Members" : members,
      });
      Firestore.instance.collection('Pending Projects').document('PendingProjects').setData(
          {"Projects" : temp,}
      );
    });
  }

  Future<dynamic> registerUserFromPending(String adminEmail,String adminPassword,String name,String email,String password,String branch,String phone,List tempUserList) async
  {
    String uid;
    print(tempUserList);
     _auth.createUserWithEmailAndPassword(email: email, password: password).then((newUid){
       if(newUid == null)
         print("Error in Auth");
       else{
         uid = newUid.user.uid;

           Firestore.instance.collection('Pending').document('Pending Users').setData({
             'User' : tempUserList,
           });

         FirebaseAPI().loginWithEmailAndPassword(adminEmail, adminPassword);

           print("Hey now brown cow");
           return databaseReference.collection('User').document(uid).setData(<String,dynamic>{
             "Name" : name,
             "Email" : email,
             "Password" : password,
             "Branch" : branch,
             'Phone' : phone,
             "Status" : 'user',
           }).then((value1){
             print("Success");
             return "Success";
           }).catchError((a){
             print("Fail");
             return a;
           });
       }
       return " hi";
     });
  }

  Future<String> registerProjectFromPending(String projectName,String field,List<dynamic> subField,List<dynamic> members,String creatorsName,String description,List tempProjectList) async
  {
    Firestore.instance.collection('Pending Projects').document('PendingProjects').setData({
      'Projects' : tempProjectList,
    });

    databaseReference.collection('Pending Projects').document(projectName).delete();

    return databaseReference.collection('Projects').document(projectName).setData(
        <String,dynamic>{
          'CR' : 0,
          'Field' : field,
          'SubField' : subField,
          'Members' : members,
          'CreatedBy' : creatorsName,
          'Description' : description,
        }
    ).then((value) {
      return "x";
    });
  }

  Future<String> deleteUserFromPending(List tempUserList)
  {
    return Firestore.instance.collection('Pending').document('Pending Users').setData({
      'User' : tempUserList,
    }).then((value) => "x");
  }

  Future<String> deleteProjectFromPending(List tempProjectList)
  {
    return Firestore.instance.collection('Pending Projects').document('PendingProjects').setData({
      'Projects' : tempProjectList,
    }).then((value) => "x");
  }

   Future<User> getUserInfoFromDatabase(String uid)
  {
   // print("Read Used for getting Users Info From database");

    return databaseReference.collection('User').document(uid).get().then((documentSnapShot){
      
      var userInfo = documentSnapShot.data;

        if(userInfo == null)
          return User();
        else{
          var user = User(
            uid: uid,
            email: userInfo["Email"],
            name: userInfo["Name"],
            password: userInfo["Password"],
            status: userInfo["Status"],
            projects: List<Project>(),
            phone: userInfo["Phone"],
          );
        /*  print("Logged In User : ");
          print("Name : " + user.name);
          print("Email-id : " + user.email);
          print("Password : " + user.password);
          print("Status : " + user.status); */
          return user;
        }

    });
  }


  
  Future<List<Project>> getUserProjectFromDatabase(String username)
  {
  //  print("Read Used for getting Users Projects From database");

    return databaseReference.collection("Projects").where("Members",arrayContains: username).getDocuments().then((value){
      List<Project> x = [];
      print(value.documents.length);
      for(int i=0;i<value.documents.length;i++){
        x.add(
            Project(
                createdBy: value.documents[i].data["CreatedBy"],
                name: value.documents[i].documentID,
                completionRate: value.documents[i].data["CR"],
                subField: value.documents[i].data["SubField"],
                members: value.documents[i].data["Members"],
                field: value.documents[i].data["Field"],
                memberRef: value.documents[i].data["MemberRef"],
            )
        );
      }
      return x;
    });
  }


  Future<void> editProfile(String uid,String name,String email,String phone,String password)
  {
    return databaseReference.collection("User").document(uid).setData({
      "Name" : name,
      "Email" : email,
      "Password" : password,
      "Phone" : phone,
    },merge: true);
  }

}