import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../Model/Namaz_model.dart';

class PrayerService {
  static Future<NamazTimeModel> fetchPrayerTimings(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=2');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['timings'];

      return NamazTimeModel(
        fajr: data["Fajr"],
        fajrAzan: data["Fajr"],
        fajrIqamah: _adjustTime(data["Fajr"], 10),

        dhuhr: data["Dhuhr"],
        dhuhrAzan: data["Dhuhr"],
        dhuhrIqamah: _adjustTime(data["Dhuhr"], 10),

        asr: data["Asr"],
        asrAzan: data["Asr"],
        asrIqamah: _adjustTime(data["Asr"], 10),

        maghrib: data["Maghrib"],
        maghribAzan: data["Maghrib"],
        maghribIqamah: _adjustTime(data["Maghrib"], 10),

        isha: data["Isha"],
        ishaAzan: data["Isha"],
        ishaIqamah: _adjustTime(data["Isha"], 10),
      );
    } else {
      throw Exception('Failed to load prayer timings');
    }
  }

  static String _adjustTime(String time, int minutes) {
    final parsedTime = DateFormat('HH:mm').parse(time);
    final adjustedTime = parsedTime.add(Duration(minutes: minutes));
    return DateFormat('HH:mm').format(adjustedTime);
  }
}


