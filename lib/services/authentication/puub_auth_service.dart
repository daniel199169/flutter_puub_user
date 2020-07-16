import 'package:Puub/models/facebook_user.dart';
import 'package:Puub/models/user.dart';
import 'package:Puub/services/firestore/puub_auth_firestore_service.dart';
import 'package:Puub/services/static/static_data_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PuubAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin _facebookLogin = FacebookLogin();

  facebookLogout() async {
    await _facebookLogin.logOut();
  }

  updateDealOnRadio(bool val,String uid) async {
    print('UID '+uid);
    await Firestore.instance.collection('users').document(uid).updateData({'isDealOn':val});
  }

  updateMessagingToken(String token,String uid) async {
    print('UID '+uid);
    await Firestore.instance.collection('users').document(uid).updateData({'token':token});
  }

  updateShowInKmRadio(bool val,String uid) async {
    await Firestore.instance.collection('users').document(uid).updateData({'showInKm':val});
  }

  twitterLogin() async {
    var twitterLogin = new TwitterLogin(
      consumerKey: StaticDataService.TWITTER_KEY,
      consumerSecret: StaticDataService.TWITTER_SECRET,
    );

    final TwitterLoginResult result = await twitterLogin.authorize();
    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        TwitterSession session = result.session;
        print('USERNAME '+session.username);
        //_sendTokenAndSecretToServer(session.token, session.secret);
        break;
      case TwitterLoginStatus.cancelledByUser:
        print('cancelled by user');
        break;
      case TwitterLoginStatus.error:
        print('Some error is there ' + result.errorMessage);
        break;
    }
  }

  facebookLogin() async {
    final FacebookLoginResult result = await _facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        print('token ${accessToken.token}');
        print('userId ${accessToken.userId}');
        print('expires ${accessToken.expires}');
        print('permissions ${accessToken.permissions}');
        print('declinedPermissions ${accessToken.declinedPermissions}');
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=id,first_name,last_name,birthday&access_token=${accessToken.token}');
        print(graphResponse.body);
        final credential =
            FacebookAuthProvider.getCredential(accessToken: accessToken.token);
        FacebookUser fbUser = FacebookUser.fromString(graphResponse.body);
        if (fbUser.id != null) {
          PuubAuthFirestoreService _fireStoreData =
              PuubAuthFirestoreService(uid: null);
          final AuthResult _result =
              await _auth.signInWithCredential(credential);

          if (_result.user.uid != null) {
            final bool flag = await _fireStoreData.isFacebookUserAlreadyExits(
                id: _result.user.uid);
            print('flag ' + flag.toString());
            if (!flag) {
              await _fireStoreData.addUser(
                id: _result.user.uid,
                title: '',
                firstName: fbUser.first_name,
                lastName: fbUser.last_name,
                email: '',
                phoneNumber: '',
                password: '',
                dob: fbUser.birthday,
                enableMarketingEmail: false,
              );
            }
          }
        }

        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by user');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  User _mapFirebaseUserToPuubUser(FirebaseUser user) {
    print('kareena');
    if (user == null) {
      return null;
    }
    return new User(
        id: user.uid,
        title: null,
        firstName: null,
        lastName: null,
        email: null,
        phoneNumber: null,
        dob: null,
        enableMarketingEmail: null);
    /* _getUser(user.uid).then((value) {
      print('JJJ');
      return value;
    });*/
  }

  Future<User> _getUser(String id) async {
    print('JJJ3');
    return await getCurrentUser(id);
  }

  Future<User> getCurrentUser(String uid) async {
    final _result =
        await Firestore.instance.collection('users').document(uid).get();
    print('_result.documentID ' + _result.documentID.toString());
    final data = _result.data;
    //return new User(id: uid, title: null, firstName: null, lastName: null, email: null, phoneNumber: null, dob: null, enableMarketingEmail: null);
    return User.fromMap(data);
  }

  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged.map((event) {
      return event;
    });
  }

  /*Stream<User> get user {
    return _auth.onAuthStateChanged.map((FirebaseUser user) {
      print("USER_ID" + user.uid.toString());
      if (user == null) {
        return null;
      }
      final _result = await Firestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .getDocuments();
      final data = _result.documents.first.data;
      //return new User(id: user.uid, title: null, firstName: null, lastName: null, email: null, phoneNumber: null, dob: null, enableMarketingEmail: null);
      return User(
        id: data['id'],
        title: data['title'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        email: data['email'],
        phoneNumber: data['phoneNumber'],
        dob: data['dob'],
        enableMarketingEmail: data['enableMarketingEmail'],
      );
    });
  }*/

  Future registerUser({
    @required String title,
    @required String firstName,
    @required String lastName,
    @required String email,
    @required String phoneNumber,
    @required DateTime dob,
    @required String password,
    @required bool enableMarketingEmail,
  }) async {
    try {
      print('title ');
      print('title ' + title);
      print('firstName ' + firstName);
      print('lastName ' + lastName);
      print('email ' + email);
      print('phoneNumber ' + phoneNumber);
      print('dob ' + dob.toString());
      print('password ' + password);
      final PuubAuthFirestoreService _fireStoreData =
          PuubAuthFirestoreService(uid: null);
      final _isuserExits =
          await _fireStoreData.isUsernameEmailAddressExits(email: email);
      print('_isuserExits ' + _isuserExits.toString());
      if (_isuserExits == null) {
        print('Hello');
        AuthResult _result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        print('_result ' + _result.user.uid);
        if (_result.user.uid != null) {
          await _fireStoreData.addUser(
            id: _result.user.uid,
            title: title,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber,
            password: password,
            dob: dob,
            enableMarketingEmail: enableMarketingEmail,
          );
        }
        return null;
      } else {
        print('He');
        return _isuserExits;
      }
    } catch (e) {
      print('error ' + e.toString());
      return null;
    }
  }

  Future<bool> loginWithEmailAndPassword({
    String email,
    String password,
  }) async {
    try {
      AuthResult _result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      if (_result.user.uid != null) {
        return true;
      }
      return false;
    } catch (e) {
      print("error $e");
      return null;
    }
  }

  Future<bool> forgotPassword({
    String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future signOut() async {
    try {
      final bool isFacebookeLoggedIn = await _facebookLogin.isLoggedIn;
      if (isFacebookeLoggedIn) {
        await _facebookLogin.logOut();
      }
      await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
