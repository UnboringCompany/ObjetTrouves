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
