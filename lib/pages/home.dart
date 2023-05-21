import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;


  @override
  void initState() {
 
    super.initState();
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
        print('User signed in : $account');
        setState(() {
          isAuth = true;
        });
      }else{
        setState(() {
          isAuth = false;
        });
      }
  }

    login(){
    googleSignIn.signIn();
  }

  logout(){
    googleSignIn.signOut();
  }

  Widget buildAuthScreen() {
    return ElevatedButton(
      onPressed: logout, 
    child: Text('Logout'));
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
