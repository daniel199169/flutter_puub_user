import 'dart:io';

import 'package:Puub/services/static/static_data_service.dart';
import 'package:Puub/services/storage/puub_firestore_service.dart';
import 'package:Puub/services/storage/puub_firestore_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PuubSettingVerifiedUser extends StatefulWidget {
  @override
  _PuubSettingVerifiedUserState createState() =>
      _PuubSettingVerifiedUserState();
}

class _PuubSettingVerifiedUserState extends State<PuubSettingVerifiedUser> {
  File _image;
  Widget _getAvatar() {
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
                avatarReference,
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

  Widget _getHeader(BuildContext context, String url) {
    return Stack(
      fit: StackFit.passthrough,
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          height: 224,
          width: double.infinity,
          child: SizedBox.shrink(),
        ),
        Positioned(
          left: 30,
          right: 30,
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.verified_user,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Verified Student',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                _getAvatar(),
                SizedBox(
                  height: 10,
                ),
                /*GestureDetector(
                  onTap: () => print('Helloooooo'),
                  child: Text('Add/Edit Profile3 Picture'),
                ),*/
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDialog(BuildContext context) {
    print('GHTYUI');
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

  Future<void> _chooseAvatar(BuildContext context) async {
    print('LALALALALA');
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

  Widget _getLine(String data, bool flag) {
    return Center(
      child: Container(
        child: flag
            ? GestureDetector(
                onTap: () {},
                child: Text(
                  data,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              )
            : Text(
                data,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _getVerifiedDetails(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < StaticDataService.verifyData.length; i++)
            Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                _getLine(
                  StaticDataService.verifyData[i]['label'],
                  StaticDataService.verifyData[i]['isLink'],
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _getHeader(
            context, 'https://s.hs-data.com/bilder/spieler/gross/13029.jpg'),
        SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: () => _chooseAvatar(context),
          child: Text('Add/Edit Profile Picture'),
        ),
        SizedBox(
          height: 40,
        ),
        _getVerifiedDetails(context),
      ],
    );
  }
}
