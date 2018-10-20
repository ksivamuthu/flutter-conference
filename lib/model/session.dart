import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  Session(
      {this.id,
      this.title,
      this.description,
      this.time,
      this.room,
      this.speaker,
      this.stars,
      this.reference});

  final String id;
  final String title;
  final String description;
  final String time;
  final String room;
  final String speaker;
  final int stars;
  final DocumentReference reference;

  static Session fromData(Map data, [DocumentReference reference]) {
    return Session(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        time: data['time'],
        room: data['room'],
        speaker: data['speaker'].path,
        stars: data['stars'] ?? 0,
        reference: reference);
  }

  static fromSnapshot(DocumentSnapshot snapshot) {
    return Session.fromData(snapshot.data, snapshot.reference);
  }
}

class Speaker {
  Speaker({this.name, this.img});

  final String name;
  final String img;

  static Speaker fromData(Map data) {
    return Speaker(name: data['name'], img: data['img']);
  }
}

class About {
  About(
      {this.title, this.description, this.twitter, this.facebook, this.meetup});

  final String title;
  final String description;
  final String twitter;
  final String facebook;
  final String meetup;

  static About fromData(Map data) {
    return About(
        title: data['header'],
        description: data['detail'],
        twitter: data['twitter'],
        facebook: data['facebook'],
        meetup: data['meetup']);
  }
}
