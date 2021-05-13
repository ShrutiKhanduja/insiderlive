import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insiderLive/Constants/categories.dart';
import 'package:insiderLive/Constants/colors.dart';
import 'package:insiderLive/Constants/controller.dart';
import 'package:insiderLive/Constants/data.dart';
import 'package:insiderLive/news_details.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedScreen extends StatefulWidget {


  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  List<Data>allnews=[];
  List<String>allparas=[];
  List<Categories>allcats=[];
  int check=0;
  void cats()async{
    allcats.clear();
    await FirebaseFirestore.instance
        .collection('Category').orderBy('position')
        .snapshots().listen((event) {
          allcats.add(Categories('','Insider Special','',''));
      for(int i =0;i<event.docs.length;i++){
        if(event.docs[i]['Title']!='Insider Special'){
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


      }
      print(allcats.length);
          pref();
    });

  }
  final translator=GoogleTranslator();
  void data(String category)async{
    allnews.clear();

    FirebaseFirestore.instance.collection('NewsSchem1').where('category',isEqualTo: category).orderBy('TimeStamp',descending: true).snapshots().listen((event) async{
     for(int i=0;i<event.docs.length;i++){

//       print(i);
//          print( event.docs[i].id,);
       setState(() {
         allnews.add(Data(
             event.docs[i]['imageURL'],
            event.docs[i]['content'],
             event.docs[i]['title'],
           event.docs[i].id
         ));
       });
       for(int j=0;j<event.docs[i]['content'].length;j++){
//         print(i);
         Map<String,dynamic>map=event.docs[i]['content'][j];
         if(map.keys.contains('para')){

//                print(map);
             allparas.add(event.docs[i]['content'][j]['para'].toString());
           break;

         }
       }
     }
//print('Allnews:${allnews.length}');
//     print('Allparas:${allparas.length}');
    });
  }
  String cat; String eng;
  void pref()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    setState(() {
      cat =prefs.getString('cat');
      eng= prefs.getString('eng');
    });

    for(int i=0;i<allcats.length;i++){
      if(eng==allcats[i].title){
        category=i;
      }
    }
   data(eng);
  }
  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  @override
  void initState() {
cats();

    super.initState();
  }
  int category;
  Controller controller;
  @override

  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
         leading: InkWell(
           onTap:(){
             Controller.cont.jumpToPage(0);
           },
             child: Icon(Icons.remove_red_eye,color:Colors.white)),
        title: (cat!=null)?Text(cat,textAlign: TextAlign.center,style:GoogleFonts.poppins()):Container(),
        backgroundColor: primarycolor,
        centerTitle: true,

      ),
      body:Container(
        height:height,
        width:width,
        child: Column(

          children: [
            Container(
              height:40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allcats.length,
                  itemBuilder: (context,index){
                return InkWell(
                  onTap:(){
                    setState(() {
                      category=index;
                      print(category);
                      (allcats[index].title!='Insider Special')?eng=allcats[index].hindititle:eng='Insider Special';
                      cat=allcats[index].hindititle;
                      eng=allcats[index].title;
                    data(allcats[index].title);
                    });

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      allcats[index].title.toUpperCase(),
                      style:GoogleFonts.poppins(color:(index==category)?primarycolor:Colors.grey,fontSize:height*0.02)
                    ),
                  ),
                );
              }),
            ),
            Expanded(
//              child:PaginateFirestore(
//                scrollDirection: Axis.vertical,
//                shrinkWrap: true,
//                itemBuilderType:
//                PaginateBuilderType.listView,
//
//                query: FirebaseFirestore.instance.collection('NewsSchem1').where('category',isEqualTo: eng).orderBy('TimeStamp',descending: true),
//    itemBuilder: (index, context, documentSnapshot) {
//                  print(eng);
//                  allparas.clear();
//      for(int j=0;j<documentSnapshot.data()['content'].length;j++){
////         print(i);
//        Map<String,dynamic>map=documentSnapshot.data()['content'][j];
//        if(map.keys.contains('para')){
////                print(map);
//          allparas.add(documentSnapshot.data()['content'][j]['para']);
//          break;
//
//        }
//      }
//                  return Container(
//                    height:height*0.9,
//                    width:width,
//                    child: Column(
//                      children: [
//                        Container(
//                          height:height*0.4,
//                          child: Stack(
//                              children: [
//                                Positioned(
//                                    top:height*0.02,
//                                    child:Container(
//                                      height:height*0.4,
//                                      width:width,
//                                      decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(documentSnapshot.data()['imageURL']),fit: BoxFit.cover)),
//                                      child:ClipRRect(
//
//                                        child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
//                                          child: Container(
//                                              height:height*0.4,
//                                              width:width,
//                                              decoration:BoxDecoration(color:Colors.white.withOpacity(0.0))
//                                          ),
//                                        ),
//                                      ),
//                                    )
//                                ),
//                                Positioned(
//                                    top:height*0.03,
//                                    left:width*0.025,
//                                    child:Container(
//                                        height:height*0.36,
//                                        width:width*0.95,
//                                        child:FancyShimmerImage(imageUrl: documentSnapshot.data()['imageURL'],boxFit: BoxFit.fill,shimmerBaseColor: Colors.grey,shimmerDuration: Duration(seconds: 1),)
////                                decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(allnews[index].url),fit: BoxFit.cover))),
//                                    ))]),
//                        ),
//
//                        Column(
//                          children: [
//                            Center(
//                              child: Container(
//                                  height:height*0.1,
//                                  width:width*0.9,
//                                  child: Text(documentSnapshot.data()['title'],maxLines:2,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: height*0.025))),
//                            ),
//                            Container(
//                                height:200,
//                                width:width*0.9,
//                                child: Text(allparas[0],maxLines: 7,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontSize: height*0.02))),
//
//                          ],
//                        ),
//
//                        InkWell(
//                          onTap: (){
//                            Navigator.push(context,MaterialPageRoute(builder: (context)=>NewsDetails(cat,documentSnapshot.id)));
//                          },
//                          child: Container(
//                            height:height*0.1,
//                            width:width,
//                            decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(documentSnapshot.data()['imageURL']),fit:BoxFit.fill)),
//                            child:ClipRRect(
//                              child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
//                                child: Container(
//                                  height:height*0.1,
//                                  width:width,
//                                  decoration:BoxDecoration(color:Colors.black.withOpacity(0.6)),
//                                  child: Column(
//                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    children: [
//                                      Container(
//                                          height:height*0.05,
//                                          width:width*0.9,
//                                          child: Padding(
//                                            padding: const EdgeInsets.all(8.0),
//                                            child: Text(documentSnapshot.data()['title'],maxLines:1,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.02)),
//                                          )),
//                                      Padding(
//                                        padding: const EdgeInsets.only(left:8.0),
//                                        child: Text('Tap to read more...',overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.018)),
//                                      )
//                                    ],
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ),
//                        )
//
//                      ],
//                    ),
//                  );
//    },
//              )
              child: (allnews.length!=0&&allparas.length!=0)?PageView.builder(
                itemCount: allnews.length,

                  scrollDirection: Axis.vertical,
                  itemBuilder:(context,index){
                return Container(
                  height:height*0.9,
                  width:width,
                  child: Column(
                    children: [
                      Container(
                        height:height*0.4,
                        child: Stack(
                          children: [
                            Positioned(
                              top:height*0.02,
                              child:Container(
                                height:height*0.4,
                                width:width,
                                decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(allnews[index].url),fit: BoxFit.cover)),
                                child:ClipRRect(

                                  child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
                                    child: Container(
                                        height:height*0.4,
                                        width:width,
                                      decoration:BoxDecoration(color:Colors.white.withOpacity(0.0))
                                    ),
                                  ),
                                ),
                              )
                            ),
                            Positioned(
                              top:height*0.03,
                              left:width*0.025,
                              child:Container(
                                height:height*0.36,
                                width:width*0.95,
child:FancyShimmerImage(imageUrl: allnews[index].url,boxFit: BoxFit.fill,shimmerBaseColor: Colors.grey,shimmerDuration: Duration(seconds: 1),)
//                                decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(allnews[index].url),fit: BoxFit.cover))),
                            ))]),
                      ),

                             Column(
                              children: [
                                Center(
                                  child: Container(
                                    height:height*0.1,
                                      width:width*0.9,
                                      child: Text(allnews[index].title,maxLines:2,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: height*0.025))),
                                ),
                                (allparas[index]!=null&&allparas[index]!='')?Container(
                                    height:200,
                                    width:width*0.9,
                                    child: Text(allparas[index],maxLines: 7,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontSize: height*0.02))):Container(
                                  height:100,
                                  width:100,
                                  child:SpinKitWave(color:primarycolor,size:height*0.023),

                                )],
                            ),

                          InkWell(
                            onTap: (){
                             Navigator.push(context,MaterialPageRoute(builder: (context)=>NewsDetails(cat,allnews[index].id)));
                            },
                            child: Container(
                              height:height*0.1,
                              width:width,
                              decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(allnews[index].url),fit:BoxFit.fill)),
                              child:ClipRRect(
                                child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
                                  child: Container(
                                      height:height*0.1,
                                      width:width,
                                      decoration:BoxDecoration(color:Colors.black.withOpacity(0.6)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            height:height*0.05,
                                            width:width*0.9,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(allnews[index].title,maxLines:1,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.02)),
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.only(left:8.0),
                                          child: Text('Tap to read more...',overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.018)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )

                    ],
                  ),
                );
              } ):Container(
        height:100,
        width:100,
        child:SpinKitWave(color:primarycolor,size:height*0.023)
    ),
//            ):(eng=='State')?Expanded(
//      child:PaginateFirestore(
//      scrollDirection: Axis.vertical,
//        shrinkWrap: true,
//        itemBuilderType:
//        PaginateBuilderType.listView,
//
//        query: FirebaseFirestore.instance.collection('NewsSchem1').where('category',isEqualTo: eng).orderBy('TimeStamp',descending: true),
//        itemBuilder: (index, context, documentSnapshot) {
//          print(eng);
//          allparas.clear();
//          for(int j=0;j<documentSnapshot.data()['content'].length;j++){
////         print(i);
//            Map<String,dynamic>map=documentSnapshot.data()['content'][j];
//            if(map.keys.contains('para')){
////                print(map);
//              allparas.add(documentSnapshot.data()['content'][j]['para']);
//              break;
//
//            }
//          }
//          return Container(
//            height:height*0.9,
//            width:width,
//            child: Column(
//              children: [
//                Container(
//                  height:height*0.4,
//                  child: Stack(
//                      children: [
//                        Positioned(
//                            top:height*0.02,
//                            child:Container(
//                              height:height*0.4,
//                              width:width,
//                              decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(documentSnapshot.data()['imageURL']),fit: BoxFit.cover)),
//                              child:ClipRRect(
//
//                                child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
//                                  child: Container(
//                                      height:height*0.4,
//                                      width:width,
//                                      decoration:BoxDecoration(color:Colors.white.withOpacity(0.0))
//                                  ),
//                                ),
//                              ),
//                            )
//                        ),
//                        Positioned(
//                            top:height*0.03,
//                            left:width*0.025,
//                            child:Container(
//                                height:height*0.36,
//                                width:width*0.95,
//                                child:FancyShimmerImage(imageUrl: documentSnapshot.data()['imageURL'],boxFit: BoxFit.fill,shimmerBaseColor: Colors.grey,shimmerDuration: Duration(seconds: 1),)
////                                decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(allnews[index].url),fit: BoxFit.cover))),
//                            ))]),
//                ),
//
//                Column(
//                  children: [
//                    Center(
//                      child: Container(
//                          height:height*0.1,
//                          width:width*0.9,
//                          child: Text(documentSnapshot.data()['title'],maxLines:2,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: height*0.025))),
//                    ),
//                    Container(
//                        height:200,
//                        width:width*0.9,
//                        child: Text(allparas[0],maxLines: 7,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontSize: height*0.02))),
//
//                  ],
//                ),
//
//                InkWell(
//                  onTap: (){
//                    Navigator.push(context,MaterialPageRoute(builder: (context)=>NewsDetails(cat,documentSnapshot.id)));
//                  },
//                  child: Container(
//                    height:height*0.1,
//                    width:width,
//                    decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(documentSnapshot.data()['imageURL']),fit:BoxFit.fill)),
//                    child:ClipRRect(
//                      child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
//                        child: Container(
//                          height:height*0.1,
//                          width:width,
//                          decoration:BoxDecoration(color:Colors.black.withOpacity(0.6)),
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: [
//                              Container(
//                                  height:height*0.05,
//                                  width:width*0.9,
//                                  child: Padding(
//                                    padding: const EdgeInsets.all(8.0),
//                                    child: Text(documentSnapshot.data()['title'],maxLines:1,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.02)),
//                                  )),
//                              Padding(
//                                padding: const EdgeInsets.only(left:8.0),
//                                child: Text('Tap to read more...',overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.018)),
//                              )
//                            ],
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                )
//
//              ],
//            ),
//          );
//        },
//      )):(eng=='International')?Expanded(
//              child:PaginateFirestore(
//                scrollDirection: Axis.vertical,
//                shrinkWrap: true,
//                itemBuilderType:
//                PaginateBuilderType.listView,
//
//                query: FirebaseFirestore.instance.collection('NewsSchem1').where('category',isEqualTo: eng).orderBy('TimeStamp',descending: true),
//                itemBuilder: (index, context, documentSnapshot) {
//                  print(eng);
//                  allparas.clear();
//                  for(int j=0;j<documentSnapshot.data()['content'].length;j++){
////         print(i);
//                    Map<String,dynamic>map=documentSnapshot.data()['content'][j];
//                    if(map.keys.contains('para')){
////                print(map);
//                      allparas.add(documentSnapshot.data()['content'][j]['para']);
//                      break;
//
//                    }
//                  }
//                  return Container(
//                    height:height*0.9,
//                    width:width,
//                    child: Column(
//                      children: [
//                        Container(
//                          height:height*0.4,
//                          child: Stack(
//                              children: [
//                                Positioned(
//                                    top:height*0.02,
//                                    child:Container(
//                                      height:height*0.4,
//                                      width:width,
//                                      decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(documentSnapshot.data()['imageURL']),fit: BoxFit.cover)),
//                                      child:ClipRRect(
//
//                                        child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
//                                          child: Container(
//                                              height:height*0.4,
//                                              width:width,
//                                              decoration:BoxDecoration(color:Colors.white.withOpacity(0.0))
//                                          ),
//                                        ),
//                                      ),
//                                    )
//                                ),
//                                Positioned(
//                                    top:height*0.03,
//                                    left:width*0.025,
//                                    child:Container(
//                                        height:height*0.36,
//                                        width:width*0.95,
//                                        child:FancyShimmerImage(imageUrl: documentSnapshot.data()['imageURL'],boxFit: BoxFit.fill,shimmerBaseColor: Colors.grey,shimmerDuration: Duration(seconds: 1),)
////                                decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(allnews[index].url),fit: BoxFit.cover))),
//                                    ))]),
//                        ),
//
//                        Column(
//                          children: [
//                            Center(
//                              child: Container(
//                                  height:height*0.1,
//                                  width:width*0.9,
//                                  child: Text(documentSnapshot.data()['title'],maxLines:2,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: height*0.025))),
//                            ),
//                            Container(
//                                height:200,
//                                width:width*0.9,
//                                child: Text(allparas[0],maxLines: 7,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontSize: height*0.02))),
//
//                          ],
//                        ),
//
//                        InkWell(
//                          onTap: (){
//                            Navigator.push(context,MaterialPageRoute(builder: (context)=>NewsDetails(cat,documentSnapshot.id)));
//                          },
//                          child: Container(
//                            height:height*0.1,
//                            width:width,
//                            decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(documentSnapshot.data()['imageURL']),fit:BoxFit.fill)),
//                            child:ClipRRect(
//                              child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
//                                child: Container(
//                                  height:height*0.1,
//                                  width:width,
//                                  decoration:BoxDecoration(color:Colors.black.withOpacity(0.6)),
//                                  child: Column(
//                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    children: [
//                                      Container(
//                                          height:height*0.05,
//                                          width:width*0.9,
//                                          child: Padding(
//                                            padding: const EdgeInsets.all(8.0),
//                                            child: Text(documentSnapshot.data()['title'],maxLines:1,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.02)),
//                                          )),
//                                      Padding(
//                                        padding: const EdgeInsets.only(left:8.0),
//                                        child: Text('Tap to read more...',overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.018)),
//                                      )
//                                    ],
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ),
//                        )
//
//                      ],
//                    ),
//                  );
//                },
//              )):(eng=='National')?Expanded(
//              child:PaginateFirestore(
//                scrollDirection: Axis.vertical,
//                shrinkWrap: true,
//                itemBuilderType:
//                PaginateBuilderType.listView,
//
//                query: FirebaseFirestore.instance.collection('NewsSchem1').where('category',isEqualTo: eng).orderBy('TimeStamp',descending: true),
//                itemBuilder: (index, context, documentSnapshot) {
//                  print(eng);
//                  allparas.clear();
//                  for(int j=0;j<documentSnapshot.data()['content'].length;j++){
////         print(i);
//                    Map<String,dynamic>map=documentSnapshot.data()['content'][j];
//                    if(map.keys.contains('para')){
////                print(map);
//                      allparas.add(documentSnapshot.data()['content'][j]['para']);
//                      break;
//
//                    }
//                  }
//                  return Container(
//                    height:height*0.9,
//                    width:width,
//                    child: Column(
//                      children: [
//                        Container(
//                          height:height*0.4,
//                          child: Stack(
//                              children: [
//                                Positioned(
//                                    top:height*0.02,
//                                    child:Container(
//                                      height:height*0.4,
//                                      width:width,
//                                      decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(documentSnapshot.data()['imageURL']),fit: BoxFit.cover)),
//                                      child:ClipRRect(
//
//                                        child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
//                                          child: Container(
//                                              height:height*0.4,
//                                              width:width,
//                                              decoration:BoxDecoration(color:Colors.white.withOpacity(0.0))
//                                          ),
//                                        ),
//                                      ),
//                                    )
//                                ),
//                                Positioned(
//                                    top:height*0.03,
//                                    left:width*0.025,
//                                    child:Container(
//                                        height:height*0.36,
//                                        width:width*0.95,
//                                        child:FancyShimmerImage(imageUrl: documentSnapshot.data()['imageURL'],boxFit: BoxFit.fill,shimmerBaseColor: Colors.grey,shimmerDuration: Duration(seconds: 1),)
////                                decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(allnews[index].url),fit: BoxFit.cover))),
//                                    ))]),
//                        ),
//
//                        Column(
//                          children: [
//                            Center(
//                              child: Container(
//                                  height:height*0.1,
//                                  width:width*0.9,
//                                  child: Text(documentSnapshot.data()['title'],maxLines:2,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: height*0.025))),
//                            ),
//                            Container(
//                                height:200,
//                                width:width*0.9,
//                                child: Text(allparas[0],maxLines: 7,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontSize: height*0.02))),
//
//                          ],
//                        ),
//
//                        InkWell(
//                          onTap: (){
//                            Navigator.push(context,MaterialPageRoute(builder: (context)=>NewsDetails(cat,documentSnapshot.id)));
//                          },
//                          child: Container(
//                            height:height*0.1,
//                            width:width,
//                            decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(documentSnapshot.data()['imageURL']),fit:BoxFit.fill)),
//                            child:ClipRRect(
//                              child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
//                                child: Container(
//                                  height:height*0.1,
//                                  width:width,
//                                  decoration:BoxDecoration(color:Colors.black.withOpacity(0.6)),
//                                  child: Column(
//                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    children: [
//                                      Container(
//                                          height:height*0.05,
//                                          width:width*0.9,
//                                          child: Padding(
//                                            padding: const EdgeInsets.all(8.0),
//                                            child: Text(documentSnapshot.data()['title'],maxLines:1,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.02)),
//                                          )),
//                                      Padding(
//                                        padding: const EdgeInsets.only(left:8.0),
//                                        child: Text('Tap to read more...',overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.018)),
//                                      )
//                                    ],
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ),
//                        )
//
//                      ],
//                    ),
//                  );
//                },
//              )):(eng=='Entertainment')?Expanded(
//      child:PaginateFirestore(
//      scrollDirection: Axis.vertical,
//        shrinkWrap: true,
//        itemBuilderType:
//        PaginateBuilderType.listView,
//
//        query: FirebaseFirestore.instance.collection('NewsSchem1').where('category',isEqualTo: eng).orderBy('TimeStamp',descending: true),
//        itemBuilder: (index, context, documentSnapshot) {
//          print(eng);
//          allparas.clear();
//          for(int j=0;j<documentSnapshot.data()['content'].length;j++){
////         print(i);
//            Map<String,dynamic>map=documentSnapshot.data()['content'][j];
//            if(map.keys.contains('para')){
////                print(map);
//              allparas.add(documentSnapshot.data()['content'][j]['para']);
//              break;
//
//            }
//          }
//          return Container(
//            height:height*0.9,
//            width:width,
//            child: Column(
//              children: [
//                Container(
//                  height:height*0.4,
//                  child: Stack(
//                      children: [
//                        Positioned(
//                            top:height*0.02,
//                            child:Container(
//                              height:height*0.4,
//                              width:width,
//                              decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(documentSnapshot.data()['imageURL']),fit: BoxFit.cover)),
//                              child:ClipRRect(
//
//                                child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
//                                  child: Container(
//                                      height:height*0.4,
//                                      width:width,
//                                      decoration:BoxDecoration(color:Colors.white.withOpacity(0.0))
//                                  ),
//                                ),
//                              ),
//                            )
//                        ),
//                        Positioned(
//                            top:height*0.03,
//                            left:width*0.025,
//                            child:Container(
//                                height:height*0.36,
//                                width:width*0.95,
//                                child:FancyShimmerImage(imageUrl: documentSnapshot.data()['imageURL'],boxFit: BoxFit.fill,shimmerBaseColor: Colors.grey,shimmerDuration: Duration(seconds: 1),)
////                                decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(allnews[index].url),fit: BoxFit.cover))),
//                            ))]),
//                ),
//
//                Column(
//                  children: [
//                    Center(
//                      child: Container(
//                          height:height*0.1,
//                          width:width*0.9,
//                          child: Text(documentSnapshot.data()['title'],maxLines:2,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: height*0.025))),
//                    ),
//                    Container(
//                        height:200,
//                        width:width*0.9,
//                        child: Text(allparas[0],maxLines: 7,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontSize: height*0.02))),
//
//                  ],
//                ),
//
//                InkWell(
//                  onTap: (){
//                    Navigator.push(context,MaterialPageRoute(builder: (context)=>NewsDetails(cat,documentSnapshot.id)));
//                  },
//                  child: Container(
//                    height:height*0.1,
//                    width:width,
//                    decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(documentSnapshot.data()['imageURL']),fit:BoxFit.fill)),
//                    child:ClipRRect(
//                      child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
//                        child: Container(
//                          height:height*0.1,
//                          width:width,
//                          decoration:BoxDecoration(color:Colors.black.withOpacity(0.6)),
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: [
//                              Container(
//                                  height:height*0.05,
//                                  width:width*0.9,
//                                  child: Padding(
//                                    padding: const EdgeInsets.all(8.0),
//                                    child: Text(documentSnapshot.data()['title'],maxLines:1,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.02)),
//                                  )),
//                              Padding(
//                                padding: const EdgeInsets.only(left:8.0),
//                                child: Text('Tap to read more...',overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.018)),
//                              )
//                            ],
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                )
//
//              ],
//            ),
//          );
//        },
//      )):(eng=='Sports')?Expanded(
//              child:PaginateFirestore(
//                scrollDirection: Axis.vertical,
//                shrinkWrap: true,
//                itemBuilderType:
//                PaginateBuilderType.listView,
//
//                query: FirebaseFirestore.instance.collection('NewsSchem1').where('category',isEqualTo: eng).orderBy('TimeStamp',descending: true),
//                itemBuilder: (index, context, documentSnapshot) {
//                  print(eng);
//                  allparas.clear();
//                  for(int j=0;j<documentSnapshot.data()['content'].length;j++){
////         print(i);
//                    Map<String,dynamic>map=documentSnapshot.data()['content'][j];
//                    if(map.keys.contains('para')){
////                print(map);
//                      allparas.add(documentSnapshot.data()['content'][j]['para']);
//                      break;
//
//                    }
//                  }
//                  return Container(
//                    height:height*0.9,
//                    width:width,
//                    child: Column(
//                      children: [
//                        Container(
//                          height:height*0.4,
//                          child: Stack(
//                              children: [
//                                Positioned(
//                                    top:height*0.02,
//                                    child:Container(
//                                      height:height*0.4,
//                                      width:width,
//                                      decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(documentSnapshot.data()['imageURL']),fit: BoxFit.cover)),
//                                      child:ClipRRect(
//
//                                        child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
//                                          child: Container(
//                                              height:height*0.4,
//                                              width:width,
//                                              decoration:BoxDecoration(color:Colors.white.withOpacity(0.0))
//                                          ),
//                                        ),
//                                      ),
//                                    )
//                                ),
//                                Positioned(
//                                    top:height*0.03,
//                                    left:width*0.025,
//                                    child:Container(
//                                        height:height*0.36,
//                                        width:width*0.95,
//                                        child:FancyShimmerImage(imageUrl: documentSnapshot.data()['imageURL'],boxFit: BoxFit.fill,shimmerBaseColor: Colors.grey,shimmerDuration: Duration(seconds: 1),)
////                                decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(allnews[index].url),fit: BoxFit.cover))),
//                                    ))]),
//                        ),
//
//                        Column(
//                          children: [
//                            Center(
//                              child: Container(
//                                  height:height*0.1,
//                                  width:width*0.9,
//                                  child: Text(documentSnapshot.data()['title'],maxLines:2,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: height*0.025))),
//                            ),
//                            Container(
//                                height:200,
//                                width:width*0.9,
//                                child: Text(allparas[0],maxLines: 7,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontSize: height*0.02))),
//
//                          ],
//                        ),
//
//                        InkWell(
//                          onTap: (){
//                            Navigator.push(context,MaterialPageRoute(builder: (context)=>NewsDetails(cat,documentSnapshot.id)));
//                          },
//                          child: Container(
//                            height:height*0.1,
//                            width:width,
//                            decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(documentSnapshot.data()['imageURL']),fit:BoxFit.fill)),
//                            child:ClipRRect(
//                              child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
//                                child: Container(
//                                  height:height*0.1,
//                                  width:width,
//                                  decoration:BoxDecoration(color:Colors.black.withOpacity(0.6)),
//                                  child: Column(
//                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    children: [
//                                      Container(
//                                          height:height*0.05,
//                                          width:width*0.9,
//                                          child: Padding(
//                                            padding: const EdgeInsets.all(8.0),
//                                            child: Text(documentSnapshot.data()['title'],maxLines:1,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.02)),
//                                          )),
//                                      Padding(
//                                        padding: const EdgeInsets.only(left:8.0),
//                                        child: Text('Tap to read more...',overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.018)),
//                                      )
//                                    ],
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ),
//                        )
//
//                      ],
//                    ),
//                  );
//                },
//              )):(eng=='Politics')?Expanded(
//              child:PaginateFirestore(
//                scrollDirection: Axis.vertical,
//                shrinkWrap: true,
//                itemBuilderType:
//                PaginateBuilderType.listView,
//
//                query: FirebaseFirestore.instance.collection('NewsSchem1').where('category',isEqualTo: eng).orderBy('TimeStamp',descending: true),
//                itemBuilder: (index, context, documentSnapshot) {
//                  print(eng);
//                  allparas.clear();
//                  for(int j=0;j<documentSnapshot.data()['content'].length;j++){
////         print(i);
//                    Map<String,dynamic>map=documentSnapshot.data()['content'][j];
//                    if(map.keys.contains('para')){
////                print(map);
//                      allparas.add(documentSnapshot.data()['content'][j]['para']);
//                      break;
//
//                    }
//                  }
//                  return Container(
//                    height:height*0.9,
//                    width:width,
//                    child: Column(
//                      children: [
//                        Container(
//                          height:height*0.4,
//                          child: Stack(
//                              children: [
//                                Positioned(
//                                    top:height*0.02,
//                                    child:Container(
//                                      height:height*0.4,
//                                      width:width,
//                                      decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(documentSnapshot.data()['imageURL']),fit: BoxFit.cover)),
//                                      child:ClipRRect(
//
//                                        child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
//                                          child: Container(
//                                              height:height*0.4,
//                                              width:width,
//                                              decoration:BoxDecoration(color:Colors.white.withOpacity(0.0))
//                                          ),
//                                        ),
//                                      ),
//                                    )
//                                ),
//                                Positioned(
//                                    top:height*0.03,
//                                    left:width*0.025,
//                                    child:Container(
//                                        height:height*0.36,
//                                        width:width*0.95,
//                                        child:FancyShimmerImage(imageUrl: documentSnapshot.data()['imageURL'],boxFit: BoxFit.fill,shimmerBaseColor: Colors.grey,shimmerDuration: Duration(seconds: 1),)
////                                decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(allnews[index].url),fit: BoxFit.cover))),
//                                    ))]),
//                        ),
//
//                        Column(
//                          children: [
//                            Center(
//                              child: Container(
//                                  height:height*0.1,
//                                  width:width*0.9,
//                                  child: Text(documentSnapshot.data()['title'],maxLines:2,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: height*0.025))),
//                            ),
//                            Container(
//                                height:200,
//                                width:width*0.9,
//                                child: Text(allparas[0],maxLines: 7,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontSize: height*0.02))),
//
//                          ],
//                        ),
//
//                        InkWell(
//                          onTap: (){
//                            Navigator.push(context,MaterialPageRoute(builder: (context)=>NewsDetails(cat,documentSnapshot.id)));
//                          },
//                          child: Container(
//                            height:height*0.1,
//                            width:width,
//                            decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(documentSnapshot.data()['imageURL']),fit:BoxFit.fill)),
//                            child:ClipRRect(
//                              child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
//                                child: Container(
//                                  height:height*0.1,
//                                  width:width,
//                                  decoration:BoxDecoration(color:Colors.black.withOpacity(0.6)),
//                                  child: Column(
//                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    children: [
//                                      Container(
//                                          height:height*0.05,
//                                          width:width*0.9,
//                                          child: Padding(
//                                            padding: const EdgeInsets.all(8.0),
//                                            child: Text(documentSnapshot.data()['title'],maxLines:1,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.02)),
//                                          )),
//                                      Padding(
//                                        padding: const EdgeInsets.only(left:8.0),
//                                        child: Text('Tap to read more...',overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.018)),
//                                      )
//                                    ],
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ),
//                        )
//
//                      ],
//                    ),
//                  );
//                },
//              )):(eng=='Business')?Expanded(
//              child:PaginateFirestore(
//                scrollDirection: Axis.vertical,
//                shrinkWrap: true,
//                itemBuilderType:
//                PaginateBuilderType.listView,
//
//                query: FirebaseFirestore.instance.collection('NewsSchem1').where('category',isEqualTo: eng).orderBy('TimeStamp',descending: true),
//                itemBuilder: (index, context, documentSnapshot) {
//                  print(eng);
//                  allparas.clear();
//                  for(int j=0;j<documentSnapshot.data()['content'].length;j++){
////         print(i);
//                    Map<String,dynamic>map=documentSnapshot.data()['content'][j];
//                    if(map.keys.contains('para')){
////                print(map);
//                      allparas.add(documentSnapshot.data()['content'][j]['para']);
//                      break;
//
//                    }
//                  }
//                  return Container(
//                    height:height*0.9,
//                    width:width,
//                    child: Column(
//                      children: [
//                        Container(
//                          height:height*0.4,
//                          child: Stack(
//                              children: [
//                                Positioned(
//                                    top:height*0.02,
//                                    child:Container(
//                                      height:height*0.4,
//                                      width:width,
//                                      decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(documentSnapshot.data()['imageURL']),fit: BoxFit.cover)),
//                                      child:ClipRRect(
//
//                                        child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
//                                          child: Container(
//                                              height:height*0.4,
//                                              width:width,
//                                              decoration:BoxDecoration(color:Colors.white.withOpacity(0.0))
//                                          ),
//                                        ),
//                                      ),
//                                    )
//                                ),
//                                Positioned(
//                                    top:height*0.03,
//                                    left:width*0.025,
//                                    child:Container(
//                                        height:height*0.36,
//                                        width:width*0.95,
//                                        child:FancyShimmerImage(imageUrl: documentSnapshot.data()['imageURL'],boxFit: BoxFit.fill,shimmerBaseColor: Colors.grey,shimmerDuration: Duration(seconds: 1),)
////                                decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(allnews[index].url),fit: BoxFit.cover))),
//                                    ))]),
//                        ),
//
//                        Column(
//                          children: [
//                            Center(
//                              child: Container(
//                                  height:height*0.1,
//                                  width:width*0.9,
//                                  child: Text(documentSnapshot.data()['title'],maxLines:2,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: height*0.025))),
//                            ),
//                            Container(
//                                height:200,
//                                width:width*0.9,
//                                child: Text(allparas[0],maxLines: 7,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(fontSize: height*0.02))),
//
//                          ],
//                        ),
//
//                        InkWell(
//                          onTap: (){
//                            Navigator.push(context,MaterialPageRoute(builder: (context)=>NewsDetails(cat,documentSnapshot.id)));
//                          },
//                          child: Container(
//                            height:height*0.1,
//                            width:width,
//                            decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(documentSnapshot.data()['imageURL']),fit:BoxFit.fill)),
//                            child:ClipRRect(
//                              child: BackdropFilter(filter: ImageFilter.blur(sigmaX:8.0,sigmaY: 8.0),
//                                child: Container(
//                                  height:height*0.1,
//                                  width:width,
//                                  decoration:BoxDecoration(color:Colors.black.withOpacity(0.6)),
//                                  child: Column(
//                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    children: [
//                                      Container(
//                                          height:height*0.05,
//                                          width:width*0.9,
//                                          child: Padding(
//                                            padding: const EdgeInsets.all(8.0),
//                                            child: Text(documentSnapshot.data()['title'],maxLines:1,overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.02)),
//                                          )),
//                                      Padding(
//                                        padding: const EdgeInsets.only(left:8.0),
//                                        child: Text('Tap to read more...',overflow: TextOverflow.ellipsis,style:GoogleFonts.poppins(color:Colors.white,fontSize: height*0.018)),
//                                      )
//                                    ],
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ),
//                        )
//
//                      ],
//                    ),
//                  );
//                },
//              )):Container()
            )],
        ),
      )
    );
  }
}
