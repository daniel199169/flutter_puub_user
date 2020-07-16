import 'dart:async';

import 'package:Puub/models/marker_model.dart';
import 'package:Puub/services/map/puub_map_service.dart';
import 'package:Puub/services/static/static_data_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  final LatLng initialCameraPosition;
  final Function getResults;
  MapWidget({this.initialCameraPosition, this.getResults});
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController ctrl;
  LatLng initial;

  void _getInitialLatLng() {
    PuubMapService.getCurrentUserLocation().then((value) {
      setState(() {
        initial = value;
      });
    });
  }

  @override
  void initState() {
    _getInitialLatLng();
    super.initState();
  }

  List _getData() {
    List<MarkerModel> markerList = new List();
    PuubMapService.getNEAndSWLatLng(ctrl).then((value) {
      Stream<QuerySnapshot> streamQuery = Firestore.instance
          .collection('pubs')
          .where(
            'latitute',
            isGreaterThan: value['lat1'],
            isLessThan: value['lat2'],
          )
          .snapshots();
      streamQuery.forEach((element) {
        markerList.add(
          new MarkerModel(
            lat: double.parse(
              element.documents[0].data['latitute'],
            ),
            lng: double.parse(
              element.documents[0].data['longitude'],
            ),
          ),
        );
      });
      return markerList;
    });
  }

  Set<Marker> _getMarkers() {
    return null;
  }

  Future<void> _onCameraIdle() async {
    final puubMap = await PuubMapService.getNEAndSWLatLng(ctrl);
    widget.getResults(puubMap);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: initial == null
          ? Center(
              child: Text(
                'loading map...',
                style: TextStyle(
                    fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
              ),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.initialCameraPosition,
                zoom: StaticDataService.CAMERA_ZOOM,
                tilt: StaticDataService.CAMERA_TILT,
                bearing: StaticDataService.CAMERA_BEARING,
              ),
              rotateGesturesEnabled: true,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                  () => new EagerGestureRecognizer(),
                ),
              ].toSet(),
              myLocationEnabled: true,
              markers: _getMarkers(),
              onMapCreated: (GoogleMapController controller) {
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: initial, zoom: StaticDataService.CAMERA_ZOOM),
                  ),
                );

                _controller.complete(controller);

                setState(() {
                  ctrl = controller;
                });
              },
              onCameraIdle: _onCameraIdle,
            ),
    );
  }
}
