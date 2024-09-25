import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLastConnectionDate(DateTime date) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('last_connection_date', date.toIso8601String());
}

Future<DateTime?> getLastConnectionDate() async {
  final prefs = await SharedPreferences.getInstance();
  final dateString = prefs.getString('last_connection_date');
  if (dateString != null) {
    return DateTime.parse(dateString);
  }
  return null;
}

Future<List<dynamic>> fetchData(
    String? city, String? type, String datebefore, String dateafter) async {
  String url =
      'https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records?where=date%20<%20"$dateafter"%20and%20date%20>%20"$datebefore"%20and%20gc_obo_date_heure_restitution_c%20is%20null&order_by=date%20desc&limit=50&offset=0&timezone=UTC&include_links=false&include_app_metas=false';
  if (city != '' && type == 'Tous les types') {
    url =
        'https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records?where=gc_obo_gare_origine_r_name%20like%20"$city"%20and%20date%20<%20"$dateafter"%20and%20date%20>%20"$datebefore"%20and%20gc_obo_date_heure_restitution_c%20is%20null&order_by=date%20desc&limit=50&offset=0&timezone=UTC&include_links=false&include_app_metas=false';
  }
  if (city != '' && type != 'Tous les types') {
    url =
        'https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records?where=gc_obo_type_c%20%3D%20"$type"%20and%20gc_obo_gare_origine_r_name%20like%20"$city"%20and%20date%20<%20"$dateafter"%20and%20date%20>%20"$datebefore"%20and%20gc_obo_date_heure_restitution_c%20is%20null&order_by=date%20desc&limit=50&offset=0&timezone=UTC&include_links=false&include_app_metas=false';
  }
  if (city == '' && type != 'Tous les types') {
    url =
        'https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records?where=gc_obo_type_c%20%3D%20"$type"%20and%20date%20<%20"$dateafter"%20and%20date%20>%20"$datebefore"%20and%20gc_obo_date_heure_restitution_c%20is%20null&order_by=date%20desc&limit=50&offset=0&timezone=UTC&include_links=false&include_app_metas=false';
  }
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['results'] != null) {
      return data['results'];
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<dynamic>> fetchDataSinceLastConnection(String datebefore) async {
  final response = await http.get(Uri.parse(
      'https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records?where=date%20>%20"$datebefore"%20and%20gc_obo_date_heure_restitution_c%20is%20null&order_by=date%20desc&limit=50&offset=0&timezone=UTC&include_links=false&include_app_metas=false'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['results'] != null) {
      return data['results'];
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load data');
  }
}
