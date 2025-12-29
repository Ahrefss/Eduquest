import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'game_data.dart';

class PetSelectionHalfScreen extends StatefulWidget {
  final int currentCoin;
  final List<String> ownedSkins;
  final String currentSkin;

  const PetSelectionHalfScreen({
    super.key,
    required this.currentCoin,
    required this.ownedSkins,
    required this.currentSkin,
  });

  @override
  State<PetSelectionHalfScreen> createState() => _PetSelectionHalfScreenState();
}

class _PetSelectionHalfScreenState extends State<PetSelectionHalfScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  late int myCoin;
  late List<String> mySkins;
  late String selectedSkin;

  // ==========================================
  // 🔧 PERBAIKAN DATA: PISAH ANTARA ICON & SKIN
  // ==========================================
  final List<Map<String, dynamic>> pets = [
    {
      // Gambar untuk List Bawah (Ada Bordernya)
      'icon': 'assets/Defskin.svg',
      // Gambar untuk Karakter Asli (Tanpa Border) -> Ganti nama file ini sesuai aset aslimu
      'skin': 'childorg.svg',
      'price': 0,
      'label': 'Free',
    },
    {
      'icon': 'assets/prtborskin.svg',
      'skin': 'adultprt.svg', // ⚠️ GANTI DENGAN NAMA FILE PET BAJAK LAUT KAMU
      'price': 1000,
      'label': '1000',
    },
    {
      'icon': 'assets/kngborskin.svg',
      'skin': 'adultknght.svg', // ⚠️ GANTI DENGAN NAMA FILE PET RAJA KAMU
      'price': 2500,
      'label': '2500',
    },
    {
      'icon': 'assets/wzrborskkin.svg',
      'skin': 'adultwzrd.svg', // ⚠️ GANTI DENGAN NAMA FILE PET PENYIHIR KAMU
      'price': 5000,
      'label': '5000',
    },
    {
      'icon': 'assets/kingborskin.svg',
      'skin': 'adultking.svg', // ⚠️ GANTI SESUAI FILE ASLI
      'price': 10000,
      'label': '10k',
    },
  ];

  @override
  void initState() {
    super.initState();
    myCoin = widget.currentCoin;
    mySkins = List.from(widget.ownedSkins);
    selectedSkin = widget.currentSkin;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSkinTap(int index) {
    // Ambil data SKIN (Karakter), bukan ICON
    String skinAsset = pets[index]['skin'];
    int price = pets[index]['price'];

    // Cek kepemilikan berdasarkan skinAsset
    bool isOwned = mySkins.contains(skinAsset);

    if (isOwned) {
      setState(() {
        selectedSkin = skinAsset;
      });
      _saveShopData();
    } else {
      if (myCoin >= price) {
        setState(() {
          myCoin -= price;
          mySkins.add(skinAsset); // Simpan skin asli ke inventory
          selectedSkin = skinAsset;
        });
        _saveShopData();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Skin berhasil dibeli!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Koin kurang! Butuh ${price - myCoin} lagi."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveShopData() async {
    final data = await GameData.loadProgress();
    await GameData.saveProgress(
      level: data['level'],
      xp: data['xp'],
      petName: data['petName'],
      coin: myCoin,
      currentSkin: selectedSkin, // Simpan skin asli
      ownedSkins: mySkins,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double halfHeight = screenHeight * 0.5;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.transparent),
          ),

          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: halfHeight,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Pet Selection",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/coin.svg',
                                      width: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "$myCoin",
                                      style: const TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const Divider(color: Colors.white24),

                          // ==========================================
                          // 1. PREVIEW BESAR (Pakai variable 'selectedSkin')
                          // ==========================================
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: SvgPicture.asset(
                                selectedSkin, // Ini akan menampilkan skin asli (tanpa border)
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          // ==========================================
                          // 2. LIST KECIL (Pakai 'icon' dari list pets)
                          // ==========================================
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              itemCount: pets.length,
                              itemBuilder: (context, index) {
                                final pet = pets[index];
                                String iconAsset =
                                    pet['icon']; // Gambar dengan border
                                String skinAsset =
                                    pet['skin']; // Gambar karakter asli
                                int price = pet['price'];

                                bool isSelected = selectedSkin == skinAsset;
                                bool isOwned = mySkins.contains(skinAsset);
                                bool canAfford = myCoin >= price;

                                Color borderColor;
                                String labelText;

                                if (isSelected) {
                                  borderColor = Colors.amber;
                                  labelText = "Equipped";
                                } else if (isOwned) {
                                  borderColor = Colors.grey;
                                  labelText = "Owned";
                                } else if (canAfford) {
                                  borderColor = Colors.green;
                                  labelText = "${pet['label']}";
                                } else {
                                  borderColor = Colors.red;
                                  labelText = "${pet['label']}";
                                }

                                return GestureDetector(
                                  onTap: () => _onSkinTap(index),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white.withValues(alpha: 0.1)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: borderColor,
                                        width: isSelected ? 3 : 2,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Tampilkan ICON di list (yang ada bordernya)
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SvgPicture.asset(iconAsset),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                            bottom: 5,
                                          ),
                                          child: Text(
                                            labelText,
                                            style: TextStyle(
                                              color: borderColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
