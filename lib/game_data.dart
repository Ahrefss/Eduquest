import 'package:shared_preferences/shared_preferences.dart';

class GameData {
  // Kunci Database
  static const String keyLevel = 'level';
  static const String keyXP = 'xp';
  static const String keyCoin = 'coin';
  static const String keySkin = 'skin';
  static const String keyPetName = 'pet_name';
  static const String keyOwnedSkins =
      'owned_skins'; // 🔥 BARU: Daftar skin milik kita

  // 1. Simpan Semua Data
  static Future<void> saveProgress({
    required int level,
    required double xp,
    required int coin,
    required String currentSkin,
    required String petName,
    required List<String> ownedSkins, // 🔥 BARU: Parameter list skin
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyLevel, level);
    await prefs.setDouble(keyXP, xp);
    await prefs.setInt(keyCoin, coin);
    await prefs.setString(keySkin, currentSkin);
    await prefs.setString(keyPetName, petName);
    await prefs.setStringList(keyOwnedSkins, ownedSkins); // Simpan List
  }

  // 2. Ambil Semua Data
  static Future<Map<String, dynamic>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    int level = prefs.getInt(keyLevel) ?? 1;
    double xp = prefs.getDouble(keyXP) ?? 0.0;
    int coin = prefs.getInt(keyCoin) ?? 0;
    String skin =
        prefs.getString(keySkin) ??
        'assets/childorg.svg'; // Default sesuai file kamu
    String petName = prefs.getString(keyPetName) ?? 'Oyen';

    // Ambil daftar skin. Kalau kosong, kasih modal awal skin default.
    List<String> ownedSkins =
        prefs.getStringList(keyOwnedSkins) ?? ['assets/adultorg.svg'];

    return {
      'level': level,
      'xp': xp,
      'coin': coin,
      'skin': skin,
      'petName': petName,
      'ownedSkins': ownedSkins, // Kembalikan list ini
    };
  }
}
