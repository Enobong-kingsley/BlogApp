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
  @override
  void initState() {
    // TODO: implement initState
    //getUsersById();
    getUsers();
    super.initState();
  }

  getUsers() async{
    await Firebase.initializeApp();
    final QuerySnapshot snapshot = await usersRef

    //the limit query is set to limit the number of documents we want to see displayed
    .limit(2)

    //the orderBy query sorts the field in either descending order or otherwise
    //.orderBy("postsCount", descending: true)

    //the where query finds the position of a particular field and then handles an event
    // .where('postsCount', isLessThan: 3)
    // .where('username', isEqualTo: 'Percy')
    .get(); 
      snapshot.docs.forEach((DocumentSnapshot doc) {
        print(doc.data());
        print(doc.id);
        print(doc.exists);
       });

    
    // usersRef.get().then((QuerySnapshot snapshot) {
    //   snapshot.docs.forEach((DocumentSnapshot doc) {
    //     print(doc.data());
    //    });
    // });
  }

   Future<DocumentSnapshot> getUsersById() async{
    await Firebase.initializeApp();
    final String id = "p4W0RT8G8JXW8oyhf5ix";
    final doc = await usersRef
    .doc(id)
    .get();
    print(doc.data());
    
  }
  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context,isAppTitle: true),
      body: linearProgress()
    );
  }
}
