import 'package:flutter/material.dart';

enum CompanionId {
  bisma,
  pip,
  sparky,
  buzzy,
  ollie,
}

class Companion {
  final CompanionId id;
  final String name;
  final String species;
  final String tagline;
  final String emoji;
  final Color accentColor;
  final Color avatarBgColor;
  final String svgAssetPath;

  const Companion({
    required this.id,
    required this.name,
    required this.species,
    required this.tagline,
    required this.emoji,
    required this.accentColor,
    required this.avatarBgColor,
    required this.svgAssetPath,
  });
}
