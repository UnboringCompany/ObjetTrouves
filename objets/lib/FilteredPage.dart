import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:objets/HomePage.dart';
import 'API_call.dart';

class FilteredPage extends StatefulWidget {
  const FilteredPage({super.key});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilteredPage> {
  String _selectedGare = ''; // Valeur par défaut
  String _selectedType = 'Tous les types'; // Valeur par défaut
  DateTime? _selectedDateBefore = DateTime(2012, 1, 1);
  DateTime? _selectedDateAfter = DateTime.now();

  final List<String> _types = [
    'Vêtements, chaussures',
    'Optique',
    'Appareils électroniques, informatiques, appareils photo',
    'Tous les types',
  ];

  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('HH:mm dd/MM/yyyy').format(date);
  }

  Future<void> _selectDate(BuildContext context, DateTime? initialDate,
      Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('fr', 'FR'), // Utiliser le format français
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2E2E),
        title: Row(
          children: <Widget>[
            Container(
              constraints: const BoxConstraints(
                maxHeight: 45,
                maxWidth: 80,
              ),
              child: Image.asset(
                'assets/sncf.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'OBJETS TROUVÉS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          const Text(
            'TROUVER UN OBJET PRÉCIS',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  // Zone des filtres
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD3D3D3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Filtres',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration: const InputDecoration(
                              labelText: 'Gare d\'origine'),
                          onChanged: (value) {
                            setState(() {
                              _selectedGare = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedType,
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
                        const SizedBox(height: 10),
                        TextField(
                          decoration: const InputDecoration(
                              labelText: 'De ... (dd/MM/yyyy)'),
                          onTap: () async {
                            await _selectDate(context, _selectedDateBefore,
                                (picked) {
                              setState(() {
                                _selectedDateBefore = picked;
                              });
                            });
                          },
                          controller: TextEditingController(
                            text: _selectedDateBefore != null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(_selectedDateBefore!)
                                : '',
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration: const InputDecoration(
                              labelText: 'A ... (dd/MM/yyyy)'),
                          onTap: () async {
                            await _selectDate(context, _selectedDateAfter,
                                (picked) {
                              setState(() {
                                _selectedDateAfter = picked;
                              });
                            });
                          },
                          controller: TextEditingController(
                            text: _selectedDateAfter != null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(_selectedDateAfter!)
                                : '',
                          ),
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Résultat des objets filtrés
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD3D3D3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FutureBuilder<List<dynamic>>(
                        future: fetchData(
                            _selectedGare,
                            _selectedType,
                            _selectedDateBefore.toString(),
                            _selectedDateAfter.toString()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No data available'));
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                final record = snapshot.data![index];
                                String gareOrigine =
                                    record['gc_obo_gare_origine_r_name'] ??
                                        'Gare inconnue';
                                String date = record['date'] != null
                                    ? _formatDate(record['date'])
                                    : 'Date inconnue';
                                String lieuxdate = gareOrigine + " " + date;

                                return ListTile(
                                  title: Text(
                                      record['gc_obo_nature_c'] ?? 'No title'),
                                  subtitle: Text(lieuxdate),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFB71C1C), Color(0xFF8B0000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(data: const []),
                  ),
                );
              },
              child: const Text(
                'RETOURNER À L\'ACCUEIL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
