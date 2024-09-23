import 'package:flutter/material.dart';
import 'API_call.dart';

class FilteredPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilteredPage> {
  String _selectedGare = 'Paris'; // Valeur par défaut
  String _selectedType = 'Vêtements, chaussures';
  DateTime? _selectedDateBefore = DateTime(2012,1,1);
  DateTime? _selectedDateAfter = DateTime.now();

  final List<String> _types = [
    'Vêtements, chaussures',
    'Optique',
    'Appareils électroniques, informatiques, appareils photo',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter API SNCF - Filters'),
      ),
      body: Column(
        children: [
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedType.isEmpty ? null : _selectedType,
                    hint: Text('Type d\'objet'),
                    items: _types.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'De ... (YYYY-MM-DD)'),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDateBefore = picked;
                  });
                }
              },
              controller: TextEditingController(
                text: _selectedDateBefore != null
                    ? _selectedDateBefore!.toLocal().toString().split(' ')[0]
                    : '',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'A ... (YYYY-MM-DD)'),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDateAfter = picked;
                  });
                }
              },
              controller: TextEditingController(
                text: _selectedDateAfter != null
                    ? _selectedDateAfter!.toLocal().toString().split(' ')[0]
                    : '',
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: fetchData(_selectedGare, _selectedType, _selectedDateBefore.toString(), _selectedDateAfter.toString()),
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
                      String lieuxdate = record['gc_obo_gare_origine_r_name'] + " " + record['date'];
                      return ListTile(
                        title: Text(record['gc_obo_nature_c'] ?? 'No title'),
                        subtitle: Text(lieuxdate),
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

