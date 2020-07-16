import 'package:Puub/screens/private/category_screen.dart';
import 'package:Puub/screens/private/home_screen.dart';
import 'package:Puub/screens/private/map_screen.dart';
import 'package:Puub/screens/private/setting_screen.dart';
import 'package:Puub/services/pushnotification/puub_push_notification_service.dart';
import 'package:Puub/widgets/puub_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeWrapper extends StatefulWidget {
  final String uid;
  HomeWrapper({this.uid});
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _curreentIndex;
  bool flag = false;
  int label = 0;
  bool isFreshOne = false;
  PuubPushNotificationsService p = new PuubPushNotificationsService();

  @override
  void initState() {
    p.init(widget.uid);
    _curreentIndex = 0;
    super.initState();
  }

  void _changeFlag(bool f) {
    setState(() {
      flag = f;
      isFreshOne = !isFreshOne;
    });
  }

  Widget _resolveBody(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
        break;
      case 1:
        return CategoryScreen();
        break;
      case 2:
        return MapScreen();
        break;
      case 3:
        return SettingScreen(
          changeFlag: _changeFlag,
          label: label,
          isFreshOne: isFreshOne,
        );
        break;
      default:
        return HomeScreen();
    }
  }

  void resolveBodyIndex(int index) {
    setState(() {
      _curreentIndex = index;
      flag = false;
    });
  }

  void gotPushMessges(String title, String msgSource) {
    print('GGG BRB ' + msgSource);
  }

  @override
  Widget build(BuildContext context) {
    p.config(gotPushMessges, context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Puub'),
        centerTitle: true,
        leading: flag
            ? GestureDetector(
                onTap: () {
                  print('hello');
                  setState(() {
                    _curreentIndex = 3;
                    label = 0;
                    isFreshOne = false;
                    flag = !flag;
                  });
                  //resolveBodyIndex(3);
                },
                child: Icon(
                  Icons.arrow_back,
                ),
              )
            : null,
      ),
      body: _resolveBody(_curreentIndex),
      bottomNavigationBar: PuubBottomNavigation(resolveBodyIndex),
    );
  }
}
