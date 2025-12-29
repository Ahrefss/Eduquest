import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuestLogic extends StatefulWidget {
  const QuestLogic({super.key});

  @override
  State<QuestLogic> createState() => _QuestLogicState();
}

class _QuestLogicState extends State<QuestLogic> {
  int activeIndex = 0;

  final List<Map<String, dynamic>> questions = [
    {
      "soal": "Jika Merah + Kuning = Oranye, maka Biru + Kuning = ...?",
      "opsi": ["Ungu", "Hijau", "Coklat", "Hitam"],
      "kunci": 1, // Hijau
    },
    {
      "soal": "Siang ada Matahari, kalau Malam ada ...?",
      "opsi": ["Awan", "Pelangi", "Bulan", "Hujan"],
      "kunci": 2, // Bulan
    },
    {
      "soal": "A, B, C, D, ... Huruf selanjutnya adalah?",
      "opsi": ["E", "F", "G", "H"],
      "kunci": 0, // E
    },
    {
      "soal": "Gajah itu Besar, kalau Semut itu ...?",
      "opsi": ["Tinggi", "Kecil", "Gemuk", "Panjang"],
      "kunci": 1, // Kecil
    },
    {
      "soal": "Jika Budi > Andi, dan Andi > Rudi. Siapa paling pendek?",
      "opsi": ["Budi", "Andi", "Rudi", "Semua sama"],
      "kunci": 2, // Rudi
    },
  ];

  void _checkAnswer(int selectedIndex) {
    if (selectedIndex == questions[activeIndex]['kunci']) {
      if (activeIndex < questions.length - 1) {
        setState(() => activeIndex++);
      } else {
        Navigator.pop(context, true);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Logikanya kurang tepat!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;
    final currentQ = questions[activeIndex];
    final List<String> opsi = currentQ['opsi'];

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: w,
            height: h,
            child: SvgPicture.asset('assets/BGHome.svg', fit: BoxFit.cover),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(color: Colors.black.withValues(alpha: 0.2)),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Soal ${activeIndex + 1}/${questions.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: w * 0.90,
                    height: w * 0.65,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/PapanSoal.svg',
                          fit: BoxFit.contain,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 15,
                          ),
                          child: Text(
                            currentQ['soal'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: w * 0.050,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.3,
                              shadows: const [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 5,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: h * 0.04),
                Expanded(
                  child: Column(
                    children: [
                      jawabBalok(context, "A. ${opsi[0]}", w, 0),
                      SizedBox(height: h * 0.015),
                      jawabBalok(context, "B. ${opsi[1]}", w, 1),
                      SizedBox(height: h * 0.015),
                      jawabBalok(context, "C. ${opsi[2]}", w, 2),
                      SizedBox(height: h * 0.015),
                      jawabBalok(context, "D. ${opsi[3]}", w, 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget jawabBalok(BuildContext context, String text, double w, int index) {
    return GestureDetector(
      onTap: () => _checkAnswer(index),
      child: SizedBox(
        width: w * 0.85,
        height: (w * 0.85) * 0.18,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset('assets/Baloksoal.svg', fit: BoxFit.contain),
            Text(
              text,
              style: TextStyle(
                fontSize: w * 0.050,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: const [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 4,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
