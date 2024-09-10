
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchData() async {
  final response = await http.get(Uri.parse('https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records?where="Paris"&order_by=date%20desc&limit=10&offset=0&timezone=UTC&include_links=false&include_app_metas=false'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print(data); 
    if (data['results'] != null) {
      return data['results'];
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load data');
  }
}

