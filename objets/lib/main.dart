import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'API_call.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedType = '';
  String _selectedGare = '';

  List<dynamic> _filterData(List<dynamic> data) {
    return data.where((record) {
      final type = record['gc_obo_type_c'] ?? '';
      final gare = record['gc_obo_gare_origine_r_name'] ?? '';
      return (_selectedType.isEmpty || type.contains(_selectedType)) &&
             (_selectedGare.isEmpty || gare.contains(_selectedGare));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter API Example'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'Type d\'objet'),
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'Gare d\'origine'),
              onChanged: (value) {
                setState(() {
                  _selectedGare = value;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  final filteredData = _filterData(snapshot.data!);
                  return ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final record = filteredData[index];
                      return ListTile(
                        title: Text(record['gc_obo_gare_origine_r_name'] ?? 'No title'),
                        subtitle: Text(record['gc_obo_nature_c'] ?? 'No description'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}




