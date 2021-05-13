import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:insiderLive/Constants/colors.dart';
import 'package:insiderLive/Constants/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryCard extends StatefulWidget {
  String name; String image;String eng;
  CategoryCard(this.name,this.image,this.eng);
  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  Controller controller;
void pref(String cat, String eng)async{

  SharedPreferences prefs=await SharedPreferences.getInstance();
  prefs.setString('cat',cat );
  prefs.setString('eng', eng);

}
@override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(){
        pref(widget.name,widget.eng);
        Controller.cont.jumpToPage(1);

      },
      child: Container(
        height:MediaQuery.of(context).size.height*0.25,
        width:MediaQuery.of(context).size.width*0.5,

        child:Theme(
          data:ThemeData(highlightColor: primarycolor),
          child: Card(

shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12.0)),
            child: Stack(
              children: [
               Container(

                 decoration:BoxDecoration(
                     borderRadius:BorderRadius.all(Radius.circular(12.0)),
                   image:DecorationImage(
                     fit:BoxFit.fill,

                     image: NetworkImage(widget.image),
                   )
                 ),


                 ),
                Positioned(

                  child: Container(
                    height:MediaQuery.of(context).size.height*0.27,
                    width:MediaQuery.of(context).size.width*0.5,
                    decoration: BoxDecoration(
                      borderRadius:BorderRadius.all(Radius.circular(12.0)),
                      gradient:LinearGradient(
                        begin: Alignment(0.51436, 1.07565),
                        end: Alignment(0.51436, -0.03208),
                        stops: [
                          0,
                          0.17571,
                          1,
                        ],
                        colors: [
                          Color.fromARGB(255, 0, 0, 0),
                          Color.fromARGB(255, 8, 8, 8),
                          Color.fromARGB(105, 45, 45, 45),
                        ],
                      ) ,
                    ),
                    child: Container(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(alignment:Alignment.bottomCenter,child: Text(widget.name,style:TextStyle(decoration:TextDecoration.underline,color:Colors.white,fontSize:MediaQuery.of(context).size.height*0.025,fontWeight: FontWeight.bold))),
                )
              ],
            ),

          ),
        )
      ),
    );
  }
}
