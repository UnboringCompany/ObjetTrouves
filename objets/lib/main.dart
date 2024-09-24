import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'API_call.dart';
import 'StartPage.dart';
import 'HomePage.dart';
import 'FilteredPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash', // Utiliser la route de démarrage
      routes: {
        '/splash': (context) => SplashScreen(),
        '/': (context) => HomePage(data: const []),
        '/filter': (context) => FilteredPage(),
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fr', 'FR'),
      ],
    );
  }
}
