import 'package:flutter/material.dart';
import 'package:insiderLive/Constants/controller.dart';
import 'package:insiderLive/feed_screen.dart';
import 'package:insiderLive/home_screen.dart';
import 'package:insiderLive/news_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pageview extends StatefulWidget {
  @override
  _PageviewState createState() => _PageviewState();
}

class _PageviewState extends State<Pageview> {


  Controller co;
  String cat='Insider Special';
  String eng='Insider Special';
  void pref()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('cat', cat);
    prefs.setString('eng', eng);
  }
//  PageController cont = PageController(
//    initialPage: 1,
//  );
//  @override
//  void dispose() {
//    co.controller.dispose();
//    super.dispose();
//  }

@override
  void initState() {
pref();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: Controller.cont,
      children: [
       HomeScreen(),
        FeedScreen(),
//        Webview()
      ],
    );
  }
}
