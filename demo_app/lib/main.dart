import 'package:demo_app/models/tools.dart';
import 'package:demo_app/models/user.dart';
import 'package:demo_app/pages/favourite_page.dart';
import 'package:demo_app/pages/intro.dart';
import 'package:demo_app/services/auth.dart';
import 'package:demo_app/services/database.dart';
import 'package:demo_app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyAYWABaFyw5KfhGn4xTBJRrhxddrsI3msE",
    appId: "1:514232267350:android:809f8f5841bb06d16f41f7",
    projectId: "fir-app-35800",
    messagingSenderId: "",
  ));

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider()..init(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Favourite(),
        ),
        StreamProvider<myUser?>.value(
          value: AuthService().user,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: IntroPage(),
        theme: Provider.of<ThemeProvider>(context).themeData,
      ),
    );
  }
}
