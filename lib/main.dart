import 'package:blogapp/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


void main() {

   //enableTimestampsInSnapshots();

  runApp( MyApp());
}
// void enableTimestampsInSnapshots() async {
//    FirebaseFirestore firestore = FirebaseFirestore.instance;

//   try {
//     await firestore.enablePersistence();
//     print("Timestamps enabled in snapshots\n");
//   } catch (error) {
//     print("Error enabling timestamps in snapshots: $error\n");
//   }
// }

class MyApp extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot){
         if (snapshot.hasError) {
          return Text('Something went wrong');
        }
         // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return  MaterialApp(
      title: 'Blog App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.teal,
      ),
      home: Home(),
    );
        }
         // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      }
    );
   
  }
}

 