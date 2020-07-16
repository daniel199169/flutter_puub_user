import 'package:Puub/models/deal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Pub {
  String id;
  String name;
  String address;
  String phoneNumber;
  double latitude;
  double longitude;
  String imageURL;
  List<Deal> dealList;

  Pub({
    @required this.id,
    @required this.name,
    @required this.address,
    @required this.phoneNumber,
    @required this.latitude,
    @required this.longitude,
    @required this.imageURL,
    @required this.dealList,
  });

  factory Pub.fromMap(Map data) {
    data = data ?? {};
    return Pub(
      id: data['id'],
      name: data['name'],
      address: data['address'],
      phoneNumber: data['phoneNumber'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      dealList: data['deals'].map<List<Deal>>((deal) {
        return Deal.fromMap(deal);
      }).toList(),
      imageURL: data['imageURL'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonPub = new Map<String, dynamic>();
    jsonPub['id'] = this.id.trim();
    jsonPub['name'] = this.name.trim();
    jsonPub['address'] = this.address.trim();
    jsonPub['phoneNumber'] = this.phoneNumber.trim();
    jsonPub['latitute'] = this.latitude;
    jsonPub['longitude'] = this.longitude;
    jsonPub['imageURL'] = this.imageURL.trim();
    jsonPub['deals'] = this.dealList;
    return jsonPub;
  }
}
