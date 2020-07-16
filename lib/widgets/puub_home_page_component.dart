import 'package:Puub/models/deal.dart';
import 'package:Puub/models/pub.dart';
import 'package:Puub/models/user.dart';
import 'package:Puub/screens/private/deal_details.dart';
import 'package:Puub/services/firestore/puub_auth_firestore_service.dart';
import 'package:Puub/widgets/puub_category_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PuubHomePageComponent extends StatefulWidget {
  final String rightText;
  final String leftText;
  final String id;
  final Map<String, dynamic> corners;
  PuubHomePageComponent({
    this.leftText,
    this.rightText,
    this.id,
    this.corners,
  });

  @override
  _PuubHomePageComponentState createState() => _PuubHomePageComponentState();
}

class _PuubHomePageComponentState extends State<PuubHomePageComponent> {
  bool isScrollDirectionIsHorizontal = true;
  String leftText = '';
  String rightText = '';
  bool flag = false;
  User ur;

  @override
  void initState() {
    final userService =
        Provider.of<PuubAuthFirestoreService>(context, listen: false);
    Stream<User> a = userService.puubHero;
    a.first.then((value) {
      ur = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.leftText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: _listView,
                  child: Text(
                    widget.rightText,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: 250.0,
          width: MediaQuery.of(context).size.width,
          child: widget.corners != null
              ? StreamBuilder(
                  stream: Firestore.instance
                      .collection('pubs')
                      .where('latitute',
                          isGreaterThan: widget.corners['lat1'],
                          isLessThan: widget.corners['lat2'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                          'Loading...',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    } else {
                      List<Pub> pubList = new List();
                      for (int v = 0; v < snapshot.data.documents.length; v++) {
                        pubList.add(new Pub(
                          id: snapshot.data.documents[v].data['id'],
                          name: snapshot.data.documents[v].data['name'],
                          address: snapshot.data.documents[v].data['address'],
                          phoneNumber:
                              snapshot.data.documents[v].data['phoneNumber'],
                          latitude: double.parse(snapshot
                              .data.documents[v].data['latitute']
                              .toString()),
                          longitude: double.parse(snapshot
                              .data.documents[v].data['longitude']
                              .toString()),
                          imageURL: snapshot.data.documents[v].data['imageURL'],
                          dealList:
                              snapshot.data.documents[v].data['deals'] == null
                                  ? null
                                  : snapshot.data.documents[v].data['deals']
                                      .map<Deal>((data) {
                                      return Deal.fromMap(data);
                                    }).toList(),
                        ));
                      }
                      return ListView.builder(
                        itemCount: pubList.length,
                        padding: EdgeInsets.all(10.0),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          double lon = pubList[index].longitude;
                          double lessThn =
                              double.parse(widget.corners['lon1'].toString());
                          double grtThn =
                              double.parse(widget.corners['lon2'].toString());
                          if (lon < lessThn || lon > grtThn) {
                            return SizedBox.shrink();
                          }
                          if (pubList[index].dealList == null) {
                            return SizedBox.shrink();
                          }
                          List<Deal> deals = pubList[index].dealList;
                          return ListView.builder(
                              itemCount: deals.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int idx) {
                                if (widget.id == null) {
                                } else {
                                  if (deals[idx].parentID != widget.id) {
                                    return SizedBox.shrink();
                                  }
                                }
                                bool isLovedOne = false;
                                if(ur.likedPub == null){
                                  isLovedOne = false;
                                }else if (ur.likedPub.contains(pubList[index].id)) {
                                  isLovedOne = true;
                                }
                                return SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 10.0,
                                  child: PuubCategoryCard(
                                    isLovedOne: isLovedOne,
                                    imageURL: deals[idx].imageUrl,
                                    address: pubList[index].address,
                                    dealName: deals[idx].label,
                                    name: pubList[index].name,
                                    usr: ur,
                                    pubId: pubList[index].id,
                                  ),
                                );
                              });
                        },
                        shrinkWrap: true,
                      );
                    }
                  },
                )
              : Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
        ),
      ],
    );
  }

  void _listView() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => new DealDetails(leftText: widget.leftText)),
    );
  }
}
