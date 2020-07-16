import 'package:Puub/services/authentication/puub_auth_service.dart';
import 'package:Puub/services/static/static_data_service.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PuubAppSettingWidget extends StatefulWidget {
  @override
  _PuubAppSettingWidgetState createState() => _PuubAppSettingWidgetState();
}

class _PuubAppSettingWidgetState extends State<PuubAppSettingWidget> {
  bool nearby = true;
  bool display = true;
  PuubAuthService p = PuubAuthService();

  void _switchOnchange(bool val, String tit, String uid) {
    print("VALUE : $val");
    if (tit.contains('near pub with deal on')) {
      print('KKKK');
      p.updateDealOnRadio(val, uid);
    } else {
      p.updateShowInKmRadio(val, uid);
    }
  }

  Widget _getTrailer(String title, String type, bool val, String uid) {
    if (type == 'switch') {
      return SizedBox(
        child: CustomSwitch(
          activeColor: Colors.green,
          value: val,
          onChanged: (value) {
            _switchOnchange(value, title, uid);
          },
        ),
      );
    } else {
      return Icon(Icons.arrow_right);
    }
  }

  Widget _getRow(String title, String type, bool value, String uid) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          trailing: _getTrailer(title, type, value, uid),
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<PuubAuthService>(context, listen: false);
    return StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot2) {
        if (!snapshot2.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
        return StreamBuilder(
          stream: p.getCurrentUser(snapshot2.data.uid).asStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            }
            print('GGGGHHH ' + snapshot.data.firstName.toString());
            return Container(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    for (int i = 0;
                        i < StaticDataService.appSettings.length;
                        i++)
                      _getRow(
                          StaticDataService.appSettings[i]['text'],
                          StaticDataService.appSettings[i]['type'],
                          StaticDataService.appSettings[i]['text']
                                  .contains('deal on')
                              ? snapshot.data.isDealOn
                              : snapshot.data.showInKm,
                          snapshot2.data.uid),
                  ],
                ),
              ),
            );
          },
        );
        //print('snapshot.data.id ' + snapshot.data.toString());
      },
    );
  }
}
