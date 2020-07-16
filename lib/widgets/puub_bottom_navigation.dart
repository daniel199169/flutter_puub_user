import 'package:Puub/services/static/static_data_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PuubBottomNavigation extends StatefulWidget {
  final Function setViewForIndex;
  PuubBottomNavigation(
    this.setViewForIndex,
  );
  @override
  _PuubBottomNavigationState createState() => _PuubBottomNavigationState();
}

class _PuubBottomNavigationState extends State<PuubBottomNavigation> {
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  void _bottomItemTapped(int tappedIndex) {
    setState(() {
      _selectedIndex = tappedIndex;
    });
    widget.setViewForIndex(_selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).bottomAppBarColor,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Theme.of(context).primaryColor,
      currentIndex: _selectedIndex,
      iconSize: 25.0,
      elevation: 10.0,
      onTap: (int index) {
        _bottomItemTapped(index);
      },
      type: BottomNavigationBarType.fixed,
      items: [
        for (var item in StaticDataService.bottomAppBarItem)
          _buildBottomNavigationBarItem(item['icon'], item['text']),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      FaIcon iconData, String text) {
    return BottomNavigationBarItem(
      icon: iconData,
      title: Text(text),
    );
  }
}
