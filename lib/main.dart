import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double currentXP = 0; // 🟢 mulai dari 0 XP
  double maxXP = 100;
  int currentLevel = 0; // 🟢 mulai dari Level 0

  late AnimationController _controller;
  late Animation<double> _xpAnimation;

  // 🪵 Map level -> asset bar XP
  final Map<int, String> levelBarAssets = {
    0: 'assets/Level0.svg',
    1: 'assets/levelEXP.svg',
    2: 'assets/Level2.svg',
    3: 'assets/level3.svg',
    4: 'assets/level4.svg',
  };

  // 🟧 Asset isi XP bar (yang oranye)
  final String xpFillAsset = 'assets/expFill.svg';

  @override
  void initState() {
    super.initState();

    // 🎞️ Controller animasi XP
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // mulai dari 0 XP
    _xpAnimation = Tween<double>(
      begin: 0,
      end: currentXP / maxXP,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ⚔️ Fungsi update level (nanti dipakai setelah misi selesai)
  void updateLevel(int newLevel) {
    setState(() {
      currentLevel = newLevel;
      currentXP = 0; // reset XP
    });

    // Animasi ulang XP bar dari 0
    _controller.reset();
    _xpAnimation = Tween<double>(
      begin: 0,
      end: currentXP / maxXP,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    // 📦 Ambil asset XP bar sesuai level
    final String barAsset = levelBarAssets[currentLevel] ?? 'assets/Level0.svg';

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

          // ⚙️ Tombol kanan atas
          Positioned(
            top: screenHeight * 0.05,
            right: screenWidth * 0.05,
            child: SvgPicture.asset(
              'assets/MenuSetting.svg',
              width: screenWidth * 0.1,
            ),
          ),

          // 🧍 Nama + Level + XP Bar
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Razorr',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Level $currentLevel',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 🎞️ XP Bar berdasarkan level
                  AnimatedBuilder(
                    animation: _xpAnimation,
                    builder: (context, child) {
                      return _buildXPBar(
                        _xpAnimation.value,
                        screenWidth,
                        barAsset,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 🪵 Platform tengah
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/platform.svg',
              width: screenWidth * 0.6,
              height: screenHeight * 0.15,
            ),
          ),

          // 🔳 Tombol bawah (Quest + Kostum)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _AnimatedButton(
                    assetPath: 'assets/quest.svg',
                    width: screenWidth * 0.45,
                    height: screenHeight * 0.12,
                    onTap: () {
                      debugPrint('Quest button pressed');
                      // 🟢 contoh sementara
                      // tambahkan level +1 setiap klik quest
                      updateLevel((currentLevel + 1) % 5);
                    },
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  _AnimatedButton(
                    assetPath: 'assets/skinbaju.svg',
                    width: screenWidth * 0.18,
                    height: screenHeight * 0.1,
                    onTap: () {
                      debugPrint('Cloth button pressed');
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

  // 🔸 Widget XP Bar per level
  Widget _buildXPBar(double percent, double screenWidth, String barAsset) {
    return SizedBox(
      width: screenWidth * 0.55,
      height: 35,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // 🪵 Background kayu per level
          SvgPicture.asset(
            barAsset,
            fit: BoxFit.fill,
            width: screenWidth * 0.55,
          ),

          // 🟧 Isi XP (progress bar)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Align(
              alignment: Alignment.centerLeft,
              widthFactor: percent.clamp(0.0, 1.0),
              child: SvgPicture.asset(
                xpFillAsset,
                fit: BoxFit.fill,
                width: screenWidth * 0.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🧱 Widget tombol dengan animasi scale
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

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.9);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

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
