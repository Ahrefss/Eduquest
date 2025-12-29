import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  // Membuat satu akses 'Pusat' (Singleton) agar musik bisa diatur dari mana saja
  static final AudioManager instance = AudioManager._internal();
  AudioManager._internal();

  final AudioPlayer _player = AudioPlayer();
  double _volume = 0.5; // Volume awal 50%
  bool _isPlaying = false;

  // Fungsi Mulai Musik
  Future<void> startBGM() async {
    if (_isPlaying) return; // Kalau sudah nyala, jangan nyalakan lagi

    await _player.setReleaseMode(ReleaseMode.loop); // Agar lagu mengulang terus
    await _player.play(AssetSource('bgm.mp3'), volume: _volume);
    _isPlaying = true;
  }

  // Fungsi Atur Volume (0.0 sampai 1.0)
  void setVolume(double vol) {
    _volume = vol.clamp(0.0, 1.0);
    _player.setVolume(_volume);
  }

  // Ambil volume saat ini (untuk Slider)
  double get currentVolume => _volume;

  // Stop Musik (Opsional)
  void stopBGM() {
    _player.stop();
    _isPlaying = false;
  }
}
