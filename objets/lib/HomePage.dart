import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  final List data; // Reçu de la page précédente

  HomePage({required this.data}); // Constructeur pour recevoir les données

  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('HH:mm dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2E2E),
      appBar: AppBar(
        title: const Text(
          'SNCF Objets Trouvés',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF2E2E2E),
      ),
      body: Column(
        children: <Widget>[
          // Ajout de Expanded pour permettre à ListView de prendre tout l'espace disponible
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final record = data[index];
                String formattedDate = _formatDate(record['date']);
                String lieuxdate =
                    record['gc_obo_gare_origine_r_name'] + " " + formattedDate;
                return ListTile(
                  title: Text(
                    record['gc_obo_nature_c'] ?? 'No title',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    lieuxdate,
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Les Derniers Objets Perdus Sont Retrouvés',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
