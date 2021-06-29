import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insiderLive/Constants/ads.dart';
import 'package:insiderLive/Constants/colors.dart';
import 'package:insiderLive/Constants/data.dart';
import 'package:intl/intl.dart';
import 'package:social_share/social_share.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetails extends StatefulWidget {
  String cat;
  String docid;
  NewsDetails(this.cat, this.docid);
  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  List<Data> allnews = [];
  List<Widget> allwidgets = [];
  final translator = GoogleTranslator();
  Ads adURL;
  void get() async {
    allnews.clear();
    await FirebaseFirestore.instance
        .collection('Ads')
        .snapshots()
        .listen((event) {
      for (int i = 0; i < event.docs.length; i++) {
        var doc = event.docs.where((element) => element.id == 'NewsAd');
        setState(() {
          adURL = Ads(doc.first.data()['ImageURL'], doc.first.data()['Link'],
              doc.first.data()['author']);
        });
      }
    });
    if (widget.cat == 'Top' || widget.cat == 'Breaking-news') {
      FirebaseFirestore.instance
          .collection('HomePage')
          .doc(widget.cat)
          .snapshots()
          .listen((event) async {
        Map map = event.data();

        DateTime date =
            map['Topnews'][int.parse(widget.docid)]['TimeStamp'].toDate();

        print(DateFormat.yMMMd().add_jm().format(date));

        setState(() {
          allwidgets.add(
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Stack(
                    children: [
                      Positioned(
                          top: MediaQuery.of(context).size.height * 0.02,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(map['Topnews']
                                        [int.parse(widget.docid)]['imageURL']),
                                    fit: BoxFit.cover)),
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.0))),
                              ),
                            ),
                          )),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.03,
                        left: MediaQuery.of(context).size.width * 0.025,
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.36,
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(map['Topnews']
                                        [int.parse(widget.docid)]['imageURL']),
                                    fit: BoxFit.cover))),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(DateFormat.yMMMd().add_jm().format(date),
                          style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.018))),
                ),
                map['Topnews'][int.parse(widget.docid)]['coveredBy'] != '' &&
                        map['Topnews'][int.parse(widget.docid)]['coveredBy'] !=
                            null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                'Covered by : ${map['Topnews'][int.parse(widget.docid)]['coveredBy']}',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.018))),
                      )
                    : Container()
              ],
            ),
          );
          allwidgets.add(
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, bottom: 8.0, top: 8.0),
                child: Text(
                    map['Topnews'][int.parse(widget.docid)]['title'].toString(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * 0.025)),
              ),
            ),
          );
          allwidgets.add(Center(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Text(
                    map['Topnews'][int.parse(widget.docid)]['description']
                        .toString(),
                    style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.height * 0.02))),
          ));
          allwidgets.add(SizedBox(height: 10));
        });
        for (int i = 0;
            i < map['Topnews'][int.parse(widget.docid)]['content'].length;
            i++) {
          Map map2 = map['Topnews'][int.parse(widget.docid)]['content'][i];
          if (map2.keys.contains('para')) {
            setState(() {
              allwidgets.add(Center(
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Text(
                        map2.values
                            .toString()
                            .replaceAll('(', '')
                            .replaceAll(')', '')
                            .toString(),
                        style: GoogleFonts.poppins(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.02))),
              ));
              allwidgets.add(SizedBox(height: 10));
            });
          } else if (map2.keys.contains('head')) {
            setState(() {
              allwidgets.add(Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Text(
                      map2.values
                          .toString()
                          .replaceAll('(', '')
                          .replaceAll(')', '')
                          .toString(),
                      style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.height * 0.024,
                          fontWeight: FontWeight.w600))));
              allwidgets.add(SizedBox(height: 10));
            });
          } else if (map2.keys.contains('image')) {
            print(map2.values.contains(false));
            print('Image:${map2.values.toString()}');
            setState(() {
              allwidgets.add(Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Stack(
                  children: [
                    Positioned(
                        top: MediaQuery.of(context).size.height * 0.02,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(map2.values
                                          .contains(false)
                                      ? map2.values.toString().substring(8)
                                      : (map2.values.toString().substring(1))),
                                  fit: BoxFit.cover)),
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.0))),
                            ),
                          ),
                        )),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.03,
                      left: MediaQuery.of(context).size.width * 0.025,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.36,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: FancyShimmerImage(
                          imageUrl: map2.values.contains(false)
                              ? map2.values.toString().substring(8)
                              : (map2.values.toString().substring(1)),
                          boxFit: BoxFit.fill,
                          shimmerBaseColor: Colors.grey,
                          shimmerDuration: Duration(seconds: 1),
                        ),
//                        decoration: BoxDecoration(image: DecorationImage(
//                            image: NetworkImage(
//                                map2.values.contains(false)?map2.values.toString().substring(8):(map2.values.toString().substring(1))), fit: BoxFit.cover)
                      ),
                    ),
                  ],
                ),
              ));
              allwidgets.add(SizedBox(height: 10));
            });
          }
        }
        allwidgets.add(InkWell(
          onTap: () {
            launch(adURL.Link);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: FancyShimmerImage(
                  imageUrl: adURL.ImageURL,
                  boxFit: BoxFit.fill,
                  shimmerBaseColor: Colors.grey,
                  shimmerDuration: Duration(seconds: 1),
                )),
          ),
        ));
        if (map['Topnews'][int.parse(widget.docid)]['content']
                .runtimeType
                .toString() ==
            'String') {
          setState(() {
            allnews.add(Data(
                map['Topnews'][int.parse(widget.docid)]['imageURL'],
                null,
                map['Topnews'][int.parse(widget.docid)]['content'],
                map['Topnews'][int.parse(widget.docid)]['title'],
                event.id));
          });
        } else {
          setState(() {
            allnews.add(Data(
                map['Topnews'][int.parse(widget.docid)]['imageURL'],
                map['Topnews'][int.parse(widget.docid)]['content'],
                null,
                map['Topnews'][int.parse(widget.docid)]['title'],
                event.id));
          });
        }
      });
    } else if (widget.cat == 'Trending') {
      FirebaseFirestore.instance
          .collection('HomePage')
          .doc(widget.cat)
          .snapshots()
          .listen((event) async {
        Map map = event.data();
        DateTime date =
            map['TrendingNews'][int.parse(widget.docid)]['TimeStamp'].toDate();

        print(DateFormat.yMMMd().add_jm().format(date));

        setState(() {
          allwidgets.add(
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Stack(
                    children: [
                      Positioned(
                          top: MediaQuery.of(context).size.height * 0.02,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(map['TrendingNews']
                                        [int.parse(widget.docid)]['imageURL']),
                                    fit: BoxFit.cover)),
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.0))),
                              ),
                            ),
                          )),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.03,
                        left: MediaQuery.of(context).size.width * 0.025,
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.36,
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(map['TrendingNews']
                                        [int.parse(widget.docid)]['imageURL']),
                                    fit: BoxFit.cover))),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(DateFormat.yMMMd().add_jm().format(date),
                          style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.018))),
                ),
                map['TrendingNews'][int.parse(widget.docid)]['coveredBy'] !=
                            '' &&
                        map['TrendingNews'][int.parse(widget.docid)]
                                ['coveredBy'] !=
                            null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                'Covered by : ${map['TrendingNews'][int.parse(widget.docid)]['coveredBy']}',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.018))),
                      )
                    : Container()
              ],
            ),
          );
          allwidgets.add(
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, bottom: 8.0, top: 8.0),
                child: Text(
                    map['TrendingNews'][int.parse(widget.docid)]['title']
                        .toString(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * 0.025)),
              ),
            ),
          );
          allwidgets.add(Center(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Text(
                    map['TrendingNews'][int.parse(widget.docid)]['description']
                        .toString(),
                    style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.height * 0.02))),
          ));
          allwidgets.add(SizedBox(height: 10));
        });
        for (int i = 0;
            i < map['TrendingNews'][int.parse(widget.docid)]['content'].length;
            i++) {
          Map map2 = map['TrendingNews'][int.parse(widget.docid)]['content'][i];
          if (map2.keys.contains('para')) {
            setState(() {
              allwidgets.add(Center(
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Text(
                        map2.values
                            .toString()
                            .replaceAll('(', '')
                            .replaceAll(')', '')
                            .toString(),
                        style: GoogleFonts.poppins(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.02))),
              ));
              allwidgets.add(SizedBox(height: 10));
            });
          } else if (map2.keys.contains('head')) {
            setState(() {
              allwidgets.add(Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Text(
                      map2.values
                          .toString()
                          .replaceAll('(', '')
                          .replaceAll(')', '')
                          .toString(),
                      style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.height * 0.024,
                          fontWeight: FontWeight.w600))));
              allwidgets.add(SizedBox(height: 10));
            });
          } else if (map2.keys.contains('image')) {
            print(map2.values.contains(false));
            print('Image:${map2.values.toString()}');
            setState(() {
              allwidgets.add(Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Stack(
                  children: [
                    Positioned(
                        top: MediaQuery.of(context).size.height * 0.02,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(map2.values
                                          .contains(false)
                                      ? map2.values.toString().substring(8)
                                      : (map2.values.toString().substring(1))),
                                  fit: BoxFit.cover)),
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.0))),
                            ),
                          ),
                        )),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.03,
                      left: MediaQuery.of(context).size.width * 0.025,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.36,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: FancyShimmerImage(
                          imageUrl: map2.values.contains(false)
                              ? map2.values.toString().substring(8)
                              : (map2.values.toString().substring(1)),
                          boxFit: BoxFit.fill,
                          shimmerBaseColor: Colors.grey,
                          shimmerDuration: Duration(seconds: 1),
                        ),
//                        decoration: BoxDecoration(image: DecorationImage(
//                            image: NetworkImage(
//                                map2.values.contains(false)?map2.values.toString().substring(8):(map2.values.toString().substring(1))), fit: BoxFit.cover)
                      ),
                    ),
                  ],
                ),
              ));
              allwidgets.add(SizedBox(height: 10));
            });
          }
        }
        allwidgets.add(InkWell(
          onTap: () {
            launch(adURL.Link);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: FancyShimmerImage(
                  imageUrl: adURL.ImageURL,
                  boxFit: BoxFit.fill,
                  shimmerBaseColor: Colors.grey,
                  shimmerDuration: Duration(seconds: 1),
                )),
          ),
        ));
        if (map['TrendingNews'][int.parse(widget.docid)]['content']
                .runtimeType
                .toString() ==
            'String') {
          setState(() {
            allnews.add(Data(
                map['TrendingNews'][int.parse(widget.docid)]['imageURL'],
                null,
                map['TrendingNews'][int.parse(widget.docid)]['content'],
                map['TrendingNews'][int.parse(widget.docid)]['title'],
                event.id));
          });
        } else {
          setState(() {
            allnews.add(Data(
                map['TrendingNews'][int.parse(widget.docid)]['imageURL'],
                map['TrendingNews'][int.parse(widget.docid)]['content'],
                null,
                map['TrendingNews'][int.parse(widget.docid)]['title'],
                event.id));
          });
        }
      });
    } else {
      FirebaseFirestore.instance
          .collection('NewsSchem1')
          .doc(widget.docid)
          .snapshots()
          .listen((event) async {
        Map map = event.data();
        DateTime date = map['TimeStamp'].toDate();

        print(DateFormat.yMMMd().add_jm().format(date));

        setState(() {
          allwidgets.add(
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Stack(
                    children: [
                      Positioned(
                          top: MediaQuery.of(context).size.height * 0.02,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(map['imageURL']),
                                    fit: BoxFit.cover)),
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.0))),
                              ),
                            ),
                          )),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.03,
                        left: MediaQuery.of(context).size.width * 0.025,
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.36,
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(map['imageURL']),
                                    fit: BoxFit.cover))),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(DateFormat.yMMMd().add_jm().format(date),
                          style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.018))),
                ),
                map['coveredBy'] != '' && map['coveredBy'] != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text('Covered by : ${map['coveredBy']}',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.018))),
                      )
                    : Container()
              ],
            ),
          );
          allwidgets.add(
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, bottom: 8.0, top: 8.0),
                child: Text(map['title'].toString(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * 0.025)),
              ),
            ),
          );
          allwidgets.add(Center(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Text(map['description'].toString(),
                    style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.height * 0.02))),
          ));
          allwidgets.add(SizedBox(height: 10));
        });
        for (int i = 0; i < map['content'].length; i++) {
          Map map2 = map['content'][i];
          if (map2.keys.contains('para')) {
            setState(() {
              allwidgets.add(Center(
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Text(
                        map2.values
                            .toString()
                            .replaceAll('(', '')
                            .replaceAll(')', '')
                            .toString(),
                        style: GoogleFonts.poppins(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.02))),
              ));
              allwidgets.add(SizedBox(height: 10));
            });
          } else if (map2.keys.contains('head')) {
            setState(() {
              allwidgets.add(Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Text(
                      map2.values
                          .toString()
                          .replaceAll('(', '')
                          .replaceAll(')', '')
                          .toString(),
                      style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.height * 0.024,
                          fontWeight: FontWeight.w600))));
              allwidgets.add(SizedBox(height: 10));
            });
          } else if (map2.keys.contains('image')) {
            print(map2.values.contains(false));
            print('Image:${map2.values.toString()}');
            setState(() {
              allwidgets.add(Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Stack(
                  children: [
                    Positioned(
                        top: MediaQuery.of(context).size.height * 0.02,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(map2.values
                                          .contains(false)
                                      ? map2.values.toString().substring(8)
                                      : (map2.values.toString().substring(1))),
                                  fit: BoxFit.cover)),
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.0))),
                            ),
                          ),
                        )),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.03,
                      left: MediaQuery.of(context).size.width * 0.025,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.36,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: FancyShimmerImage(
                          imageUrl: map2.values.contains(false)
                              ? map2.values.toString().substring(8)
                              : (map2.values.toString().substring(1)),
                          boxFit: BoxFit.fill,
                          shimmerBaseColor: Colors.grey,
                          shimmerDuration: Duration(seconds: 1),
                        ),
//                        decoration: BoxDecoration(image: DecorationImage(
//                            image: NetworkImage(
//                                map2.values.contains(false)?map2.values.toString().substring(8):(map2.values.toString().substring(1))), fit: BoxFit.cover)
                      ),
                    ),
                  ],
                ),
              ));
              allwidgets.add(SizedBox(height: 10));
            });
          }
        }
        allwidgets.add(InkWell(
          onTap: () {
            launch(adURL.Link);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: FancyShimmerImage(
                  imageUrl: adURL.ImageURL,
                  boxFit: BoxFit.fill,
                  shimmerBaseColor: Colors.grey,
                  shimmerDuration: Duration(seconds: 1),
                )),
          ),
        ));
        if (map['content'].runtimeType.toString() == 'String') {
          setState(() {
            allnews.add(Data(
                map['imageURL'], null, map['content'], map['title'], event.id));
          });
        } else {
          setState(() {
            allnews.add(Data(
                map['imageURL'], map['content'], null, map['title'], event.id));
          });
        }
      });
    }
  }

  @override
  void initState() {
    get();
    super.initState();
  }

  int j = 0;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: (widget.cat != null)
              ? Text(widget.cat, style: GoogleFonts.poppins())
              : Container(),
          backgroundColor: primarycolor,
          centerTitle: true,
          actions: [
            Center(
                child: InkWell(
                    onTap: () {}, child: FaIcon(FontAwesomeIcons.facebook))),
            SizedBox(width: 7),
            Center(
                child: InkWell(
                    onTap: () {
                      SocialShare.shareWhatsapp(
                          'https://insiderlive.in/news/${widget.docid}/${widget.cat}');
                    },
                    child: FaIcon(FontAwesomeIcons.whatsapp))),
            SizedBox(width: 7),

            InkWell(
                onTap: () {
                  SocialShare.shareTwitter(
                      'https://insiderlive.in/news/${widget.docid}/${widget.cat}');
                },
                child: Center(child: FaIcon(FontAwesomeIcons.twitter))),
            SizedBox(width: 7),
//          Image.asset('assets/facebook.png',scale:3.2),
//          Image.asset('assets/whatsapp.png',scale:3.2),
//          Image.asset('assets/twitter.png',scale:3.2),
          ],
        ),
        body: SingleChildScrollView(child: Column(children: allwidgets)));
  }
}
