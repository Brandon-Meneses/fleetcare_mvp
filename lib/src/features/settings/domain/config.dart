class AppConfig {
  final int kmThreshold;      // ej. 10000
  final int monthsThreshold;  // ej. 6

  const AppConfig({required this.kmThreshold, required this.monthsThreshold});

  AppConfig copyWith({int? kmThreshold, int? monthsThreshold}) => AppConfig(
    kmThreshold: kmThreshold ?? this.kmThreshold,
    monthsThreshold: monthsThreshold ?? this.monthsThreshold,
  );

  static const defaults = AppConfig(kmThreshold: 10000, monthsThreshold: 6);
}