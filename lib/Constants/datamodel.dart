import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  var timestamp;
  String author;
  String category;
  List content = [];
  String coveredBy;
  String description;
  String imageCaption;
  String imageURL;
  bool live;
  String route;
  List seotag = [];
  List tags = [];
  String title;
  String id;

  DataModel(
      {this.timestamp, this.author, this.category, this.content, this.coveredBy, this.description, this.imageCaption, this.imageURL, this.live, this.route, this.seotag, this.tags, this.title,this.id});

  List<DataModel> search (QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap = snapshot.data();

      return DataModel(
        timestamp: dataMap['TimeStamp'],
        author: dataMap['author'],
        category: dataMap['category'],
        content: dataMap['content'],
        coveredBy: dataMap['coveredBy'],
        description: dataMap['description'],
        imageCaption: dataMap['imageCaption'],
        imageURL: dataMap['imageURL'],
        live: dataMap['live'],
        route: dataMap['route'],
        seotag: dataMap['seotag'],
        tags: dataMap['tags'],
        title:dataMap['title']
        );
    }).toList();
  }
}

