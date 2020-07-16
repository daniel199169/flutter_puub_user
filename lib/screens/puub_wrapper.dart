import 'package:Puub/models/user.dart';
import 'package:Puub/screens/private/home_wrapper.dart';
import 'package:Puub/screens/public/welcome_screen.dart';
import 'package:Puub/services/firestore/puub_auth_firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PuubWrapper extends StatelessWidget {
  const PuubWrapper({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<FirebaseUser> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot == null) {
      
      return WelcomeScreen();
    } else if(userSnapshot.connectionState == ConnectionState.active && userSnapshot.data == null){
      return WelcomeScreen();
    }else if (userSnapshot.connectionState == ConnectionState.active) {
      final userService =
          Provider.of<PuubAuthFirestoreService>(context, listen: false);
      return StreamBuilder<User>(
        stream: userService.puubHero,
        builder: (context, snapshot) {
          return userSnapshot.hasData ? HomeWrapper(uid: userSnapshot.data.uid,) : WelcomeScreen();
        },
      );
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
