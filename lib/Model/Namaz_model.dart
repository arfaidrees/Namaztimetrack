class NamazTimeModel {
  final String fajr, dhuhr, asr, maghrib, isha;
  final String fajrAzan, dhuhrAzan, asrAzan, maghribAzan, ishaAzan;
  final String fajrIqamah, dhuhrIqamah, asrIqamah, maghribIqamah, ishaIqamah;

  NamazTimeModel({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.fajrAzan,
    required this.dhuhrAzan,
    required this.asrAzan,
    required this.maghribAzan,
    required this.ishaAzan,
    required this.fajrIqamah,
    required this.dhuhrIqamah,
    required this.asrIqamah,
    required this.maghribIqamah,
    required this.ishaIqamah,
  });

  /// Convert NamazTimeModel to a JSON-like Map
  Map<String, String> toJson() {
    return {
      'Fajr': fajr,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Maghrib': maghrib,
      'Isha': isha,
      'FajrAzan': fajrAzan,
      'DhuhrAzan': dhuhrAzan,
      'AsrAzan': asrAzan,
      'MaghribAzan': maghribAzan,
      'IshaAzan': ishaAzan,
      'FajrIqamah': fajrIqamah,
      'DhuhrIqamah': dhuhrIqamah,
      'AsrIqamah': asrIqamah,
      'MaghribIqamah': maghribIqamah,
      'IshaIqamah': ishaIqamah,
    };
  }
}
