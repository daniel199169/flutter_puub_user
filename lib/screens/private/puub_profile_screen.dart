import 'package:flutter/material.dart';

class PuubProfileScreen extends StatefulWidget {
  @override
  _PuubProfileScreenState createState() => _PuubProfileScreenState();
}

class _PuubProfileScreenState extends State<PuubProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.25,
            elevation: 10.0,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            pinned: false,
            flexibleSpace: Image.network(
              'https://images.unsplash.com/photo-1514933651103-005eec06c04b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
              fit: BoxFit.fill,
            ),
          ),
          SliverFillRemaining(
            child: _getBody(context),
          ),
        ],
      ),
    );
  }

  Widget _getBody(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            radius: 10,
          ),
          title: Text('The Red Lion'),
          trailing: Icon(Icons.favorite),
        ),
        Divider(
          color: Colors.grey,
        ),
        ListTile(
          trailing: Icon(
            Icons.location_on,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            'Refine spot with an upmarket British menu,lots of exposed wood and a landscape garden',
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 4,
              ),
              ListTile(
                leading: SizedBox(
                  width: 1,
                  height: 1,
                  child: Icon(Icons.location_on, size: 20,),
                ),
                title: Text('33 Hight St, Granchester , Cambridge, CB3 9NF', style: TextStyle(fontSize: 14),),
              ),
              SizedBox(
                height: 4,
              ),
              ListTile(
                leading: SizedBox(
                  width: 1,
                  height: 1,
                  child: Icon(Icons.phone, size: 20,),
                ),
                title: Text('001223840121', style: TextStyle(fontSize: 14),),
              ),
            ],
          ),
          isThreeLine: true,
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }
}
