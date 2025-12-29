import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuestMath extends StatefulWidget {
  const QuestMath({super.key});

  @override
  State<QuestMath> createState() => _QuestMathState();
}

class _QuestMathState extends State<QuestMath> {
  // Index soal yang sedang aktif (dimulai dari 0)
  int activeIndex = 0;

  // DAFTAR 5 SOAL MATEMATIKA
  final List<Map<String, dynamic>> questions = [
    {
      "soal": "8 + 7 = ?",
      "opsi": ["12", "15", "17", "20"],
      "kunci": 1, // Index jawaban benar (0=A, 1=B, 2=C, 3=D) -> 15
    },
    {
      "soal": "10 - 4 = ?",
      "opsi": ["6", "5", "4", "7"],
      "kunci": 0, // -> 6
    },
    {
      "soal": "5 + 5 + 5 = ?",
      "opsi": ["10", "20", "25", "15"],
      "kunci": 3, // -> 15
    },
    {
      "soal": "Angka setelah 19 adalah?",
      "opsi": ["18", "21", "20", "22"],
      "kunci": 2, // -> 20
    },
    {
      "soal": "20 dikurangi 10 hasilnya?",
      "opsi": ["5", "8", "12", "10"],
      "kunci": 3, // -> 10
    },
  ];

  void _checkAnswer(int selectedIndex) {
    if (selectedIndex == questions[activeIndex]['kunci']) {
      // JIKA BENAR
      if (activeIndex < questions.length - 1) {
        // Lanjut ke soal berikutnya
        setState(() {
          activeIndex++;
        });
      } else {
        // Soal habis? Finish!
        Navigator.pop(context, true);
      }
    } else {
      // JIKA SALAH
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Jawaban salah, coba hitung lagi!"),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;

    // Ambil data soal saat ini
    final currentQ = questions[activeIndex];
    final List<String> opsi = currentQ['opsi'];

    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND
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
                // Indikator Progress (Soal 1/5)
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

                SizedBox(height: h * 0.01),

                /// PAPAN SOAL
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
                            currentQ['soal'], // Teks soal berubah dinamis
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: w * 0.060,
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

                /// OPSI JAWABAN (A, B, C, D)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
