import 'package:Puub/screens/private/map_widget.dart';
import 'package:Puub/services/static/static_data_service.dart';
import 'package:Puub/widgets/puub_home_page_component.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isResultAvailable = true;
  Map<String, dynamic> swNECorners;
  @override
  void initState() {
    super.initState();
  }

  void _getResults(Map<String, dynamic> corners) {
    double lat1temp = double.parse(corners['swLat']);
    double lat2temp = double.parse(corners['neLat']);
    double lon1temp = double.parse(corners['swLon']);
    double lon2temp = double.parse(corners['neLon']);

    double lat1, lat2, lon1, lon2;
    if (lat1temp < lat2temp) {
      lat1 = lat1temp;
      lat2 = lat2temp;
    } else {
      lat1 = lat2temp;
      lat2 = lat1temp;
    }
    if (lon1temp < lon2temp) {
      lon1 = lon1temp;
      lon2 = lon2temp;
    } else {
      lon1 = lon2temp;
      lon2 = lon1temp;
    }
    Map<String, dynamic> temp = new Map();
    temp.putIfAbsent('lat1', () => lat1);
    temp.putIfAbsent('lat2', () => lat2);
    temp.putIfAbsent('lon1', () => lon1);
    temp.putIfAbsent('lon2', () => lon2);

    setState(() {
      swNECorners = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          MapWidget(
            initialCameraPosition: StaticDataService.kLake,
            getResults: _getResults,
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: swNECorners != null
                ? PuubHomePageComponent(
                    leftText: "",
                    rightText: "",
                    corners: swNECorners,
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          )
        ],
      ),
    );
  }
}
