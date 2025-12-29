import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RewardPage extends StatelessWidget {
  final int xp;
  final int coin;

  const RewardPage({super.key, required this.xp, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. BACKGROUND BLUR (Redup)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                // Fix warning: ganti withOpacity jadi withValues
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ),
          ),

          // 2. KONTEN (Papan Reward)
          // Gunakan Center agar posisi pas di tengah layar (Vertikal & Horizontal)
          Center(
            child: SizedBox(
              width: 360, // LEBIH LEBAR (Tadi 320)
              height: 400,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // GAMBAR PAPAN BACKGROUND
                  SvgPicture.asset(
                    'bgrw.svg', // Pastikan nama file papan kayumu benar
                    width: 360, // Sesuaikan lebar
                    height: 400,
                    fit: BoxFit.contain,
                  ),

                  // KONTEN DI ATAS PAPAN
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      // TULISAN "CONGRATULATION"
                      const Text(
                        "CONGRATULATION",
                        style: TextStyle(
                          fontFamily:
                              'Riffic', // Hapus baris ini jika font belum ada
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(2, 2),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "YOU GET :",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // BARIS HADIAH (XP & COIN)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildRewardItem(
                            "assets/XP.svg",
                            "+XP",
                            xp.toString(),
                          ),
                          const SizedBox(width: 25), // Jarak diperlebar dikit
                          _buildRewardItem(
                            "assets/coin.svg",
                            "Coin",
                            coin.toString(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // TOMBOL CLAIM
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Gambar Tombol
                            SvgPicture.asset(
                              'claim.svg', // Pastikan nama file tombol benar
                              width: 160,
                              height: 60,
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET KOTAK KECIL UNTUK HADIAH
  Widget _buildRewardItem(String iconPath, String label, String value) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.amber, width: 2),
          ),
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset(iconPath),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2),
            ],
          ),
        ),
      ],
    );
  }
}
