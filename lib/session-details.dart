import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conference/model/session.dart';

class SessionDetailsPage extends StatefulWidget {
  final Session session;

  SessionDetailsPage({this.session});

  @override
  _SessionDetailState createState() {
    return new _SessionDetailState(session: this.session);
  }
}

class _SessionDetailState extends State<SessionDetailsPage> {
  final Session session;
  Speaker speaker;

  _SessionDetailState({this.session});

  @override
  void initState() {
    super.initState();

    Firestore.instance.document(this.session.speaker).get().then((snapshot) {
      setState(() {
        speaker = Speaker.fromData(snapshot.data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.session.title),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(children: <Widget>[
                  _buildHeader(context),
                  new SizedBox(height: 15.0),
                  _buildDetails(context),
                  new SizedBox(height: 15.0),
                  _buildAbstract(context)
                ]))));
  }

  Widget _buildHeader(BuildContext context) {
    return Text(this.session.title, style: TextStyle(fontSize: 24.0));
  }

  Widget _buildAbstract(BuildContext context) {
    return Text(
      this.session.description,
      style: TextStyle(fontSize: 18.0),
    );
  }

  Widget _buildDetails(BuildContext context) {
    if (speaker == null) return CircularProgressIndicator();
    return Column(children: [
      CircleAvatar(radius: 50.0, backgroundImage: NetworkImage(speaker.img)),
      Container(
          padding: EdgeInsets.only(top: 4.0),
          child: Text(speaker.name, style: TextStyle(fontSize: 18.0))),
      Container(
          padding: EdgeInsets.all(5.0),
          child: Text('Time: ${this.session.time}  Room: ${this.session.room}',
              style: TextStyle(fontSize: 18.0)))
    ]);
  }
}
