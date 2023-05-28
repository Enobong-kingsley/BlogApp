
import 'package:blogapp/widgets/header.dart';
import 'package:blogapp/widgets/progress.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {

  List <dynamic> users = [];
  @override
  void initState() {
    deleteUser();
    super.initState();
  }

  createUser() {
    usersRef.doc("asasasasas").set({
      "username" : "Jeff",
      "postsCount" : 0,
      "isAdmin" : false
    });
  }

  updateUser() async{
   final doc = await usersRef.doc("Nf1TuYTGP5n0SOP3d1YY").get();
   if(doc.exists) {
     doc.reference.update({
       "username" : "John",
      "postsCount" : 0,
      "isAdmin" : false
     });
   }
   }
  

  deleteUser() async{
   final DocumentSnapshot doc = await usersRef.doc("Nf1TuYTGP5n0SOP3d1YY").get();
   if(doc.exists){
    doc.reference.delete();   
   }
   
  }

  // getUsers() async{
  //   await Firebase.initializeApp();
  //   final QuerySnapshot snapshot = await usersRef
  //   .get();

  //   setState(() {
  //     users = snapshot.docs;
  //   });

    
  // }

  //  Future<DocumentSnapshot> getUsersById() async{
  //   await Firebase.initializeApp();
  //   final String id = "p4W0RT8G8JXW8oyhf5ix";
  //   final doc = await usersRef
  //   .doc(id)
  //   .get();
  //   print(doc.data());
    
  // }
  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context,isAppTitle: true),
      body:StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots() ,
        builder: (context , snapshot){
          if(!snapshot.hasData){
            return circularProgress();
          }
         final List<Text> children =  snapshot.data.docs.map((doc) => Text (doc['username'])).toList();
          return  Container(
        child: ListView(
          children: children,
          
        ),
      );
        },)
      
    );
  }
}
