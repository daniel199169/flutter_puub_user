
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StaticDataService {
  static const double CAMERA_TILT = 80;
  static const double CAMERA_BEARING = 30;
  static const double CAMERA_ZOOM = 15;

  static const List<Map> bottomAppBarItem = [
    {
      "text": "Home",
      "icon": FaIcon(FontAwesomeIcons.user),
    },
    {
      "text": "Category",
      "icon": FaIcon(FontAwesomeIcons.user),
    },
    {
      "text": "Map",
      "icon": FaIcon(FontAwesomeIcons.user),
    },
    {
      "text": "Settings",
      "icon": FaIcon(FontAwesomeIcons.user),
    },
  ];

  static const List<Map> settingData = [
    {
      "text": "App Settings",
      "images": FaIcon(FontAwesomeIcons.user),
    },
    {
      "text": "Personal Details",
      "images": FaIcon(FontAwesomeIcons.user),
    },
    {
      "text": "Puub ID",
      "images": FaIcon(FontAwesomeIcons.calendarCheck),
    },
    {
      "text": "Saved Pubs",
      "images": FaIcon(FontAwesomeIcons.user),
    },
    {
      "text": "Terms and Conditions",
      "images": FaIcon(FontAwesomeIcons.user),
    },
  ];

  static const List<Map> verifyData = [
    {
      "label": "Cristiano Ronaldo",
      "isLink": false,
    },
    {
      "label": "Juventas",
      "isLink": false,
    },
    {
      "label": "Verified Until XXX",
      "isLink": false,
    },
    {
      "label": "Reverify now",
      "isLink": true,
    },
    {
      "label": "Change instituition",
      "isLink": true,
    },
  ];

  static const List<Map> personalData = [
    {
      "label": "First Name : ",
      "value": 'Cristiano',
      "canChange": false,
    },
    {
      "label": "Last Name : ",
      "value": 'Ronaldo',
      "canChange": false,
    },
    {
      "label": "Email : ",
      "value": 'cr7@gmail.com',
      "canChange": false,
    },
    {
      "label": "Date of Birth : ",
      "value": '9th April 1991',
      "canChange": false,
    },
    {
      "label": "Phone : ",
      "value": '+12345678',
      "canChange": true,
    },
    {
      "label": "Password : ",
      "value": '********',
      "canChange": true,
    },
  ];

  static const String TWITTER_KEY = 'IfcWffzMiS2aa0fcG2uOFxPLu';
  static const String TWITTER_SECRET = 'VG9lDtIjkmXuBSRN3mlRbB5IpmASnwtpw71eULIPaqu5zcLRnk';

  static const String INSTAGRAM_KEY = '576649349662433';
  static const String INSTAGRAM_SECRET = '34686202ba0cb7c20ec701c49ffae839';

  static const LatLng kLake = LatLng(37.43296265331129, -122.08832357078792);

  static const List<Map> appSettings = [
    {
      "text": "Alert if walk near pub with deal on",
      "type": 'switch',
    },
    {
      "text": "Display in miles or km",
      "type": 'switch',
    },
    {
      "text": 'Verify as "Student"',
      "type": 'normal',
    },
    {
      "text": 'Verify as "NHS"',
      "type": 'normal',
    },
    {
      "text": 'Verify as "Forces"',
      "type": 'normal',
    },
  ];

  static const List<Map> categoryData = [
    {
      "text": "Puub Deal near me",
      "images": 'assets/images/cat.jpeg',
    },
    {
      "text": "Top Deals",
      "images": 'assets/images/cat.jpeg',
    },
    {
      "text": "Beer Deals",
      "images": 'assets/images/cat.jpeg',
    },
    {
      "text": "Cider Deals",
      "images": 'assets/images/cat.jpeg',
    },
    {
      "text": "Wine Deals",
      "images": 'assets/images/cat.jpeg',
    },
    {
      "text": "Spirits Deals",
      "images": 'assets/images/cat.jpeg',
    },
    {
      "text": "Favourite Pubs",
      "images": 'assets/images/cat.jpeg',
    },
    {
      "text": "All Deals",
      "images": 'assets/images/cat.jpeg',
    },
  ];
}
