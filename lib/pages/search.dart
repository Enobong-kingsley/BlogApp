import 'package:blogapp/pages/activity_feed.dart';
import 'package:blogapp/pages/home.dart';
import 'package:blogapp/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/user.dart';

class Search extends StatefulWidget {
  
  @override
  _SearchState createState() => _SearchState();
}


class _SearchState extends State<Search> {

  TextEditingController searchController = TextEditingController();

  Future<QuerySnapshot> searchResultsFuture;

handleSearch(String query){
 Future<QuerySnapshot> users = usersRef.where(
    "displayName", isGreaterThanOrEqualTo: query
  ).get();
  setState(() {
    searchResultsFuture = users;
  });
}

clearSearch(){
  searchController.clear(); 
}

AppBar buildSearchField() {
   return AppBar(
    backgroundColor: Colors.white,
    title: TextFormField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: "Search for a user...",
        filled: true,
        prefixIcon:const Icon(Icons.account_box,
        size: 28,),
        suffixIcon: IconButton(
          onPressed: clearSearch, 
        icon: Icon(Icons.clear))
      ),
      onFieldSubmitted: handleSearch,
    ),
   );
}

Container buildNoContent(){
  final Orientation orientation = MediaQuery.of(context).orientation;
  return  Container(
    child: Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          SvgPicture.asset('assets/images/search.svg',
          height: orientation == Orientation.portrait? 300.0 :
          200.0,),
          const Text("Find Users",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            fontSize: 60
          ),)
        ],
      ),
    ),
  ); 
}

buildSearchResults(){
  return FutureBuilder(
    future: searchResultsFuture,
    builder: (context, snapshot){
      if(!snapshot.hasData){
        return circularProgress();
      }else{
      List<UserResult> searchResults = [];

      snapshot.data.docs.forEach((doc){
       User user = User.fromDocument(doc);
        UserResult searchResult = UserResult(user);
       searchResults.add(searchResult);
      });
      return ListView(
        children: searchResults,
      );
      }
    }
    );  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: buildSearchField(),
      body: searchResultsFuture == null ? buildNoContent()  : buildSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User user;

  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => showProfile(context, profileId: user.id),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title:  Text(user.displayName, style:const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),),
              subtitle: Text(user.username, style:const TextStyle(
                color: Colors.white
              ),),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          )
        ],
      ),
    );
  }
}
