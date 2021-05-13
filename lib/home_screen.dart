import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insiderLive/Constants/categories.dart';
import 'package:insiderLive/Constants/colors.dart';
import 'package:insiderLive/Constants/controller.dart';
import 'package:insiderLive/Constants/data.dart';
import 'package:insiderLive/Widgets/appbar.dart';
import 'package:insiderLive/Widgets/categorycard.dart';
import 'package:insiderLive/news_details.dart';
import 'package:insiderLive/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Categories>allcats=[];
  int check=0;
  TextEditingController _text=TextEditingController();
  void cats()async{
    allcats.clear();
    await FirebaseFirestore.instance
        .collection('Category').orderBy('position')
        .snapshots().listen((event) {
          for(int i =0;i<event.docs.length;i++){
            setState(() {
              Categories cat= Categories(
                  event.docs[i]['ImageURL'],
                  event.docs[i]['Title'],
                  event.docs[i]['hindiTitle'],
                  event.docs[i]['position'].toString()
              );
              allcats.add(cat);
            });

          }
          print(allcats.length);
          topics();
    });
  }
  List<Widget>alltopics=[];
 Future<String> text(String title)async{
   var out=await translator.translate(title,from:'hi',to:'en').toString();
   return out;
 }


  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  Controller controller;
  void pref(String cat, String eng)async{

    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setString('cat',cat );
    prefs.setString('eng', eng);

  }
  final translator=GoogleTranslator();

  void topics()async{
    setState(() {
      alltopics.add(
        Column(
          children: [
//            Container(
//
//                color: primarycolor,
//                child: SafeArea(child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: [
//                        Center(child: Image.asset('assets/insider.png',scale:1.5)),
//                        SizedBox(width:50),
//                        Icon(Icons.arrow_forward_ios,size:40)
//                      ],
//                    )),
//
//            ),


            SizedBox(height: 8),
            InkWell(
              onTap:(){
                Navigator.push(context,MaterialPageRoute(builder:(context)=>Search()));
              },
              child: Container(
                  height:MediaQuery.of(context).size.height*0.07,
                  width:MediaQuery.of(context).size.width*0.95,
                  decoration: BoxDecoration(border: Border.all(color:Colors.grey)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.search,color: Colors.grey,),
                        SizedBox(width:10),
                        Text('Search for news..',style:GoogleFonts.poppins(color:Colors.grey))

                      ],
                    ),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Categories',style:GoogleFonts.poppins(color:Colors.black,fontSize:MediaQuery.of(context).size.height*0.025,fontWeight: FontWeight.bold))),
            ),
            Container(
              height:200,
              child: GridView.count(
                physics: ClampingScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: EdgeInsets.all(8),
                childAspectRatio: MediaQuery.of(context).size.width/MediaQuery.of(context).size.height*2,
                children: [
                  InkWell(
                    onTap:(){
                      pref('देश','National');
                      Controller.cont.jumpToPage(1);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height:50,
                            child: Image.asset('assets/country.png')),
                        Text('देश',style:GoogleFonts.poppins(color:primarycolor,fontSize: MediaQuery.of(context).size.height*0.018,fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap:(){
                      pref('राज्य','State');
                      Controller.cont.jumpToPage(1);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height:50,
                            child: Image.asset('assets/state.png')),
                        Text('राज्य',style:GoogleFonts.poppins(color:primarycolor,fontSize:  MediaQuery.of(context).size.height*0.018,fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap:(){
                      pref('राजनीति','Politics');
                      Controller.cont.jumpToPage(1);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height:50,
                            child: Image.asset('assets/political.png')),
                        Text('राजनीति',style:GoogleFonts.poppins(color:primarycolor,fontSize:  MediaQuery.of(context).size.height*0.018,fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap:(){
                      pref('अंतरराष्ट्रीय','International');
                      Controller.cont.jumpToPage(1);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height:50,
                            child: Image.asset('assets/international.png')),
                        Text('अंतरराष्ट्रीय',style:GoogleFonts.poppins(color:primarycolor,fontSize:  MediaQuery.of(context).size.height*0.018,fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap:(){
                      pref('मनोरंजन','Entertainment');
                      Controller.cont.jumpToPage(1);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height:50,
                            child: Image.asset('assets/entertainment.png')),
                        Text('मनोरंजन'
                            ,style:GoogleFonts.poppins(color:primarycolor,fontSize:  MediaQuery.of(context).size.height*0.018,fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap:(){
                      pref('खेल','Sports');
                      Controller.cont.jumpToPage(1);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height:50,
                            child: Image.asset('assets/sports.png')),
                        Text('खेल'
                            ,style:GoogleFonts.poppins(color:primarycolor,fontSize:  MediaQuery.of(context).size.height*0.018,fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap:(){
                      pref('कारोबार','Business');
                      Controller.cont.jumpToPage(1);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height:50,
                            child: Image.asset('assets/business.png')),
                        Text('कारोबार',style:GoogleFonts.poppins(color:primarycolor,fontSize:  MediaQuery.of(context).size.height*0.018,fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap:(){
                      pref('Insider Special','Insider Special');
                      Controller.cont.jumpToPage(1);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height:50,
                            child: Image.asset('assets/special.png')),
                        Center(child: Text(' Insider\nSpecial',style:GoogleFonts.poppins(color:primarycolor,fontSize:  MediaQuery.of(context).size.height*0.015,fontWeight: FontWeight.bold)))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(alignment:Alignment.topLeft,child: Text('Suggested topics',style:GoogleFonts.poppins(color:secondarycolor,fontWeight:FontWeight.bold,fontSize: MediaQuery.of(context).size.height*0.023))),
            ),


          ]

        ),
      );

    });
    check=0;
    List<Data> allnews=[];
    for(int i=0;i<allcats.length;i++){


       FirebaseFirestore.instance.collection('NewsSchem1').where('category',isEqualTo: allcats[i].title).orderBy('TimeStamp',descending: true).limit(5).snapshots().listen((event)async {
//        print(event.docs[0]['imageURL']);
         setState(() {
           allnews.clear();
         });
         check = 0;


         setState(() {
           alltopics.add(
              Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Container(
                     height:MediaQuery.of(context).size.height*0.41,
                     width:MediaQuery.of(context).size.width*0.95,
                     decoration:BoxDecoration(borderRadius:BorderRadius.all(Radius.circular(12.0)),border:Border.all(color:secondarycolor)),
                     child:Column(
                       children: [
                         Container(
                             height:MediaQuery.of(context).size.height*0.05,
                             width:MediaQuery.of(context).size.width*0.95,
                             decoration:BoxDecoration(color:primarycolor,borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0),topRight: Radius.circular(12.0))),
                             child:Center(child: Text(allcats[i].hindititle,style:GoogleFonts.poppins(color:secondarycolor,fontSize:MediaQuery.of(context).size.height*0.025,fontWeight: FontWeight.bold)))
                         ),
                         Container(
                           height:MediaQuery.of(context).size.height*0.3,
                           width:MediaQuery.of(context).size.width,
                           child: ListView.builder(
                               itemCount: 5,
                               shrinkWrap: true,
                               itemBuilder: (context, index) {

                                 var item = index;
//                                 print(event.docs[index]['title']);
                                 if(check<4){
                                   check++;
                                 }


//                                print('Image:${event.docs[index]['imageURL']}');
                                 return Column(
                                     children:[
                                       InkWell(
                                         onTap:(){
                                           Navigator.push(context,MaterialPageRoute(builder:(context)=>NewsDetails(event.docs[index]['category'], event.docs[index].id)));
//                                          _launchURL('https://insiderlive.in/news/${event.docs[index].id}/${event.docs[index]['category']}');
                                         },
                                         child: Row(children:[
                                           Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: Container(
                                                 height:MediaQuery.of(context).size.height*0.08,
                                                 width:MediaQuery.of(context).size.width*0.2,

                                                 child:ClipRRect(borderRadius: BorderRadius.circular(4),child: FancyShimmerImage(imageUrl:event.docs[index]['imageURL'] ,boxFit: BoxFit.fill,shimmerDuration:Duration(seconds: 1),shimmerBaseColor: Colors.grey,))
//                                              decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0),),image: DecorationImage(image: FancyShimmerImage(url:event.docs[index]['imageURL']),fit: BoxFit.fill)),
                                             ),
                                           ),
                                           Container(width:MediaQuery.of(context).size.width*0.6,child: Center(child: Text( event.docs[index]['title'],maxLines:2,overflow:TextOverflow.ellipsis,style:GoogleFonts.poppins(color:secondarycolor,))))
                                         ]),
                                       ),
                                       Divider(color:secondarycolor)
                                     ]
                                 );
                               }
                           ),
                         ),
                         InkWell(
                             onTap:(){
                               pref(allcats[i].hindititle,allcats[i].title);
                               Controller.cont.jumpToPage(1);
                             },
                             child: Container(
                                 height:MediaQuery.of(context).size.height*0.05,
                                 width:MediaQuery.of(context).size.width*0.85,child: Center(child: Text('Read more',style:GoogleFonts.poppins(color:Colors.blue,fontWeight:FontWeight.bold,fontSize:MediaQuery.of(context).size.height*0.015,decoration: TextDecoration.underline)))))
                       ],
                     )
                 ),
               )
           );
         });
       });





//        print('Topics:${alltopics.length}');


    }

  }
  @override
  void initState() {
    cats();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
//    print('Topicsbuild:${alltopics.length}');
    return Scaffold(
      backgroundColor: Colors.white,
appBar: AppBar(

  backgroundColor: primarycolor,
    title: Image.asset('assets/insider.png',scale:1.7),
  centerTitle: true,
  actions: [
    InkWell(
      onTap:(){
        Controller.cont.jumpToPage(1);
      },
        child: Icon(Icons.arrow_forward_ios,color:Colors.white,size:35))
  ],
),
//      appBar: PreferredSize(child: Appbar(),preferredSize:Size.fromHeight(MediaQuery.of(context).size.height*0.085)),
      body:
        SingleChildScrollView(
          child: Column(
            children: alltopics,
          )
        )
//        Stack(
//          children: [
//            Positioned(
//              top:0.0,
//              child:Container(
//                height:height*0.3,
//                width:width,
//                decoration:BoxDecoration(color:primarycolor,borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft:Radius.circular(10))),
//                child:Column(
//                  children:[
//                    Padding(
//                      padding: const EdgeInsets.only(top:40.0,left:12.0),
//                      child: Align(alignment:Alignment.bottomLeft,child: Text('Discover',style:GoogleFonts.poppins(fontSize: height*0.03,fontWeight: FontWeight.bold))),
//
//                    ),
////                    Padding(
////                      padding: const EdgeInsets.all(12.0),
////                      child: Center(
////                        child: Container(
////                          width:width*0.8,
////                          decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.0))),
////                          child: TextFormField(
////
////                              decoration:InputDecoration(border:InputBorder.none,fillColor: Colors.white,filled: true,prefixIcon: Icon(Icons.search,color:Colors.grey.withOpacity(0.8),),hintText: 'Search for news',hintStyle: TextStyle(color:Colors.grey.withOpacity(0.8)),)
////                          ),
////                        ),
////                      ),
////                    ),
//
//                  ]
//                ),
//              )
//            ),
//
//
////            Padding(
////              padding: const EdgeInsets.all(8.0),
////              child: Align(alignment:Alignment.bottomLeft,child: Text('Categories',textAlign: TextAlign.left,style:TextStyle(color:secondarycolor,fontSize:height*0.028))),
////            ),
//            Positioned(
//              top:height*0.25,
//              left:0.0,
//right:0.0,
//
////              height:height*0.27,
//
//                      child: (allcats.length!=0)?SizedBox(
//                        height: height * 0.27,
//                        child: ListView.builder(
//                            itemCount: allcats.length,
//                            shrinkWrap: true,
//                            scrollDirection: Axis.horizontal,
//                            itemBuilder: (context, index) {
//                              var item = allcats[index];
//
//                              return CategoryCard(item.hindititle,item.Imageurl,item.title);
//                            }),
//                      ):Center(
//                        child: Container(
//                            height:100,
//                            width:100,
//                            child:SpinKitWave(color:primarycolor,size:height*0.023)
//                        ),
//
//            ),),
//            Positioned(
//              top:height*0.52,
//              right:0.0,
//              left:0.0,
//              child:Column(
//                children: [
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Align(alignment:Alignment.topLeft,child: Text('Suggested topics',style:GoogleFonts.poppins(color:secondarycolor,fontWeight:FontWeight.bold,fontSize:height*0.023))),
//                  ),
//                  SizedBox(height:height*0.4,
//                      width:width,child: alltopics.length!=0?ListView(scrollDirection:Axis.horizontal,children: alltopics,shrinkWrap: true,):Center(
//        child: Container(
//        height:100,
//        width:100,
//        child:SpinKitWave(color:primarycolor,size:height*0.023)
//    ),
//                    ) )],
//              )
//            )
//          ],
//        )
    );
  }
}
