import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'FilteredPage.dart';

class HomePage extends StatelessWidget {
  final List data;

  HomePage({required this.data});

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Date inconnue';
    DateTime date = DateTime.parse(dateString);
    return DateFormat('HH:mm dd/MM/yyyy').format(date);
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
          const SizedBox(height: 30),
          const Text(
            'Les Derniers Objets Perdus Sont Retrouvés',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Expanded(
            child: data.isNotEmpty
                ? ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final record = data[index];
                      String gareOrigine =
                          record['gc_obo_gare_origine_r_name'] ??
                              'Gare inconnue';
                      String formattedDate = record['date'] != null
                          ? _formatDate(record['date'])
                          : 'Date inconnue';
                      String lieuxdate = gareOrigine + " " + formattedDate;

                      return ListTile(
                        title: Text(
                          record['gc_obo_nature_c'] ?? 'No title',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          lieuxdate,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          color: Colors.white,
                          size: 80,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Aucun objet n'a été retrouvé depuis la dernière connexion",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 30),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilteredPage()),
                );
              },
              child: const Text(
                'CHERCHER UN OBJET PRÉCIS',
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
