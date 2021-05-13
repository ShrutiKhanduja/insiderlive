import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insiderLive/PageView.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    WidgetsFlutterBinding.ensureInitialized();

    new Future.delayed(Duration(seconds: 3), () async {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Pageview()));
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      var islogin = prefs.getString('isLogged');
//
//      if (islogin == null) {
//        Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(
//            builder: (context) => HomeScreen(),
//          ),
//        );
//      } else {
//        Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(
//            builder: (context) => HomeScreen(),
//          ),
//        );
//      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Image(
              image: AssetImage('assets/insider.png'),
              width: MediaQuery.of(context).size.width * 0.5,
            )));
  }
}
