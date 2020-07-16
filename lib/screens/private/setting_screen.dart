import 'package:Puub/screens/private/puub_app_setting_widget.dart';
import 'package:Puub/screens/private/puub_personal_details.dart';
import 'package:Puub/screens/private/puub_setting_verified_user.dart';
import 'package:Puub/services/authentication/puub_auth_service.dart';
import 'package:Puub/services/static/static_data_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingScreen extends StatefulWidget {
  final Function changeFlag;
  final int label;
  final bool isFreshOne;
  SettingScreen({this.changeFlag, this.label, this.isFreshOne});
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final PuubAuthService _auth = PuubAuthService();
  int _label;
  bool flag = false;

  @override
  void initState() {
    print('Kedlo');
    _label = widget.label;
    super.initState();
  }

  @override
  void dispose() {
    print('HHHH');
    super.dispose();
  }

  void _logout() {
    _auth.signOut();
  }

  void _setSubDetails(int index) {
    setState(() {
      flag = true;
    });
    widget.changeFlag(flag);
    setState(() {
      _label = index;
      //flag = false;
    });
  }

  Widget _getMainScreen(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int i = 0; i < StaticDataService.settingData.length; i++)
          GestureDetector(
            onTap: () {
              _setSubDetails(i + 1);
            },
            child: _gettingListTile(StaticDataService.settingData[i]['text'],
                StaticDataService.settingData[i]['images']),
          ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: _logout,
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.signOutAlt,
              color: Colors.red,
            ),
            title: Text('Logout'),
          ),
        ),
      ],
    );
  }

  Widget _resolveSettingScreen(BuildContext context) {
    switch (_label) {
      case 0:
        return _getMainScreen(context);
        break;
      case 1:
        return PuubAppSettingWidget();
        break;
      case 2:
        return PuubPersonalDetails();
        break;
      case 3:
        return PuubSettingVerifiedUser();
        break;
      case 4:
        return _getMainScreen(context);
        break;
      default:
    }
  }

  void _check() {
    if (_label != widget.label && !widget.isFreshOne) {
      setState(() {
        _label = widget.label;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('vvv ' + _label.toString());
    print('jjj ' + widget.label.toString());
    print('flag ' +widget.isFreshOne.toString());
    _check();
    return _resolveSettingScreen(context);
  }

  Widget _gettingListTile(String label, FaIcon ic) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: ic,
          title: Text(
            label,
            style: TextStyle(color: Colors.black87),
          ),
          trailing: Icon(Icons.arrow_right),
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }
}
