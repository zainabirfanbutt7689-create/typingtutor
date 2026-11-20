import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();
  static bool isMuted = false;
  static double volume = 0.8;

  static Future<void> init() async {
    try {
      await _player.setReleaseMode(ReleaseMode.stop);
      await _player.setVolume(volume);
    } catch (_) {}
  }

  static void setMuted(bool muted) {
    isMuted = muted;
    try {
      if (muted) {
        _player.setVolume(0);
      } else {
        _player.setVolume(volume);
      }
    } catch (_) {}
  }

  static void setVolume(double vol) {
    volume = vol.clamp(0.0, 1.0);
    try {
      if (!isMuted) {
        _player.setVolume(volume);
      }
    } catch (_) {}
  }

  static Future<void> playCorrect() async {
    if (isMuted) return;
    try {
      HapticFeedback.lightImpact();
      await _player.stop();
      await _player.play(AssetSource('sounds/pop.wav'), volume: volume);
    } catch (_) {
      HapticFeedback.selectionClick();
    }
  }

  static Future<void> playWrong() async {
    if (isMuted) return;
    try {
      HapticFeedback.mediumImpact();
      await _player.stop();
      await _player.play(AssetSource('sounds/boing.wav'), volume: volume);
    } catch (_) {
      HapticFeedback.vibrate();
    }
  }

  static Future<void> playSpace() async {
    if (isMuted) return;
    try {
      HapticFeedback.selectionClick();
      await _player.stop();
      await _player.play(AssetSource('sounds/space.wav'), volume: volume);
    } catch (_) {}
  }

  static Future<void> playBackspace() async {
    if (isMuted) return;
    try {
      HapticFeedback.lightImpact();
      await _player.stop();
      await _player.play(AssetSource('sounds/rewind.wav'), volume: volume);
    } catch (_) {}
  }

  static Future<void> playWordComplete() async {
    if (isMuted) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/jingle.wav'), volume: volume);
    } catch (_) {}
  }

  static Future<void> playSentenceComplete() async {
    if (isMuted) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/victory.wav'), volume: volume);
    } catch (_) {}
  }

  static Future<void> playVictory() async {
    if (isMuted) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/victory.wav'), volume: volume);
    } catch (_) {}
  }
}
