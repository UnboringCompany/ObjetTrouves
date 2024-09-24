import 'package:flutter/material.dart';
import 'package:objets/API_call.dart';
import 'package:objets/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  List<dynamic> apiResult = [];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/thomas-and.gif')
      ..initialize().then((_) {
        setState(
            () {}); // Assurez-vous que le widget est reconstruit lorsque la vidéo est prête
        _controller.play();
        _controller.setLooping(true); // Boucler la vidéo
      });
    _initializeLastConnectionDate();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _initializeLastConnectionDate() async {
    DateTime? lastConnectionDate = await getLastConnectionDate();
    if (lastConnectionDate == null) {
      await saveLastConnectionDate(DateTime.now());
    }
  }

  Future<void> _saveLastConnectionDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastConnectionDate', date.toIso8601String());
  }

  Future<DateTime?> getLastConnectionDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString('lastConnectionDate');
    if (dateString != null) {
      return DateTime.parse(dateString);
    }
    return null;
  }

  Future<List<dynamic>> _fetchDataSinceLastConnection() async {
    DateTime? lastConnectionDate = await getLastConnectionDate();
    if (lastConnectionDate == null) {
      lastConnectionDate =
          DateTime(2012, 1, 1); // Date par défaut si aucune date n'est trouvée
    }
    print(lastConnectionDate);
    final data =
        await fetchDataSinceLastConnection(lastConnectionDate.toString());
    await _saveLastConnectionDate(DateTime
        .now()); // Mettre à jour la date de la dernière connexion après avoir récupéré les données
    return data;
  }

  Future<void> _loadData() async {
    // Appel de la fonction qui fait la requête API depuis API_call.dart
    List result =
        await _fetchDataSinceLastConnection(); // Remplacer par ta vraie méthode
    setState(() {
      apiResult = result; // Stocker le résultat de la requête
    });

    // Après réception des données, naviguer vers HomePage et passer le résultat
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            HomePage(data: apiResult), // Passage des données à HomePage
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2E2E),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2E2E), // Couleur de fond sombre
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/sncf.png', // Chemin vers l'image
              fit: BoxFit.contain,
              height: 32, // Ajuste la hauteur de l'image
            ),
            const SizedBox(width: 10), // Espace entre l'image et le texte
            const Text(
              'OBJETS TROUVÉS',
              style: TextStyle(
                color: Colors.white,
                fontSize:
                    20, // Ajuste la taille du texte// Ajoute une police si tu en as une
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
