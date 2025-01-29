import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/Namaz_model.dart';

class PrayerService {
  static Future<NamazTimeModel> fetchPrayerTimings(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=2');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['timings'];
      return NamazTimeModel.fromJson(data);
    } else {
      throw Exception('Failed to load prayer timings');
    }
  }
}
