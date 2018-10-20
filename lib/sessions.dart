import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_conference/model/session.dart';
import 'package:flutter_conference/session-details.dart';

class SessionsPage extends StatefulWidget {
  @override
  _SessionsState createState() {
    return _SessionsState();
  }
}

class _SessionsState extends State<SessionsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            Firestore.instance.collection('sessions').orderBy('id').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildList(context, snapshot.data.documents);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> documents) {
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, i) {
        Session session = Session.fromSnapshot(documents[i]);
        return _buildListItem(context, session);
      },
    );
  }

  Widget _buildListItem(BuildContext context, Session session) {
    return Card(
        child: Container(
            child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SessionDetailsPage(session: session)));
                },
                contentPadding: EdgeInsets.all(10.0),
                title: Text(session.title,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(session.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400))),
                      Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Row(children: <Widget>[
                            Text('${session.time}',
                                style: TextStyle(color: Colors.black87)),
                            Spacer(flex: 1),
                            Text('Room: ${session.room}',
                                style: TextStyle(color: Colors.black87)),
                            Spacer(flex: 1),
                            Text('${session.stars}',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: 10.0),
                            IconButton(
                                onPressed: () {
                                  _onStarredSession(session);
                                },
                                icon: Icon(Icons.star_border)),
                          ]))
                    ]))));
  }

  void _onStarredSession(Session session) {
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(session.reference);
      final fresh = Session.fromSnapshot(freshSnapshot);

      await transaction.update(fresh.reference, {'stars': fresh.stars + 1});
    });
  }
}
