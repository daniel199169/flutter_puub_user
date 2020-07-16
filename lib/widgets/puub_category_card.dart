import 'package:Puub/models/user.dart';
import 'package:Puub/screens/private/puub_personal_details.dart';
import 'package:Puub/screens/private/puub_profile_screen.dart';
import 'package:Puub/widgets/puub_cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PuubCategoryCard extends StatefulWidget {
  final String imageURL;
  final String name;
  final String address;
  final String dealName;
  final bool isLovedOne;
  final User usr;
  final String pubId;
  PuubCategoryCard(
      {this.imageURL,
      this.name,
      this.address,
      this.dealName,
      this.isLovedOne,
      this.usr,
      this.pubId});

  @override
  _PuubCategoryCardState createState() => _PuubCategoryCardState();
}

class _PuubCategoryCardState extends State<PuubCategoryCard> {
  bool _isLovedOne;

  @override
  void initState() {
    _isLovedOne = widget.isLovedOne;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.all(10.0),
      child: _getCardChild(context),
    );
  }

  Widget _getCardChild(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => new PuubProfileScreen(),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 0.65,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  child: PuubCachedNetworkImage(imageURL: widget.imageURL),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 10.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.5),
                child: _getDescription(),
              ),
            ),
            Positioned(
              top: 15.0,
              right: 15.0,
              child: GestureDetector(
                onTap: () async {
                  List<String> isLoked = widget.usr.likedPub;
                  if(isLoked == null){
                    isLoked = new List();
                    isLoked.add(widget.pubId);
                  }
                  if (isLoked.contains(widget.pubId)) {
                    isLoked.remove(widget.pubId);
                  } else {
                    isLoked.add(widget.pubId);
                  }

                  var firebaseUser = await FirebaseAuth.instance.currentUser();
                  await Firestore.instance
                      .collection('users')
                      .document(firebaseUser.uid)
                      .updateData({
                    "likedPub": isLoked,
                  });
                  setState(() {
                    _isLovedOne = !_isLovedOne;
                  });
                },
                child: new Icon(
                  widget.usr.likedPub == null
                      ? Icons.favorite_border
                      : widget.usr.likedPub.contains(widget.pubId)
                          ? Icons.favorite
                          : Icons.favorite_border,
                  color: widget.usr.likedPub == null
                      ? Colors.white
                      : widget.usr.likedPub.contains(widget.pubId)
                          ? Colors.red
                          : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDescription() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < 3; i++) _getRows(i),
      ],
    );
  }

  Widget _getRows(int index) {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          index == 0
              ? CircleAvatar(
                  backgroundImage: Image.network(
                    widget.imageURL == null
                        ? 'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80'
                        : widget.imageURL,
                    fit: BoxFit.contain,
                  ).image,
                  child: Text(' '),
                  radius: 7.0,
                )
              : index == 1
                  ? Icon(
                      Icons.room_service,
                      size: 14,
                    )
                  : Icon(
                      Icons.room,
                      size: 14,
                      color: Colors.grey,
                    ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            widget.imageURL == null
                ? 'Some Text'
                : index == 0
                    ? widget.name.trim()
                    : index == 1
                        ? widget.dealName.trim()
                        : widget.address.trim(),
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
