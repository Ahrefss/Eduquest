import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'audio_manager.dart'; // Import Audio

class MenuSetting extends StatefulWidget {
  const MenuSetting({super.key});

  @override
  State<MenuSetting> createState() => _MenuSettingState();
}

class _MenuSettingState extends State<MenuSetting> {
  // Ambil volume awal dari Manager Musik
  double _volume = AudioManager.instance.currentVolume;
  bool _isMuted = false;
  double? _lastVolumeBeforeMute;

  final Color _woodDark = const Color(0xFF7A4A1A);
  final Color _woodLight = const Color(0xFFF7C56A);

  @override
  void initState() {
    super.initState();
    // Cek apakah sedang di-mute?
    if (_volume == 0) {
      _isMuted = true;
    }
  }

  void _updateVolume(double newVol) {
    setState(() {
      _volume = newVol.clamp(0.0, 1.0);
      if (_volume > 0) _isMuted = false;
    });
    // Kirim perintah ke Audio Manager
    AudioManager.instance.setVolume(_volume);
  }

  void _increaseVolume() {
    _updateVolume(_volume + 0.1);
  }

  void _decreaseVolume() {
    _updateVolume(_volume - 0.1);
  }

  void _toggleMute() {
    setState(() {
      if (_isMuted) {
        _isMuted = false;
        _volume = (_lastVolumeBeforeMute ?? 0.5);
        if (_volume == 0) _volume = 0.5;
      } else {
        _isMuted = true;
        _lastVolumeBeforeMute = _volume;
        _volume = 0.0;
      }
    });
    AudioManager.instance.setVolume(_volume);
  }

  void _onDragUpdate(Offset localPosition, double trackWidth) {
    final dx = localPosition.dx.clamp(0, trackWidth);
    _updateVolume(dx / trackWidth);
  }

  @override
  Widget build(BuildContext context) {
    const double popupWidth = 280;
    const double popupHeight = 400;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // ===============================================
          // 🔥 1. AREA BACKGROUND (Sekarang Bisa Diklik)
          // ===============================================
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                // Tutup Popup saat klik area kosong/gelap
                Navigator.pop(context);
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),
          ),

          // ===============================================
          // 2. ISI POPUP (Tetap di tengah)
          // ===============================================
          Center(
            // Bungkus dengan GestureDetector kosong agar klik di papan
            // TIDAK ikut menutup popup (hanya klik di luar yang menutup)
            child: GestureDetector(
              onTap: () {},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: popupWidth,
                  height: popupHeight,
                  child: Stack(
                    children: [
                      // BACKGROUND SVG
                      Positioned.fill(
                        child: SvgPicture.asset(
                          'assets/Bgsetting.svg',
                          fit: BoxFit.cover,
                        ),
                      ),

                      // ISI POPUP
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Setting",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 2,
                                    color: Colors.black45,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),

                            const Spacer(),

                            // Icon Speaker Besar
                            SvgPicture.asset(
                              _isMuted
                                  ? 'assets/tbl_mute.svg'
                                  : 'assets/volumeicon.svg',
                              width: 60,
                              height: 60,
                            ),

                            const SizedBox(height: 15),

                            // Slider
                            _buildVolumeSlider(200),

                            const SizedBox(height: 20),

                            // Tombol Minus & Plus
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: _decreaseVolume,
                                  child: SvgPicture.asset(
                                    'assets/tbl-.svg',
                                    width: 45,
                                    height: 45,
                                  ),
                                ),
                                const SizedBox(width: 30),
                                GestureDetector(
                                  onTap: _increaseVolume,
                                  child: SvgPicture.asset(
                                    'assets/tbl+.svg',
                                    width: 45,
                                    height: 45,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Tombol Mute Bawah
                            GestureDetector(
                              onTap: _toggleMute,
                              child: SvgPicture.asset(
                                _isMuted
                                    ? 'assets/tbl_mute.svg'
                                    : 'assets/volumeicon.svg',
                                width: 50,
                                height: 50,
                              ),
                            ),

                            const Spacer(),

                            // Tombol Close (Back)
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: SvgPicture.asset(
                                'assets/close_button.svg',
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SLIDER CUSTOM
  Widget _buildVolumeSlider(double sliderWidth) {
    final double trackWidth = sliderWidth;

    return GestureDetector(
      onPanDown: (d) => _onDragUpdate(d.localPosition, trackWidth),
      onPanUpdate: (d) => _onDragUpdate(d.localPosition, trackWidth),
      child: Container(
        width: sliderWidth,
        height: 24,
        decoration: BoxDecoration(
          color: _woodDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            FractionallySizedBox(
              widthFactor: _volume == 0 ? 0.01 : _volume,
              child: Container(
                decoration: BoxDecoration(
                  color: _woodLight,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Positioned(
              left: (_volume * (trackWidth - 24)).clamp(0, trackWidth - 24),
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
