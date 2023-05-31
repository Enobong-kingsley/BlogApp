import 'package:blogapp/models/user.dart';
import 'package:blogapp/pages/home.dart';
import 'package:blogapp/widgets/header.dart';
import 'package:blogapp/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String profileId;

  Profile({
    this.profileId
  });
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Column buildCountColumn(String lebel, int count){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22,
          fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            lebel,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

      ],
    );
  }

  buildProfileButton(){
    return Text("Profile Button");
  }


  buildProfileHeader(){
    return FutureBuilder(
      future: usersRef.doc(widget.profileId).get(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return circularProgress();

        }
        User user = User.fromDocument(snapshot.data); 
        return Padding(padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
           Row(
            children: [
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(
                  user.photoUrl
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildCountColumn("posts", 0),
                         buildCountColumn("followers", 0),
                          buildCountColumn("following", 0),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildProfileButton(),
                      ],
                    )
                  ],
                ),
                )
            ],
           ),
           Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 12),
            child: Text(
              user.username,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0
              ),
            ),
           ),
           Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 4.0),
            child: Text(user.displayName,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
            ),
           ),
            Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 2.0),
            child: Text(user.displayName,
             
            ),
           )
          ],
        ),
        );
      },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Profile"),
      body: ListView(
        children: [
          buildProfileHeader(),
        ],
      )
    );
  }
}
