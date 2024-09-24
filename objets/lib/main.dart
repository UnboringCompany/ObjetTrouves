import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Objet trouvés SNCF',
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
