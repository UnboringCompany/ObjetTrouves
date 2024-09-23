import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'API_call.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _saveLastConnectionDate();
  }

  Future<void> _saveLastConnectionDate() async {
    await saveLastConnectionDate(DateTime.now());
  }

  Future<List<dynamic>> _fetchDataSinceLastConnection() async {
    DateTime? lastConnectionDate = await getLastConnectionDate();
    if (lastConnectionDate == null) {
      lastConnectionDate = DateTime(2012, 1, 1); // Date par défaut si aucune date n'est trouvée
    }
    return fetchData('Paris', 'Vêtements, chaussures', lastConnectionDate.toString(), DateTime.now().toString());
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
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final record = snapshot.data![index];
                String lieuxdate = record['gc_obo_gare_origine_r_name'] + record['date'];
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

