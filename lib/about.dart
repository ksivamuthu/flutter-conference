import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conference/model/session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutState createState() {
    return new _AboutState();
  }
}

class _AboutState extends State<AboutPage> {
  About _about;
  String _sentiment;

  @override
  initState() {
    super.initState();
    fetchAbout();
  }

  void fetchAbout() async {
    var snapshot = await Firestore.instance.collection("about").getDocuments();
    if (snapshot != null) {
      setState(() {
        _about = About.fromData(snapshot.documents[0].data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _about != null
        ? SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(children: <Widget>[
                  _buildHeader(context),
                  new SizedBox(height: 15.0),
                  _buildAboutUs(context),
                  new SizedBox(height: 15.0),
                  _buildSocial(context),
                  new SizedBox(height: 15.0),
                  _buildFeedback(context),
                  new SizedBox(height: 15.0),
                  _buildSentiment(context)
                ])))
        : LinearProgressIndicator();
  }

  _buildHeader(BuildContext context) {
    return Text(_about.title, style: TextStyle(fontSize: 24.0));
  }

  _buildAboutUs(BuildContext context) {
    return Text(
      _about.description,
      style: TextStyle(fontSize: 18.0),
    );
  }

  _buildSocial(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              IconButton(
                  iconSize: 42.0,
                  color: Colors.lightBlueAccent,
                  onPressed: () async {
                    if (await canLaunch(_about.twitter)) {
                      launch(_about.twitter);
                    }
                  },
                  icon: Icon(FontAwesomeIcons.twitter)),
              IconButton(
                  iconSize: 42.0,
                  color: Colors.blueAccent,
                  onPressed: () async {
                    if (await canLaunch(_about.facebook)) {
                      launch(_about.facebook);
                    }
                  },
                  icon: Icon(FontAwesomeIcons.facebook)),
              IconButton(
                  iconSize: 42.0,
                  color: Colors.redAccent,
                  onPressed: () async {
                    if (await canLaunch(_about.meetup)) {
                      launch(_about.meetup);
                    }
                  },
                  icon: Icon(FontAwesomeIcons.meetup))
            ])));
  }

  _buildFeedback(BuildContext context) {
    return RaisedButton(
        onPressed: () async {
          await _getAndScanImage();
        },
        color: Colors.redAccent,
        textColor: Colors.white,
        child: Text("Submit Feedback"));
  }

  File _imageFile;

  Future<void> _getAndScanImage() async {
    setState(() {
      _imageFile = null;
    });

    final File imageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
      _scanImage(_imageFile);
    }
  }

  void _scanImage(File imageFile) async {
    var detector = FirebaseVision.instance
        .faceDetector(FaceDetectorOptions(enableClassification: true));
    var faces =
        await detector.detectInImage(FirebaseVisionImage.fromFile(imageFile));
    if (faces != null && faces.length > 0) {
      var probability = faces[0].smilingProbability;
      var sentiment = '';
      if (probability >= 0.7) {
        sentiment = 'happy';
      } else if (probability < 0.7 && probability >= 0.4) {
        sentiment = 'neutral';
      } else {
        sentiment = 'sad';
      }

      setState(() {
        _sentiment = sentiment;
      });
    }
  }

  _buildSentiment(BuildContext context) {
    String displayText = "";
    if (_sentiment == 'happy') {
      displayText = "Yay !!! I love the conference";
    } else if (_sentiment == 'neutral') {
      displayText = "Its okay. I'm neutral in emotion";
    } else if (_sentiment == 'sad') {
      displayText = "No.. It sucks. I never come again";
    }

    return Center(child: Text(displayText, style: TextStyle(fontSize: 20.0)));
  }
}
