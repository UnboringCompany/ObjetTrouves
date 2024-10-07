import 'dart:async';
import 'package:flutter/material.dart';
import 'package:objets/API_call.dart';
import 'package:objets/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<dynamic> apiResult = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initializeLastConnectionDate();
    _loadData();
    _playSound();
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
      lastConnectionDate = DateTime(2012, 1, 1);
    }
    print(lastConnectionDate);
    final data =
        await fetchDataSinceLastConnection(lastConnectionDate.toString());
    await _saveLastConnectionDate(DateTime.now());
    return data;
  }

  Future<void> _loadData() async {
    List result = await _fetchDataSinceLastConnection();
    setState(() {
      apiResult = result;
    });

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(data: apiResult),
        ),
      );
    });
  }

  void _playSound() async {
    await _audioPlayer.play(AssetSource('sifflement.mp3'));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2E2E),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/sncf.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            const SizedBox(width: 10),
            const Text(
              'OBJETS TROUVÉS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Image.asset('assets/thomas-and.gif'),
      ),
    );
  }
}
