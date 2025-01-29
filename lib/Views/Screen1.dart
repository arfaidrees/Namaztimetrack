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
  String currentTime = '';
  String currentDate = '';

  @override
  void initState() {
    super.initState();
    viewModel.fetchTimings(32.4945, 74.5229);
    updateTime();
  }

  void updateTime() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        currentTime = DateFormat('hh:mm:ss a').format(now);
        // Format date as day-month (e.g., 29 Jan)
        currentDate = DateFormat('dd MMM').format(now);
      });
    });
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
                colors: [Colors.blue.shade900, Colors.amber.shade400],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),


          Obx(() {
            final timings = viewModel.prayerTimes.value;

            if (timings.fajr.isEmpty) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(4, 6),
                            ),
                          ],
                          border: Border.all(color: Colors.white.withOpacity(0.5)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentDate,
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              currentTime,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'].map((prayer) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.grey.withOpacity(0.2), Colors.white.withOpacity(0.05)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Prayer Name
                              Text(
                                prayer,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                timings.toJson()[prayer] ?? '',
                                style: const TextStyle(fontSize: 18, color: Colors.white70),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Azan: ${timings.toJson()['${prayer}_azan'] ?? 'Not Available'}',
                                style: const TextStyle(fontSize: 16, color: Colors.white60),
                              ),
                              Text(
                                'Iqamah: ${timings.toJson()['${prayer}_iqamah'] ?? 'Not Available'}',
                                style: const TextStyle(fontSize: 16, color: Colors.white60),
                              ),
                            ],
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
