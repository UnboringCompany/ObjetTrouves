
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchData(String city, String type, String datebefore, String dateafter) async {
  final response = await http.get(Uri.parse('https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records?where=gc_obo_type_c%20%3D%20"$type"%20and%20gc_obo_gare_origine_r_name%20like%20"$city"%20and%20date%20<%20"$dateafter"%20and%20date%20>%20"$datebefore"&limit=20&offset=0&timezone=UTC&include_links=false&include_app_metas=false'));
  print("JSON");
  print(response.body);

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

