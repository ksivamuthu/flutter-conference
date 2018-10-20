import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conference/model/session.dart';

class SpeakersPage extends StatefulWidget {
  @override
  _SpeakersState createState() {
    return new _SpeakersState();
  }
}

class _SpeakersState extends State<SpeakersPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('speakers').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildGrid(context, snapshot.data.documents);
        });
  }

  List<Widget> _buildSpeakerItems(List<DocumentSnapshot> documents) {
    return List.generate(documents.length, (index) {
      var speaker = Speaker.fromData(documents[index].data);
      return Center(
          child: Column(children: [
        CircleAvatar(radius: 50.0, backgroundImage: NetworkImage(speaker.img)),
        Padding(padding: EdgeInsets.only(top: 4.0), child: Text(speaker.name)),
      ]));
    });
  }

  Widget _buildGrid(BuildContext context, List<DocumentSnapshot> documents) {
    return Padding(
        padding:
            EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
        child: GridView.count(
          crossAxisCount: 3,
          children: _buildSpeakerItems(documents),
        ));
  }
}
