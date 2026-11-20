import 'package:flutter/material.dart';
import 'typing_models.dart';

enum WorldId {
  meadow_of_letters,
  forest_of_words,
  rainbow_bridge,
  castle_of_stories,
  sentence_safari,
  paragraph_paradise,
  creative_writing,
  champion_world,
}

class WorldInfo {
  final WorldId id;
  final String title;
  final String subtitle;
  final String description;
  final String icon;
  final String activityType;
  final StageId stageId;
  final int baseTargetCount;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final String companionQuote;

  const WorldInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.activityType,
    required this.stageId,
    required this.baseTargetCount,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
    required this.companionQuote,
  });
}
