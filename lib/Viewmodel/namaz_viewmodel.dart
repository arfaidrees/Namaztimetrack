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
    fajrAzan: '',
    dhuhrAzan: '',
    asrAzan: '',
    maghribAzan: '',
    ishaAzan: '',
    fajrIqamah: '',
    dhuhrIqamah: '',
    asrIqamah: '',
    maghribIqamah: '',
    ishaIqamah: '',
  ).obs;

  var nextPrayer = ''.obs;
  var countdown = ''.obs;

  /// Fetch prayer timings from API and update prayerTimes
  void fetchTimings(double latitude, double longitude) async {
    try {
      var timings = await PrayerService.fetchPrayerTimings(latitude, longitude);

      prayerTimes.value = NamazTimeModel(
        fajr: _formatTime(timings.fajr),
        fajrAzan: _formatTime(timings.fajrAzan),
        fajrIqamah: _formatTime(timings.fajrIqamah),

        dhuhr: _formatTime(timings.dhuhr),
        dhuhrAzan: _formatTime(timings.dhuhrAzan),
        dhuhrIqamah: _formatTime(timings.dhuhrIqamah),

        asr: _formatTime(timings.asr),
        asrAzan: _formatTime(timings.asrAzan),
        asrIqamah: _formatTime(timings.asrIqamah),

        maghrib: _formatTime(timings.maghrib),
        maghribAzan: _formatTime(timings.maghribAzan),
        maghribIqamah: _formatTime(timings.maghribIqamah),

        isha: _formatTime(timings.isha),
        ishaAzan: _formatTime(timings.ishaAzan),
        ishaIqamah: _formatTime(timings.ishaIqamah),
      );

      updateNextPrayer();
    } catch (e) {
      print('Error fetching prayer timings: $e');
    }
  }

  /// Determines the next prayer and calculates countdown
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

  /// Calculates time remaining until next prayer
  String _calculateCountdown(DateTime now, DateTime prayerTime) {
    final duration = prayerTime.difference(now);
    return '${duration.inHours}:${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}';
  }

  /// Formats time from 24-hour to 12-hour format (e.g., 14:30 → 02:30 PM)
  String _formatTime(String time) {
    try {
      final parsedTime = DateFormat('HH:mm').parse(time);
      return DateFormat('hh:mm a').format(parsedTime);
    } catch (e) {
      return time; // Return original if formatting fails
    }
  }

  /// Parses time string into DateTime for calculations
  DateTime _parseTime(String time) {
    try {
      return DateFormat('hh:mm a').parse(time);
    } catch (e) {
      return DateTime.now(); // Fallback to current time if parsing fails
    }
  }

  /// Adjusts a specific prayer time by given minutes
  void adjustTiming(String prayer, int minutes) {
    final timings = prayerTimes.value;

    final updatedTimings = NamazTimeModel(
      fajr: prayer == 'Fajr' ? _adjustTime(timings.fajr, minutes) : timings.fajr,
      dhuhr: prayer == 'Dhuhr' ? _adjustTime(timings.dhuhr, minutes) : timings.dhuhr,
      asr: prayer == 'Asr' ? _adjustTime(timings.asr, minutes) : timings.asr,
      maghrib: prayer == 'Maghrib' ? _adjustTime(timings.maghrib, minutes) : timings.maghrib,
      isha: prayer == 'Isha' ? _adjustTime(timings.isha, minutes) : timings.isha,
      fajrAzan: timings.fajrAzan,
      dhuhrAzan: timings.dhuhrAzan,
      asrAzan: timings.asrAzan,
      maghribAzan: timings.maghribAzan,
      ishaAzan: timings.ishaAzan,
      fajrIqamah: timings.fajrIqamah,
      dhuhrIqamah: timings.dhuhrIqamah,
      asrIqamah: timings.asrIqamah,
      maghribIqamah: timings.maghribIqamah,
      ishaIqamah: timings.ishaIqamah,
    );

    prayerTimes.value = updatedTimings;
    updateNextPrayer();
  }

  /// Adjusts a given time by minutes
  String _adjustTime(String time, int minutes) {
    final parsedTime = _parseTime(time);
    final adjustedTime = parsedTime.add(Duration(minutes: minutes));
    return DateFormat('hh:mm a').format(adjustedTime);
  }
}
