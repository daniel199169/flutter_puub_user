import 'package:Puub/screens/puub_wrapper.dart';
import 'package:Puub/screens/puub_wrapper_builder.dart';
import 'package:Puub/services/authentication/puub_auth_service.dart';
import 'package:Puub/styles/puub_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PuubAuthService>(
          create: (_) => PuubAuthService(),
        ),
      ],
      child: PuubWrapperBuilder(
        builder: (context, userSnapshot) {
          return MaterialApp(
            theme: PuubTheme.lightTheme,
            home: PuubWrapper(userSnapshot: userSnapshot),
          );
        },
      ),
    );
  }
}
