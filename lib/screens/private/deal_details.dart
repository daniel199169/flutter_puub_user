import 'package:Puub/widgets/puub_category_card.dart';
import 'package:flutter/material.dart';

class DealDetails extends StatefulWidget {
  final String leftText;
  DealDetails({this.leftText});
  @override
  _DealDetailsState createState() => _DealDetailsState();
}

class _DealDetailsState extends State<DealDetails> {
  int denomitar = 410;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puub'),
        centerTitle: true,
      ),
      body: Column(
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
                    // onTap: _listView,
                    child: Row(
                      children: <Widget>[
                        FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              if (denomitar == 205) {
                                denomitar = 410;
                              } else {
                                denomitar = 205;
                              }
                            });
                          },
                          mini: true,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.home,
                            size: 20,
                          ),
                          elevation: 10.0,
                          isExtended: false,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          heroTag: null,
                        ),
                        FloatingActionButton(
                          onPressed: () {},
                          mini: true,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.ac_unit,
                            size: 20,
                          ),
                          elevation: 10.0,
                          isExtended: false,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          heroTag: null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: Container(
              //height: 200.0,
              child: GridView.builder(
                itemCount: 10,
                padding: EdgeInsets.all(10.0),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    //height: 10,
                    child: PuubCategoryCard(),
                  );
                },
                //physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (MediaQuery.of(context).size.width / denomitar).round(),
                ),
              ),
              /*ListView(
                children: <Widget>[
                  for (var i = 0; i <= 10; i++)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 280.0,
                      child: PuubCategoryCard(),
                    ),
                ],
              ),*/
            ),
          ),
        ],
      ),
    );
  }
}
