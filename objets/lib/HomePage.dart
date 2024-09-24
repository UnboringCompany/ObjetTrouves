import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'API_call.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _initializeLastConnectionDate();
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
      lastConnectionDate = DateTime(2012, 1, 1); // Date par défaut si aucune date n'est trouvée
    }
    print(lastConnectionDate);
    final data = await fetchDataSinceLastConnection(lastConnectionDate.toString());
    await _saveLastConnectionDate(DateTime.now()); // Mettre à jour la date de la dernière connexion après avoir récupéré les données
    return data;
  }

  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('HH:mm dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter API SNCF - Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              Navigator.pushNamed(context, '/filter');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchDataSinceLastConnection(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}'); // Ajoutez ce log pour vérifier les erreurs
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('No data available'); // Ajoutez ce log pour vérifier l'absence de données
            return Center(child: Text('No data available'));
          } else {
            print('Data received: ${snapshot.data}'); // Ajoutez ce log pour vérifier les données reçues
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final record = snapshot.data![index];
                String formattedDate = _formatDate(record['date']);
                String lieuxdate = record['gc_obo_gare_origine_r_name'] + " " + formattedDate;
                return ListTile(
                  title: Text(record['gc_obo_nature_c'] ?? 'No title'),
                  subtitle: Text(lieuxdate),
                );
              },
            );
          }
        },
      ),
    );
  }
}



