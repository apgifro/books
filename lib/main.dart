import 'package:books/view/login_with_email_screen.dart';
import 'package:books/view/register_with_email_screen.dart';
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
          initialRoute: '/welcome',
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/welcome':
                return MaterialPageRoute(builder: (context) => WelcomeScreen());
              case '/registerWithEmail':
                return MaterialPageRoute(builder: (context) => RegisterWithEmailScreen());
              case '/registerWithEmail':
                return MaterialPageRoute(builder: (context) => RegisterWithEmailScreen());
              case '/loginWithEmail':
                return MaterialPageRoute(builder: (context) => LoginWithEmailScreen());
            }
          })));
}

