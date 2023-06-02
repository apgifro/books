import 'package:books/view/account_screen.dart';
import 'package:books/view/book_screen.dart';
import 'package:books/view/check_email_screen.dart';
import 'package:books/view/discover_screen.dart';
import 'package:books/view/navigation_screen.dart';
import 'package:books/view/login_screen.dart';
import 'package:books/view/recover_screen.dart';
import 'package:books/view/register_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'package:books/view/welcome_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(DevicePreview(
      enabled: true,
      builder: (BuildContext context) => MaterialApp(
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: (context, child) {
            child = DevicePreview.appBuilder(context, child);
            child = EasyLoading.init()(context, child);
            return child;
          },
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: const Color(0x63B9FF),
            useMaterial3: true,
          ),
          initialRoute: FirebaseAuth.instance.currentUser != null ? '/home' : '/welcome',
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/welcome':
                return MaterialPageRoute(builder: (context) => WelcomeScreen());
              case '/registerWithEmail':
                return MaterialPageRoute(builder: (context) => RegisterWithEmailScreen());
              case '/checkYourEmail':
                return MaterialPageRoute(builder: (context) => CheckYourEmailScreen());
              case '/recoverWithEmail':
                return MaterialPageRoute(builder: (context) => RecoverWithEmailScreen());
              case '/loginWithEmail':
                return MaterialPageRoute(builder: (context) => LoginWithEmailScreen());
              case '/home':
                return MaterialPageRoute(builder: (context) => NavigationScreen());
              case '/book':
                return MaterialPageRoute(builder: (context) => BookScreen());
              case '/account':
                return MaterialPageRoute(builder: (context) => AccountScreen());
            }
          })));
}

