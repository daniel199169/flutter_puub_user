import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
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
            return GridView.builder(
              itemCount: snapshot.data.documents.length,
              padding: EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) {
                return _getSubCatCard(
                  snapshot.data.documents[index]['label'],
                  snapshot.data.documents[index]['imageUrl'],
                );
              },
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    (MediaQuery.of(context).size.width / 205).round(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _getSubCatCard(String text, String images) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () {
          print('Tapping Cat');
        },
        child: Card(
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.white70, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    images,
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
