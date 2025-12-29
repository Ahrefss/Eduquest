import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'reward_page.dart';

// Import halaman quest (kamu buat di file terpisah)
import 'quest_math.dart';
import 'quest_read.dart';
import 'quest_logic.dart';
import 'quest_count.dart';

class QuestPage extends StatefulWidget {
  const QuestPage({super.key});

  @override
  State<QuestPage> createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  final List<Map<String, dynamic>> quests = [
    {
      'title': 'Kerjakan 5 soal matematika tingkat dasar',
      'xp': 50,
      'coin': 500,
      'route': const QuestMath(),
    },
    {
      'title': 'Kerjakan 5 soal membaca teks pendek',
      'xp': 50,
      'coin': 500,
      'route': const QuestRead(),
    },
    {
      'title': 'Selesaikan 3 soal logika sederhana',
      'xp': 50,
      'coin': 500,
      'route': const QuestLogic(),
    },
    {
      'title': 'Kerjakan 5 soal berhitung cepat',
      'xp': 50,
      'coin': 500,
      'route': const QuestCount(),
    },
  ];

  int? selectedIndex;

  void onQuestTap(int index) {
    setState(() => selectedIndex = index);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Quest Dipilih!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          quests[index]['title'],
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // 1. Tutup Dialog Info

              // 2. Masuk ke Soal dan tunggu hasil
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => quests[index]['route']),
              );

              // 3. JIKA JAWABAN BENAR
              if (result == true) {
                // Munculkan Halaman Reward (Congratulation)
                // ignore: use_build_context_synchronously
                await Navigator.push(
                  context,
                  PageRouteBuilder(
                    opaque: false, // Agar background transparan
                    pageBuilder: (_, __, ___) => RewardPage(
                      xp: quests[index]['xp'],
                      coin: quests[index]['coin'],
                    ),
                  ),
                );

                // 4. Setelah tombol "Claim" ditekan (RewardPage ditutup),
                // Baru kita balik ke Home membawa data
                // ignore: use_build_context_synchronously
                Navigator.pop(context, {
                  'xp': quests[index]['xp'],
                  'coin': quests[index]['coin'],
                });
              }
            },
            child: const Text("Mulai", style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset('assets/BGHome.svg', fit: BoxFit.cover),
          ),

          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.35)),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: w,
              height: h * 0.60,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: SizedBox(
                      width: w,
                      height: h * 0.60,
                      child: SvgPicture.asset(
                        'assets/Bgquest.svg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: Column(
                      children: [
                        SizedBox(height: h * 0.03),
                        SizedBox(height: h * 0.03),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            itemCount: quests.length,
                            itemBuilder: (context, index) {
                              final quest = quests[index];

                              return GestureDetector(
                                onTap: () => onQuestTap(index),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  width: w * 0.90,
                                  height: (w * 0.90) * 0.22,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: SvgPicture.asset(
                                          'assets/blockquest.svg',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                quest['title'],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.3,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/XP.svg',
                                                      width: 22,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${quest['xp']}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/coin.svg',
                                                      width: 22,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${quest['coin']}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset('assets/MenuKembali.svg', width: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
