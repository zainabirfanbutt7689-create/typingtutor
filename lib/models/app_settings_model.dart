import 'companion_model.dart';

class AppSettings {
  bool soundEnabled;
  double soundVolume;
  bool ttsEnabled;
  bool reducedMotion;
  bool largeText;
  bool highContrast;
  bool showFingerGuides;
  bool showUrduHints;
  CompanionId companionId;

  AppSettings({
    this.soundEnabled = true,
    this.soundVolume = 0.8,
    this.ttsEnabled = true,
    this.reducedMotion = false,
    this.largeText = false,
    this.highContrast = false,
    this.showFingerGuides = true,
    this.showUrduHints = false,
    this.companionId = CompanionId.bisma,
  });

  Map<String, dynamic> toJson() => {
    'soundEnabled': soundEnabled,
    'soundVolume': soundVolume,
    'ttsEnabled': ttsEnabled,
    'reducedMotion': reducedMotion,
    'largeText': largeText,
    'highContrast': highContrast,
    'showFingerGuides': showFingerGuides,
    'showUrduHints': showUrduHints,
    'companionId': companionId.name,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    soundEnabled: json['soundEnabled'] ?? true,
    soundVolume: (json['soundVolume'] as num?)?.toDouble() ?? 0.8,
    ttsEnabled: json['ttsEnabled'] ?? true,
    reducedMotion: json['reducedMotion'] ?? false,
    largeText: json['largeText'] ?? false,
    highContrast: json['highContrast'] ?? false,
    showFingerGuides: json['showFingerGuides'] ?? true,
    showUrduHints: json['showUrduHints'] ?? false,
    companionId: CompanionId.values.firstWhere(
      (c) => c.name == json['companionId'],
      orElse: () => CompanionId.bisma,
    ),
  );
}
