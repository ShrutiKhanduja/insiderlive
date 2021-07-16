import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insiderLive/Constants/ads.dart';
import 'package:insiderLive/Constants/categories.dart';
import 'package:insiderLive/Constants/colors.dart';
import 'package:insiderLive/Constants/controller.dart';
import 'package:insiderLive/Constants/data.dart';
import 'package:insiderLive/news_details.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Data> allnews = [];
  List<String> allparas = [];
  List<Categories> allcats = [];
  List<Ads> ads = [];
  int check = 0;
  void cats() async {
    allcats.clear();
    allcats.add(Categories('', 'Top', '', ''));
    allcats.add(Categories('', 'Trending', '', ''));
    allcats.add(Categories('', 'Breaking-news', '', ''));
    await FirebaseFirestore.instance
        .collection('Category')
        .orderBy('position')
        .snapshots()
        .listen((event) {
      allcats.add(Categories('', 'Insider Special', '', ''));
      for (int i = 0; i < event.docs.length; i++) {
        if (event.docs[i]['Title'] != 'Insider Special') {
          setState(() {
            Categories cat = Categories(
                event.docs[i]['ImageURL'],
                event.docs[i]['Title'],
                event.docs[i]['hindiTitle'],
                event.docs[i]['position'].toString());
            allcats.add(cat);
          });
        }
      }

      print(allcats.length);
      pref();
    });
    ads.clear();
    await FirebaseFirestore.instance
        .collection('Headerads')
        .snapshots()
        .listen((event) {
      for (int i = 0; i < event.docs.length; i++) {
        setState(() {
          ads.add(Ads(event.docs[i].data()['ImageURL'],
              event.docs[i].data()['Link'], event.docs[i].data()['author']));
        });
      }
      print(ads.length);
    });
  }

  final translator = GoogleTranslator();
  void data(String category) async {
    allnews.clear();
    if (category == 'Trending') {
      FirebaseFirestore.instance
          .collection('HomePage')
          .doc(category)
          .snapshots()
          .listen((event) async {
//       print(i);
//          print( event.docs[i].id,);
        for (int i = 0; i < event['TrendingNews'].length; i++) {
          if (event['TrendingNews'][i]['content'].runtimeType.toString() ==
              'String') {
            setState(() {
              allnews.add(Data(
                event['TrendingNews'][i]['imageURL'],
                null,
                event['TrendingNews'][i]['content'],
                event['TrendingNews'][i]['title'],
                i.toString(),
                event['TrendingNews'][i]['description'],
              ));
            });
          } else {
            setState(() {
              allnews.add(Data(
                  event['TrendingNews'][i]['imageURL'],
                  event['TrendingNews'][i]['content'],
                  null,
                  event['TrendingNews'][i]['title'],
                  i.toString(),
                  event['TrendingNews'][i]['description']));
            });
          }
          if (!(event['TrendingNews'][i]['content'].runtimeType.toString() ==
              'String'))
            for (int j = 0;
                j < event['TrendingNews'][i]['content'].length;
                j++) {
//         print(i);
              Map<String, dynamic> map = event['TrendingNews'][i]['content'][j];
              if (map.keys.contains('para')) {
//                print(map);
                allparas.add(
                    event['TrendingNews'][i]['content'][j]['para'].toString());
                break;
              }
            }
          else
            allparas.add(event['TrendingNews'][i]['content'].toString());
        }

//print('Allnews:${allnews.length}');
//     print('Allparas:${allparas.length}');
      });
    }
    if (category == 'Top' || category == 'Breaking-news') {
      FirebaseFirestore.instance
          .collection('HomePage')
          .doc(category)
          .snapshots()
          .listen((event) async {
//       print(i);
//          print( event.docs[i].id,);

        for (int i = 0; i < event['Topnews'].length; i++) {
          if (event['Topnews'][i]['content'].runtimeType.toString() ==
              'String') {
            setState(() {
              allnews.add(Data(
                  event['Topnews'][i]['imageURL'],
                  null,
                  event['Topnews'][i]['content'],
                  event['Topnews'][i]['title'],
                  i.toString(),
                  event['Topnews'][i]['description']));
            });
          } else {
            setState(() {
              allnews.add(Data(
                  event['Topnews'][i]['imageURL'],
                  event['Topnews'][i]['content'],
                  null,
                  event['Topnews'][i]['title'],
                  i.toString(),
                  event['Topnews'][i]['description']));
            });
          }
          if (!(event['Topnews'][i]['content'].runtimeType.toString() ==
              'String'))
            for (int j = 0; j < event['Topnews'][i]['content'].length; j++) {
//         print(i);
              Map<String, dynamic> map = event['Topnews'][i]['content'][j];
              if (map.keys.contains('para')) {
//                print(map);
                allparas
                    .add(event['Topnews'][i]['content'][j]['para'].toString());
                break;
              }
            }
          else
            allparas.add(event['Topnews'][i]['content'].toString());
        }

//print('Allnews:${allnews.length}');
//     print('Allparas:${allparas.length}');
      });
    }
    FirebaseFirestore.instance
        .collection('NewsSchem1')
        .where('category', isEqualTo: category)
        .orderBy('TimeStamp', descending: true)
        .snapshots()
        .listen((event) async {
      for (int i = 0; i < event.docs.length; i++) {
//       print(i);
//          print( event.docs[i].id,);
        if (event.docs[i]['content'].runtimeType.toString() == 'String') {
          setState(() {
            allnews.add(Data(
                event.docs[i]['imageURL'],
                null,
                event.docs[i]['content'],
                event.docs[i]['title'],
                event.docs[i].id,
                event.docs[i]['description']));
          });
        } else {
          setState(() {
            allnews.add(Data(
                event.docs[i]['imageURL'],
                event.docs[i]['content'],
                null,
                event.docs[i]['title'],
                event.docs[i].id,
                event.docs[i]['description']));
          });
        }
        if (!(event.docs[i]['content'].runtimeType.toString() == 'String'))
          for (int j = 0; j < event.docs[i]['content'].length; j++) {
//         print(i);
            Map<String, dynamic> map = event.docs[i]['content'][j];
            if (map.keys.contains('para')) {
//                print(map);
              allparas.add(event.docs[i]['content'][j]['para'].toString());
              break;
            }
          }
        else
          allparas.add(event.docs[i]['content'].toString());
      }
//print('Allnews:${allnews.length}');
//     print('Allparas:${allparas.length}');
    });
  }

  String cat;
  String eng;
  void pref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cat = prefs.getString('cat');
      eng = prefs.getString('eng');
    });

    for (int i = 0; i < allcats.length; i++) {
      if (eng == allcats[i].title) {
        category = i;
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
  bool isSwitched = false;
  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: isSwitched == false
              ? InkWell(
                  onTap: () {
                    Controller.cont.jumpToPage(0);
                  },
                  child: Icon(Icons.remove_red_eye, color: Colors.white))
              : null,
          title: (cat != null)
              ? isSwitched == false
                  ? Text(cat,
                      textAlign: TextAlign.center, style: GoogleFonts.mukta())
                  : Container()
              : Container(),
          actions: [
            Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                  print(isSwitched);
                });
              },
              activeTrackColor: Colors.yellow,
              activeColor: Colors.orangeAccent,
            ),
          ],
          backgroundColor: primarycolor,
          centerTitle: true,
        ),
        body: Container(
            height: height,
            width: width,
            child: isSwitched == false
                ? Column(
                    children: [
                      Container(
                        height: 40,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: allcats.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    category = index;
                                    print(category);
                                    if (allcats[index].title == 'Trending' ||
                                        allcats[index].title == 'Top' ||
                                        allcats[index].title ==
                                            'Breaking-news') {
                                      eng = allcats[index].title;
                                    } else {
                                      (allcats[index].title !=
                                              'Insider Special')
                                          ? eng = allcats[index].hindititle
                                          : eng = 'Insider Special';
                                      cat = allcats[index].hindititle;
                                      eng = allcats[index].title;
                                    }

                                    data(allcats[index].title);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      allcats[index].title.toUpperCase(),
                                      style: GoogleFonts.mukta(
                                          color: (index == category)
                                              ? primarycolor
                                              : Colors.grey,
                                          fontSize: height * 0.02)),
                                ),
                              );
                            }),
                      ),
                      Expanded(
                        child: (allnews.length != 0 && allparas.length != 0)
                            ? PageView.builder(
                                itemCount: allnews.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: height * 0.9,
                                    width: width,
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewsDetails(
                                                            cat,
                                                            allnews[index]
                                                                .id)));
                                          },
                                          child: Container(
                                            height: height * 0.34,
                                            child: Stack(children: [
                                              Positioned(
                                                  top: height * 0.02,
                                                  child: Container(
                                                    height: height * 0.4,
                                                    width: width,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                allnews[index]
                                                                    .url),
                                                            fit: BoxFit.cover)),
                                                    child: ClipRRect(
                                                      child: BackdropFilter(
                                                        filter:
                                                            ImageFilter.blur(
                                                                sigmaX: 8.0,
                                                                sigmaY: 8.0),
                                                        child: Container(
                                                            height:
                                                                height * 0.4,
                                                            width: width,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.0))),
                                                      ),
                                                    ),
                                                  )),
                                              Positioned(
                                                  top: height * 0.03,
                                                  left: width * 0.025,
                                                  child: Container(
                                                      height: height * 0.3,
                                                      width: width * 0.95,
                                                      child: FancyShimmerImage(
                                                        imageUrl:
                                                            allnews[index].url,
                                                        boxFit: BoxFit.fill,
                                                        shimmerBaseColor:
                                                            Colors.grey,
                                                        shimmerDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    500),
                                                      )
//                                decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(allnews[index].url),fit: BoxFit.cover))),
                                                      ))
                                            ]),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              NewsDetails(
                                                                  cat,
                                                                  allnews[index]
                                                                      .id)));
                                                },
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Container(
                                                        width: width * 0.9,
                                                        child: Text(
                                                            allnews[index]
                                                                .title, //test
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts.mukta(
                                                                height: 1.25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    height *
                                                                        0.02))),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              (allparas[index] != null &&
                                                      allparas[index] != '')
                                                  ? allparas[index]
                                                          .contains('<p>')
                                                      ? InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        NewsDetails(
                                                                            cat,
                                                                            allnews[index].id)));
                                                          },
                                                          child: Container(
                                                              width:
                                                                  width * 0.9,
                                                              child: allnews[index]
                                                                          .description !=
                                                                      null
                                                                  ? Text(
                                                                      allnews[index]
                                                                          .description, //test
                                                                      maxLines:
                                                                          5,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: GoogleFonts.mukta(
                                                                          height:
                                                                              1.25,
                                                                          fontSize:
                                                                              height * 0.02))
                                                                  : Container()),
                                                          //                                           Container(
                                                          //                                             width: width * 0.9,
                                                          //                                             height:
                                                          //                                                 height * 0.2,
                                                          //                                             child: Html(
                                                          //                                               data:
                                                          //                                                   """${allparas[index]}
                                                          // """,
                                                          //                                               padding:
                                                          //                                                   EdgeInsets
                                                          //                                                       .all(8.0),
                                                          //                                               onLinkTap: (url) {
                                                          //                                                 print(
                                                          //                                                     "Opening $url...");
                                                          //                                               },
                                                          //                                               // customRender: (node,
                                                          //                                               //     children) {
                                                          //                                               //   if (node is dom
                                                          //                                               //       .Element) {
                                                          //                                               //     switch (node
                                                          //                                               //         .localName) {
                                                          //                                               //       case "custom_tag": // using this, you can handle custom tags in your HTML
                                                          //                                               //         return Column(
                                                          //                                               //             children:
                                                          //                                               //                 children);
                                                          //                                               //     }
                                                          //                                               //   }
                                                          //                                               // },
                                                          //                                             ),
                                                          //                                           ),
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        NewsDetails(
                                                                            cat,
                                                                            allnews[index].id)));
                                                          },
                                                          child: Container(
                                                              width:
                                                                  width * 0.9,
                                                              child: Text(
                                                                  allparas[
                                                                      index],
                                                                  maxLines:
                                                                      index % 5 ==
                                                                              0
                                                                          ? 6
                                                                          : 7,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: GoogleFonts.mukta(
                                                                      fontSize:
                                                                          height *
                                                                              0.017))),
                                                        )
                                                  : Container(
                                                      height: 100,
                                                      width: 100,
                                                      child: SpinKitWave(
                                                          color: primarycolor,
                                                          size: height * 0.023),
                                                    )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            launch(index % 3 == 0
                                                ? ads[0].Link
                                                : index % 2 == 0
                                                    ? ads[1].Link
                                                    : ads[2].Link);
                                          },
                                          child: Container(
                                            height: 100,
                                            width: width,
                                            child: FancyShimmerImage(
                                              imageUrl: index % 3 == 0
                                                  ? ads[0].ImageURL
                                                  : index % 2 == 0
                                                      ? ads[1].ImageURL
                                                      : ads[2].ImageURL,
                                              boxFit: BoxFit.fill,
                                              shimmerBaseColor: Colors.grey,
                                              shimmerDuration:
                                                  Duration(seconds: 1),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewsDetails(
                                                            cat,
                                                            allnews[index]
                                                                .id)));
                                          },
                                          child: Container(
                                            height: 70,
                                            width: width,
                                            decoration: BoxDecoration(
                                                color: Colors.black),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                      allnews[index].title,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.mukta(
                                                          color: Colors.white,
                                                          fontSize: 13)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0, bottom: 5),
                                                  child: Text(
                                                      'Tap to read more...',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.mukta(
                                                          color: Colors.white,
                                                          fontSize: 13)),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                })
                            : Container(
                                height: 100,
                                width: 100,
                                child: SpinKitWave(
                                    color: primarycolor, size: height * 0.023)),
                      )
                    ],
                  )
                : Column(children: [
                    Expanded(
                        child: WebView(
                      key: _key,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: 'https://insiderlive.in',
                      gestureRecognizers: {
                        Factory<PlatformViewVerticalGestureRecognizer>(
                          () => PlatformViewVerticalGestureRecognizer()
                            ..onUpdate = (_) {},
                        ),
                      },
                    ))
                  ])));
  }
}

class PlatformViewVerticalGestureRecognizer
    extends VerticalDragGestureRecognizer {
  PlatformViewVerticalGestureRecognizer({PointerDeviceKind kind})
      : super(kind: kind);

  Offset _dragDistance = Offset.zero;

  @override
  void addPointer(PointerEvent event) {
    startTrackingPointer(event.pointer);
  }

  @override
  void handleEvent(PointerEvent event) {
    _dragDistance = _dragDistance + event.delta;
    if (event is PointerMoveEvent) {
      final double dy = _dragDistance.dy.abs();
      final double dx = _dragDistance.dx.abs();

      if (dy > dx && dy > kTouchSlop) {
        // vertical drag - accept
        resolve(GestureDisposition.accepted);
        _dragDistance = Offset.zero;
      } else if (dx > kTouchSlop && dx > dy) {
        resolve(GestureDisposition.accepted);
        // horizontal drag - stop tracking
        stopTrackingPointer(event.pointer);
        _dragDistance = Offset.zero;
      }
    }
  }

  @override
  String get debugDescription => 'horizontal drag (platform view)';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}
