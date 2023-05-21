import 'package:flutter/material.dart';

AppBar header(context, {bool isAppTitle = false, String titleText}) {
  return AppBar(
    title: Text(
      isAppTitle ? 'BlogApp' : titleText ,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? "Signatra" : '',
        fontSize: isAppTitle ? 45.0 : 22.0
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
