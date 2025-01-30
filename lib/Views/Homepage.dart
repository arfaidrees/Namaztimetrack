import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../Viewmodel/namaz_viewmodel.dart';

class PrayerPage extends StatefulWidget {
  @override
  _PrayerPageState createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  final PrayerViewModel viewModel = Get.put(PrayerViewModel());
  String currentDate = '';
  String countdown = 'Fetching...';

  @override
  void initState() {
    super.initState();
    viewModel.fetchTimings(32.4945, 74.5229);
    updateCountdown();
  }

  void updateCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentDate = DateFormat('dd MMM').format(DateTime.now());
        countdown = findCountdown();
      });
    });
  }

  /// Finds the countdown to the next upcoming prayer
  String findCountdown() {
    final now = DateTime.now();
    final timings = viewModel.prayerTimes.value;

    if (timings.fajr.isEmpty) return 'Fetching...';

    final Map<String, String> prayers = {
      'Fajr': timings.fajr,
      'Dhuhr': timings.dhuhr,
      'Asr': timings.asr,
      'Maghrib': timings.maghrib,
      'Isha': timings.isha,
    };

    DateTime? nextPrayerTime;
    String nextPrayerName = 'Fajr';

    for (var entry in prayers.entries) {
      DateTime prayerTime = parseTime(entry.value);
      if (prayerTime.isAfter(now)) {
        nextPrayerTime = prayerTime;
        nextPrayerName = entry.key;
        break;
      }
    }

    if (nextPrayerTime == null) {

      return 'Not soon';
    }

    final difference = nextPrayerTime.difference(now);
    return formatDuration(difference, nextPrayerName);
  }


  String formatDuration(Duration duration, String prayerName) {
    String hours = duration.inHours.toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$prayerName in $hours:$minutes:$seconds';
  }

  DateTime parseTime(String time) {
    final now = DateTime.now();
    final format = DateFormat('hh:mm a');
    try {
      return format.parse(time).copyWith(year: now.year, month: now.month, day: now.day);
    } catch (e) {
      return now;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.grey.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Obx(() {
            final timings = viewModel.prayerTimes.value;

            if (timings.fajr.isEmpty) {
              return const Center(child: CircularProgressIndicator(color: Colors.orangeAccent));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  countdown,
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orangeAccent,
                                    letterSpacing: 1.5,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10,
                                        color: Colors.black26,
                                        offset: Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Text(
                                    "$currentDate",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),
                      ...['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'].map((prayer) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.2)),
                              ),
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8), // Adjust width here
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        prayer,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orangeAccent,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      Text(
                                        timings.toJson()[prayer] ?? '',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Azan: ${timings.toJson()['${prayer}Azan']}',
                                          style: const TextStyle(color: Colors.white70, fontSize: 16)),
                                      Text('Iqamah: ${timings.toJson()['${prayer}Iqamah']}',
                                          style: const TextStyle(color: Colors.white70, fontSize: 16)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
