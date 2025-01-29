import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Model/Namaz_model.dart';
import '../Service/namaz_service.dart';

class PrayerViewModel extends GetxController {
  var prayerTimes = NamazTimeModel(
    fajr: '',
    dhuhr: '',
    asr: '',
    maghrib: '',
    isha: '',
  ).obs;

  var nextPrayer = ''.obs;
  var countdown = ''.obs;

  void fetchTimings(double latitude, double longitude) async {
    try {
      var timings = await PrayerService.fetchPrayerTimings(latitude, longitude);

      // Format prayer times in 12-hour AM/PM format
      prayerTimes.value = NamazTimeModel(
        fajr: _formatTime(timings.fajr),
        dhuhr: _formatTime(timings.dhuhr),
        asr: _formatTime(timings.asr),
        maghrib: _formatTime(timings.maghrib),
        isha: _formatTime(timings.isha),
      );

      updateNextPrayer();
    } catch (e) {
      print('Error fetching prayer timings: $e');
    }
  }

  void updateNextPrayer() {
    final now = DateTime.now();
    final times = {
      'Fajr': _parseTime(prayerTimes.value.fajr),
      'Dhuhr': _parseTime(prayerTimes.value.dhuhr),
      'Asr': _parseTime(prayerTimes.value.asr),
      'Maghrib': _parseTime(prayerTimes.value.maghrib),
      'Isha': _parseTime(prayerTimes.value.isha),
    };

    for (var entry in times.entries) {
      if (now.isBefore(entry.value)) {
        nextPrayer.value = entry.key;
        countdown.value = _calculateCountdown(now, entry.value);
        break;
      }
    }
  }

  String _calculateCountdown(DateTime now, DateTime prayerTime) {
    final duration = prayerTime.difference(now);
    return '${duration.inHours}:${duration.inMinutes.remainder(60)}';
  }

  String _formatTime(String time) {
    final parsedTime = DateFormat('HH:mm').parse(time);
    return DateFormat('hh:mm a').format(parsedTime);
  }

  DateTime _parseTime(String time) {
    return DateFormat('hh:mm a').parse(time);
  }

  void adjustTiming(String prayer, int minutes) {
    final timings = prayerTimes.value;

    final updatedTimings = NamazTimeModel(
      fajr: prayer == 'Fajr' ? _adjustTime(timings.fajr, minutes) : timings.fajr,
      dhuhr: prayer == 'Dhuhr' ? _adjustTime(timings.dhuhr, minutes) : timings.dhuhr,
      asr: prayer == 'Asr' ? _adjustTime(timings.asr, minutes) : timings.asr,
      maghrib: prayer == 'Maghrib' ? _adjustTime(timings.maghrib, minutes) : timings.maghrib,
      isha: prayer == 'Isha' ? _adjustTime(timings.isha, minutes) : timings.isha,
    );

    prayerTimes.value = updatedTimings;
    updateNextPrayer();
  }

  String _adjustTime(String time, int minutes) {
    final parsedTime = _parseTime(time);
    final adjustedTime = parsedTime.add(Duration(minutes: minutes));
    return DateFormat('hh:mm a').format(adjustedTime);
  }
}