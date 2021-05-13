import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insiderLive/Constants/colors.dart';
import 'package:insiderLive/Constants/datamodel.dart';
import 'package:insiderLive/news_details.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController _cont = TextEditingController();
  List<DataModel> dogList1 = [];
  List<Widget> dogCardsList1 = [];
  List<DocumentSnapshot> docList = [];
  List<DataModel> dogList = [];
  double width, height;
  List<Widget> dogCardsList = [];
  @override
  void initState() {
//    getData1();
    getData();

    super.initState();
  }
//  void getData1() async {
//    dogCardsList1.clear();
//    dogList1.clear();
//    print('started loading');
//    await FirebaseFirestore.instance
//        .collection("NewsSchem1").limit(10)
//        .get()
//        .then((QuerySnapshot snapshot) {
//      snapshot.docs.forEach((f) async {
//        DataModel dp = DataModel(
//            timestamp: f['TimeStamp'],
//            author: f['author'],
//            category: f['category'],
//            content: List.from(f['content']),
//            coveredBy: f['coveredBy'],
//            description: f['description'],
//            imageCaption: f['imageCaption'],
//            imageURL: f['imageURL'],
//            live: f['live'],
//            route: f['route'],
//            seotag: List.from(f['seotag']),
//            tags: List.from(f['tags']),
//            title:f['title']);
//
//        await dogList1.add(dp);
//        // await dogCardsList1.add(MyDogCard(dp, width, height));
//        print('Dog added');
////        print(f['imageLinks'].toString());
//      });
//    });
//    setState(() {
//      print(dogList1.length.toString());
//      print(dogCardsList1.length.toString());
//    });
//  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:
        EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
        child: SingleChildScrollView(
          child: Column(children: [
            TextFormField(
              controller: _cont,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search news',
                  focusColor: primarycolor),
              onChanged: (String query) {
                getCaseDetails(query);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: height * 0.85,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: dogList.length,
                  itemBuilder: (BuildContext, index) {
                    var item = dogList[index];
                    return InkWell(
                      onTap: () async {
                        Navigator.push(context,MaterialPageRoute(builder:(context)=>NewsDetails(dogList[index].category, dogList[index].id)));
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => ProductDetailsScreen(
//                                    item.docid,
//                                    item.imageurls[0],
//                                    item.name,
//                                    item.mp,
//                                    item.disprice,
//                                    item.description,
//                                    item.details,
//                                    item.detailsurls,
//                                    item.rating,
//                                    item.specs,
//                                    item.quantity,
//                                    MediaQuery.of(context).size.height,
//                                    MediaQuery.of(context).size.width,
//                                    item.varientId)));
                        // _scaffoldKey.currentState.showBottomSheet((context) {
                        //   return StatefulBuilder(
                        //       builder: (context, StateSetter state) {
                        //     return ProfilePullUp(item, width, height);
                        //   });
                        // });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: width * 0.8,
                          child: Row(
                            children: <Widget>[
                              // Container(
                              //   height: 50,
                              //   width: 50,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.all(
                              //       Radius.circular(25),
                              //     ),
                              //   ),
                              //   child: ClipRRect(
                              //     borderRadius: BorderRadius.circular(25.0),
                              //     child: CachedNetworkImage(
                              //       height: 50,
                              //       width: 50,
                              //       imageUrl: item.url,
                              //       imageBuilder: (context, imageProvider) =>
                              //           Container(
                              //         decoration: BoxDecoration(
                              //           image: DecorationImage(
                              //               image: imageProvider,
                              //               fit: BoxFit.fill),
                              //         ),
                              //       ),
                              //       placeholder: (context, url) => GFLoader(
                              //         type: GFLoaderType.ios,
                              //       ),
                              //       errorWidget: (context, url, error) =>
                              //           Icon(Icons.error),
                              //     ),
                              //   ),
                              // ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Container(
                                    child: Text(
                                      '${item.title} ',
                                      style: GoogleFonts.poppins(
                                          fontSize: height * 0.02),
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.call_made_sharp,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  getCaseDetails(String query) async {
    docList.clear();
    dogList.clear();
    setState(() {
      print('Updated');
    });

    if (query == '') {
      print(query);
      getData();
      return;
    }

    await FirebaseFirestore.instance
        .collection('NewsSchem1').orderBy('TimeStamp',descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      docList.clear();
      dogList.clear();
      snapshot.docs.forEach((f) {
        var name = f['title'].toString().toLowerCase();
        var category=f['category'].toString().toLowerCase();
//        List<dynamic> dogsub = List<String>.from(f['subcategorysearch']);
//        List<dynamic> dogName = List<String>.from(f['nameSearch']);
//        List<dynamic> dogBreed = List<String>.from(f['categorySearch']);
        List<String> dogLowerCase = [];
        List<String> breedLowerCase = [];
        List<String> dogsubLowerCase = [];
//        print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
//        print( f['Quantity'].length);
//        for (var dog in dogName) {
//          dogLowerCase.add(dog.toLowerCase());
//        }
//        for (var breed in dogBreed) {
//          breedLowerCase.add(breed.toLowerCase());
//        }
//        for (var sub in dogsub) {
//          dogsubLowerCase.add(sub.toLowerCase());
//        }
        if (name.toString().toLowerCase().contains(query.toLowerCase())||category==query.toLowerCase() ) {


          docList.add(f);
          DataModel dp = DataModel(
              timestamp: f['TimeStamp'],
//              author: f['author'],
              category: f['category'],
              content: List.from(f['content']),
//              coveredBy: f['coveredBy'],
              description: f['description'],
//              imageCaption: f['imageCaption'],
//              imageURL: f['imageURL'],
//              live: f['live'],
//              route: f['route'],
//              seotag: List.from(f['seotag']),
//              tags: List.from(f['tags']),
              title:f['title'],
          id:f.id);

          dogList.add(dp);
          setState(() {
            print('Updated');
          });
        }



      });
    });
  }

  void getData() async {
    await FirebaseFirestore.instance
        .collection("NewsSchem1").orderBy('TimeStamp',descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) {
        dogList.add(  DataModel(
        timestamp: f['TimeStamp'],
            author: f['author'],
            category: f['category'],
            content: List.from(f['content']),
            coveredBy: f['coveredBy'],
            description: f['description'],
            imageCaption: f['imageCaption'],
            imageURL: f['imageURL'],
            live: f['live'],
            route: f['route'],
            seotag: List.from(f['seotag']),
            tags: List.from(f['tags']),
            title:f['title'],
        id: f.id));

        print('Dog added');
//        print(f['profileImage'].toString());
//        print('--------------------${f['Quantity'].length}');
      });
    });
    setState(() {
      print(dogList.length.toString());
    });
  }
}
