import 'package:blogapp/models/user.dart';
import 'package:blogapp/pages/activity_feed.dart';
import 'package:blogapp/pages/create_account.dart';
import 'package:blogapp/pages/profile.dart';
import 'package:blogapp/pages/search.dart';
import 'package:blogapp/pages/timeline.dart';
import 'package:blogapp/pages/upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final Reference storageRef = FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final commentsRef = FirebaseFirestore.instance.collection('comments');
final activityFeedRef = FirebaseFirestore.instance.collection('feed');
final timestamp = DateTime.now();
User currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;


  @override
  void initState() {
 
    super.initState();
    pageController = PageController();
    // THis detects when the user signs in 
    googleSignIn.onCurrentUserChanged.listen((account) {
     handleSignIn(account);
     }, onError: (err){
      print('Error signing in : $err');
     });
     // this funtion Reauthenticate user when app is reopened 
     googleSignIn.signInSilently(suppressErrors: false)
     .then((account){
      handleSignIn(account);
     }).catchError((err){
       print('Error signing in : $err');
     });
  }

  handleSignIn(GoogleSignInAccount account){
     if(account != null){
       createUserInFireStore();
        setState(() {
          isAuth = true;
        });
      }else{
        setState(() {
          isAuth = false;
        });
      }
  }

  createUserInFireStore() async{
    // 1: check if users exists in users collection in database (according to their id)

    final GoogleSignInAccount user = googleSignIn.currentUser;
     DocumentSnapshot doc = await usersRef.doc(user.id).get();
    
    if(!doc.exists){
      // 2: if the user doesnt exist, then we want to take them to the create account pgage to setup their profile.
      final username = await Navigator.push(context, MaterialPageRoute(builder: (context) 
      => CreateAccount()));

      // 3: get username from create account and use it to make new user document in users collection.
      usersRef.doc(user.id).set({
        "id" : user.id,
        "username": username,
        "photoUrl" : user.photoUrl,
        "email" : user.email,
        "displayName" : user.displayName,
        "bio" : "",
        "timestamp" : timestamp
      });
      doc = await usersRef.doc(user.id).get();
    }

    currentUser = User.fromDocument(doc); 
    print("::::${currentUser}::::::");
    print(currentUser.username);

  }

   @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();

  }
  
    login(){
    googleSignIn.signIn();
  }

  logout(){
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex){
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex){
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }
 

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
         controller: pageController,
        onPageChanged: onPageChanged,
        physics:const NeverScrollableScrollPhysics(),
        children: <Widget>  [
          //Timeline(),
          ElevatedButton(
      onPressed: logout, 
    child: Text('Logout')), 
          ActivityFeed(),
          Upload(currentUser : currentUser),
          Search(),
          Profile(profileId : currentUser?.id),
        ],
       
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot)
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active)
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera, size: 35.0,)
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.search)
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.account_circle)
          ),
        ],
      ),
    );
    // return ElevatedButton(
    //   onPressed: logout, 
    // child: Text('Logout'));
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
           const Text(
              'Blog App',
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 90.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            GestureDetector(
              onTap: () => login(),
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration:const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/google_signin_button.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
