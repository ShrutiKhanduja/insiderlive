import 'package:flutter/material.dart';
import 'package:insiderLive/Constants/colors.dart';

class Appbar extends StatefulWidget {
  @override
  _AppbarState createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return Container(
      color:primarycolor,
      height:MediaQuery.of(context).size.height*0.08,
      width:MediaQuery.of(context).size.width,
      child:Padding(
        padding: const EdgeInsets.only(top:28.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Icon(Icons.settings,color:secondarycolor),
            Text('Discover',style:TextStyle(fontSize:height*0.02)),
            Row(children: [
              Text('My Feed',style:TextStyle(fontSize:height*0.02)),
              Icon(Icons.arrow_forward_ios,color:secondarycolor)
            ],)

          ]
        ),
      )
    );

  }
}
