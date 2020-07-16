import 'package:Puub/models/user.dart';
import 'package:Puub/services/authentication/puub_auth_service.dart';
import 'package:Puub/services/firestore/puub_auth_firestore_service.dart';
import 'package:Puub/services/storage/puub_firestore_service.dart';
import 'package:Puub/services/storage/puub_firestore_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PuubWrapperBuilder extends StatelessWidget {
  const PuubWrapperBuilder({Key key, @required this.builder}) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<FirebaseUser>) builder;
  @override
  Widget build(BuildContext context) {
    print('PuubWrapper rebuild');
    final authService = Provider.of<PuubAuthService>(context, listen: false);
    return StreamBuilder<FirebaseUser>(
      stream: authService.user,
      builder: (context, snapshot) {
        print('StreamBuilder: ${snapshot.connectionState}');
        final FirebaseUser user = snapshot.data;

        if (user != null) {
          return MultiProvider(
            providers: [
              Provider<FirebaseUser>.value(value: user),
              Provider<PuubAuthFirestoreService>(
                create: (_) => PuubAuthFirestoreService(uid: user.uid),
              ),
              Provider<PuubFirestoreAvatarService>(
                create: (_) => PuubFirestoreAvatarService(uid: user.uid),
              ),
              Provider<PuubFirestoreStorageService>(
                create: (_) => PuubFirestoreStorageService(uid: user.uid),
              ),
            ],
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}
