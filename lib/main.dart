import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'pet_selection.dart';
import 'menu_setting.dart';
import 'quest.dart';
import 'game_data.dart';
import 'audio_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetQuest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// ================================
// 🏠 HALAMAN UTAMA GAME
// ================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String petName = "Oyen";
  double currentXP = 0;
  double maxXP = 100;
  int currentLevel = 1;
  int currentCoin = 0; // Tambah variabel coin
  String currentPet = 'assets/childorg.svg'; // Default pet awal (bayi)
  List<String> ownedSkins = ['assets/childorg.svg'];

  final List<String> xpBars = [
    'assets/bar_exp0.svg',
    'assets/bar_exp1.svg',
    'assets/bar_exp2.svg',
    'assets/bar_exp3.svg',
    'assets/bar_exp4.svg',
    'assets/bar_expfull.svg',
  ];

  @override
  void initState() {
    super.initState();
    _loadGameData();
    AudioManager.instance.startBGM();
  }

  Future<void> _loadGameData() async {
    final data = await GameData.loadProgress();
    setState(() {
      currentLevel = data['level'];
      currentXP = data['xp'];
      currentCoin = data['coin'];
      currentPet = data['skin']; // Gunakan skin terakhir yang dipakai
      petName = data['petName'];
      ownedSkins = List<String>.from(data['ownedSkins']); // 🔥 Load daftar skin
    });
  }

  Future<void> _saveGameData() async {
    await GameData.saveProgress(
      level: currentLevel,
      xp: currentXP,
      coin: currentCoin,
      currentSkin: currentPet,
      petName: petName, // Simpan nama saat ini
      ownedSkins: ownedSkins, // 🔥 Simpan daftar skin
    );
  }

  String _getEvolutionSkin(int level) {
    // Kamu bisa ganti path asset ini sesuai nama file kamu
    if (level == 1) {
      return 'childorg.svg'; // Bayi
    } else if (level == 2) {
      return 'teenorg.svg'; // Remaja
    } else {
      return 'adultorg.svg'; // Dewasa (Level 3 ke atas)
    }
  }

  String get currentXPBar {
    // Hitung persentase XP (0.0 sampai 1.0)
    double percentage = (currentXP / maxXP).clamp(0.0, 1.0);

    // Konversi ke index array (0 sampai 5)
    int index = (percentage * (xpBars.length - 1)).floor();

    return xpBars[index];
  }

  // Fungsi untuk memunculkan dialog edit nama
  void _showEditNameDialog() {
    TextEditingController nameController = TextEditingController(text: petName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF7A4A1A), // Warna kayu gelap
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Ganti Nama Pet",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            maxLength: 12, // Batasi panjang nama biar gak ngerusak UI
            decoration: InputDecoration(
              hintText: "Masukkan nama...",
              hintStyle: const TextStyle(color: Colors.white54),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white54),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.amber),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Batal",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                setState(() {
                  petName = nameController.text.trim(); // Update nama di layar
                  if (petName.isEmpty) petName = "Tanpa Nama";
                });
                _saveGameData(); // Simpan nama baru ke database
                Navigator.pop(context);
              },
              child: const Text(
                "Simpan",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    return Scaffold(
      body: Stack(
        children: [
          // 🌄 Background
          Positioned.fill(
            child: SvgPicture.asset('assets/BGHome.svg', fit: BoxFit.cover),
          ),

          // 🔘 Tombol kiri atas
          Positioned(
            top: screenHeight * 0.05,
            left: screenWidth * 0.05,
            child: SvgPicture.asset(
              'assets/MenuKembali.svg',
              width: screenWidth * 0.1,
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.15),
              child: SizedBox(
                width: screenWidth * 0.6,
                height: screenWidth * 0.6,
                child: SvgPicture.asset(
                  currentPet, // Gambar berubah sesuai logika _getEvolutionSkin
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // ⚙️ Setting
          Positioned(
            top: screenHeight * 0.05,
            right: screenWidth * 0.05,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.black.withValues(
                    alpha: 0.35,
                  ), // Tetap transparan supaya tombol back terlihat
                  barrierDismissible: true,
                  builder: (context) => IgnorePointer(
                    ignoring:
                        false, // penting! agar tombol di belakang masih bisa di-klik
                    child: Center(
                      child: SizedBox(
                        width: screenWidth,
                        height: screenHeight,
                        child: const MenuSetting(),
                      ),
                    ),
                  ),
                );
              },
              child: SvgPicture.asset(
                'assets/MenuSetting.svg',
                width: screenWidth * 0.1,
              ),
            ),
          ),

          // 👾 Info atas
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.13),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _showEditNameDialog, // Panggil popup saat diklik
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          petName, // Gunakan variabel, bukan teks statis 'Nama Pet'
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black45,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.edit, color: Colors.white70, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Level $currentLevel', // Level dinamis
                    style: const TextStyle(fontSize: 22, color: Colors.white),
                  ),

                  const SizedBox(height: 10),

                  SvgPicture.asset(currentXPBar, width: screenWidth * 0.55),

                  const SizedBox(height: 5),

                  // Teks XP
                  Text(
                    '${currentXP.toInt()} / ${maxXP.toInt()} XP',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // TAMPILAN COIN (BARU)
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/coin.svg', width: 20),
                      const SizedBox(width: 5),
                      Text(
                        '$currentCoin',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 🔘 Tombol bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ============================
                  // 🔥 QUEST → BUKA QUEST.DART
                  // ============================
                  _AnimatedButton(
                    assetPath: 'assets/quest.svg',
                    width: screenWidth * 0.45,
                    height: screenHeight * 0.12,
                    onTap: () async {
                      // 1. Buka Quest & Tunggu Hasilnya
                      final reward = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuestPage(),
                        ),
                      );

                      // 2. Jika pemain kembali membawa hadiah (XP & Coin)
                      if (reward != null && reward is Map) {
                        setState(() {
                          // A. Tambah Coin
                          int earnedCoin = reward['coin'] ?? 0;
                          currentCoin += earnedCoin;

                          // B. Tambah XP
                          int earnedXP = reward['xp'] ?? 0;
                          currentXP += earnedXP;

                          // C. Cek Level Up (Pakai Loop biar kalau XP melimpah bisa naik level berkali-kali)
                          while (currentXP >= maxXP) {
                            currentXP -=
                                maxXP; // Kurangi XP dengan batas maksimal
                            currentLevel++; // Naik Level

                            // (Opsional) Persulit level berikutnya
                            // maxXP = maxXP + 50;

                            // Cek Evolusi Pet (Bayi -> Remaja -> Dewasa)
                            currentPet = _getEvolutionSkin(currentLevel);

                            // Munculkan notifikasi Level Up
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "LEVEL UP! Selamat datang di Level $currentLevel",
                                ),
                                backgroundColor: Colors.purpleAccent,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        });

                        // 3. Simpan data terbaru ke HP
                        _saveGameData();
                      }
                    },
                  ),

                  SizedBox(width: screenWidth * 0.05),

                  // 🔥 Skin
                  _AnimatedButton(
                    assetPath: 'assets/skinbaju.svg',
                    width: screenWidth * 0.18,
                    height: screenHeight * 0.1,
                    onTap: () async {
                      // 1. Buka Toko dengan PageRouteBuilder (Transparan)
                      await Navigator.push(
                        context,
                        PageRouteBuilder(
                          opaque:
                              false, // 👈 INI KUNCINYA (Biar background transparan)
                          pageBuilder: (_, __, ___) => PetSelectionHalfScreen(
                            currentCoin: currentCoin,
                            ownedSkins: ownedSkins,
                            currentSkin: currentPet,
                          ),
                        ),
                      );

                      // 2. Saat kembali dari toko, reload data
                      _loadGameData();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================
// 🔲 TOMBOL ANIMASI SCALE
// ================================
class _AnimatedButton extends StatefulWidget {
  final String assetPath;
  final double width;
  final double height;
  final VoidCallback onTap;

  const _AnimatedButton({
    required this.assetPath,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) => setState(() => _scale = 0.9);
  void _onTapUp(TapUpDetails details) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: (details) {
        _onTapUp(details);
        widget.onTap();
      },
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: SvgPicture.asset(
          widget.assetPath,
          width: widget.width,
          height: widget.height,
        ),
      ),
    );
  }
}
