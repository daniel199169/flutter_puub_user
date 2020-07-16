import 'dart:io';

import 'package:Puub/services/authentication/puub_auth_service.dart';
import 'package:Puub/services/firestore/puub_auth_firestore_service.dart';
import 'package:Puub/services/firestore/puub_firestore_service.dart';
import 'package:Puub/services/static/static_data_service.dart';
import 'package:Puub/services/storage/puub_firestore_service.dart';
import 'package:Puub/services/storage/puub_firestore_storage_service.dart';
import 'package:Puub/widgets/puub_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PuubPersonalDetails extends StatefulWidget {
  @override
  _PuubPersonalDetailsState createState() => _PuubPersonalDetailsState();
}

class _PuubPersonalDetailsState extends State<PuubPersonalDetails> {
  File _image;
  PuubAuthService p = PuubAuthService();
  bool _shouldEditPhoneNumber = false;
  bool _shouldEditPassword = false;

  Widget _getHeader(BuildContext context, String url) {
    final database =
        Provider.of<PuubFirestoreAvatarService>(context, listen: false);
    return StreamBuilder<String>(
      stream: database.avatarReferenceStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor,
          );
        }
        final avatarReference = snapshot.data;
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.network(
                avatarReference == null
                    ? 'https://s.hs-data.com/bilder/spieler/gross/13029.jpg'
                    : avatarReference,
                width: 180.0,
                height: 180.0,
                fit: BoxFit.fill,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getListTile(String lead, String title, bool flag) {
    print('lead ' + lead + ":");
    return ListTile(
      leading: Text(
        lead,
        textAlign: TextAlign.end,
      ),
      title: (lead == 'Phone' && !_shouldEditPhoneNumber) ||
              (lead == 'Password' && !_shouldEditPassword) ||
              (lead != 'Phone' || lead != 'Password')
          ? Text(
              title,
              textAlign: TextAlign.start,
            )
          : TextField(),
      trailing: flag
          ? GestureDetector(
              onTap: () {
                if (lead == 'Phone') {
                  print('GERT'+_shouldEditPhoneNumber.toString()+lead);
                  setState(() {
                    _shouldEditPhoneNumber = !_shouldEditPhoneNumber;
                  });
                } else {
                  setState(() {
                    _shouldEditPassword = !_shouldEditPassword;
                  });
                }
              },
              child: Text('change'),
            )
          : Text('(cannot change)'),
    );
  }

  _getImageFromGallery(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    Navigator.of(context).pop();
  }

  _getImageFromCamera(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: (() {
                      _getImageFromGallery(context);
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: (() {
                      _getImageFromCamera(context);
                    }),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _chooseAvatar(BuildContext context) async {
    try {
      await _showDialog(context);
      if (_image != null) {
        final storage =
            Provider.of<PuubFirestoreStorageService>(context, listen: false);
        final downloadUrl = await storage.uploadAvatar(file: _image);
        final database =
            Provider.of<PuubFirestoreAvatarService>(context, listen: false);

        await database.setAvatarReference(downloadUrl);
        await _image.delete();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<PuubAuthService>(context, listen: false);
    final userService =
        Provider.of<PuubAuthFirestoreService>(context, listen: false);
    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              _getHeader(context,
                  'https://s.hs-data.com/bilder/spieler/gross/13029.jpg'),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => _chooseAvatar(context),
                child: Text('Add/Edit Profile Picture'),
              ),
              SizedBox(
                height: 30,
              ),
              StreamBuilder(
                stream: authService.user,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  }
                  return StreamBuilder(
                    stream: p.getCurrentUser(snapshot.data.uid).asStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        );
                      }
                      return Column(
                        children: <Widget>[
                          _getListTile(
                              'First Name', snapshot.data.firstName, false),
                          _getListTile(
                              'Last Name', snapshot.data.lastName, false),
                          _getListTile('Email', snapshot.data.email, false),
                          _getListTile('Date of Birth',
                              snapshot.data.dob.toString(), false),
                          _getListTile(
                              'Phone', snapshot.data.phoneNumber, true),
                          _getListTile(
                              'Password',
                              snapshot.data.password == null
                                  ? ''
                                  : snapshot.data.password,
                              true),
                        ],
                      );
                    },
                  );
                  //print('snapshot.data.id ' + snapshot.data.toString());
                },
              ),
              /*for (int i = 0; i < StaticDataService.personalData.length; i++)
                _getListTile(
                  StaticDataService.personalData[i]['label'],
                  StaticDataService.personalData[i]['value'],
                  StaticDataService.personalData[i]['canChange'],
                ),*/
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {},
                child: ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.signOutAlt,
                    color: Colors.red,
                  ),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
