import 'package:Puub/screens/private/map_widget.dart';
import 'package:Puub/services/authentication/puub_auth_service.dart';
import 'package:Puub/services/map/puub_map_service.dart';
import 'package:Puub/services/static/static_data_service.dart';
import 'package:Puub/widgets/puub_cached_network_image.dart';
import 'package:Puub/widgets/puub_category_card.dart';
import 'package:Puub/widgets/puub_home_page_component.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PuubAuthService _auth = PuubAuthService();
  List<Widget> imageSliders = new List();
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];
  Map<String, dynamic> swNECorners;

  void _getDate() {
    imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      PuubCachedNetworkImage(
                        imageURL: item,
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
                          child: SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ))
        .toList();
  }

  @override
  void initState() {
    _getDate();
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
      print('Hello');
      swNECorners = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              child: SizedBox(
                height: 150.0,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                    bottom: 10,
                  ),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                    ),
                    items: imageSliders,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                overflow: Overflow.visible,
                fit: StackFit.loose,
                children: <Widget>[
                  Stack(
                    overflow: Overflow.visible,
                    fit: StackFit.loose,
                    children: <Widget>[
                      MapWidget(
                        initialCameraPosition: StaticDataService.kLake,
                        getResults: _getResults,
                      ),
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ],
                  ),
                  StreamBuilder(
                    stream: Firestore.instance
                        .collection('deals')
                        .where('parentID', isEqualTo: "0")
                        .orderBy('id')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            return PuubHomePageComponent(
                              leftText: snapshot.data.documents[index]['label'],
                              rightText: "See all ->",
                              id: snapshot.data.documents[index]['id'],
                              corners: swNECorners,
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
