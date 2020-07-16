import 'package:flutter/material.dart';

class Deal {
  String id;
  String imageUrl;
  String label;
  String parentID;
  DateTime startTime;
  DateTime endTime;
  Deal({
    this.id,
    this.imageUrl,
    this.label,
    this.parentID,
    this.startTime,
    this.endTime,
  });

  factory Deal.fromMap(Map data) {
    data = data ?? {};
    return Deal(
      id: data['id'],
      imageUrl: data['imageURL'],
      label: data['label'],
      parentID: data['parentDealID'],
      startTime: data['startTime'].toDate(),
      endTime: data['endTime'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonDeal = new Map<String, dynamic>();
    jsonDeal['id'] = this.id.trim();
    jsonDeal['imageUrl'] = this.imageUrl.trim();
    jsonDeal['label'] = this.label.trim();
    jsonDeal['parentDealID'] = this.parentID.trim();
    jsonDeal['startTime'] = this.startTime;
    jsonDeal['endTime'] = this.endTime;
    return jsonDeal;
  }
}
