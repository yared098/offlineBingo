import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // Replace audioplayers
import 'package:offlinebingo/config/card_pattern.dart';
import 'package:offlinebingo/pages/SelectedNumbersPage.dart';

import 'package:offlinebingo/providers/game_provider.dart';
import 'package:offlinebingo/widgets/_patternShowPage.dart';
import 'package:offlinebingo/widgets/_widgetBingoGrid.dart' show BingoGrid;
import 'package:offlinebingo/widgets/pattern_grid.dart';
import 'package:provider/provider.dart';

class BingoHomePage extends StatefulWidget {
  final List<int> selectedNumbers;
  final int amount;
  final int cutAmountPercent;

  const BingoHomePage({
    super.key,
    required this.selectedNumbers,
    required this.amount,
    required this.cutAmountPercent,
  });

  @override
  State<BingoHomePage> createState() => _BingoHomePageState();
}

class _BingoHomePageState extends State<BingoHomePage> {
  List<int> generatedNumbers = [];
  List<int> allNumbers = List.generate(75, (i) => i + 1)..shuffle();
  Timer? _timer;
  bool isPaused = false;
  bool isMuted = false;
  bool _isLoading = false;
  final AudioPlayer _audioPlayer = AudioPlayer(); // just_audio player
  bool hasStarted = false;

  final TextEditingController _cardNumberController = TextEditingController();
  void _openSelectedNumbersPage({int? openCardNumber}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectedNumbersPage(
          selectedNumbers: widget.selectedNumbers,
          cards: cards,
          generatedNumbers: generatedNumbers,
          openCardNumber: openCardNumber,
        ),
      ),
    );
  }

  void togglePauseResume() async {
    setState(() {
      isPaused = !isPaused;
    });

    if (isPaused) {
      // Stop any sound currently playing immediately
      await _audioPlayer.stop();
    } else {
      // Resume number generation when unpaused
      startGenerating();
    }
  }

  void startGenerating() async {
    setState(() {
      isPaused = false;
      hasStarted = true; // Disable "Start" button
    });

    while (allNumbers.isNotEmpty && !isPaused) {
      final number = allNumbers.removeAt(0);

      setState(() {
        generatedNumbers.add(number);
      });

      await playBingoSound(number);

      if (isPaused) break;

      await Future.delayed(const Duration(milliseconds: 300));
      if (isPaused) break;
    }

    // Game has ended
    if (!isPaused && allNumbers.isEmpty) {
      setState(() {
        hasStarted = false; // Re-enable "Start" button
      });
    }
  }

  void stopGenerating() {
    setState(() {
      isPaused = true;
      generatedNumbers = [];
      allNumbers = List.generate(75, (i) => i + 1)..shuffle();
    });
    _timer?.cancel();
    _audioPlayer.stop();
  }

  @override
  void dispose() {
    stopGenerating();
    _audioPlayer.dispose(); // Just_audio disposal
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // startGenerating();
  }

  String getBingoPrefix(int number) {
    if (number >= 1 && number <= 15) return 'b';
    if (number >= 16 && number <= 30) return 'i';
    if (number >= 31 && number <= 45) return 'n';
    if (number >= 46 && number <= 60) return 'g';
    if (number >= 61 && number <= 75) return 'o';
    return '';
  }

  Future<void> playBingoSound(int number) async {
    final prefix = getBingoPrefix(number);
    final file = 'assets/sounds/${prefix}${number}.ogg';

    try {
      await _audioPlayer.stop();
      await _audioPlayer.setAsset(file);
      await _audioPlayer.setVolume(isMuted ? 0.0 : 1.0); // ← Respect mute
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  List<List<int>> convertCardToGridReversed(Map<String, dynamic> card) {
    return List.generate(5, (index) {
      // index goes from 0 to 4, corresponding to the rows in your original grid
      return [
        card['b${index + 1}'],
        card['i${index + 1}'],
        card['n${index + 1}'],
        card['g${index + 1}'],
        card['o${index + 1}'],
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text("ቢንጎ ጨዋታ", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E2E),
        elevation: 2,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              children: [
                _buildTopControls(context),
                const SizedBox(height: 5),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // BINGO GRID LEFT SIDE
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                child: BingoGrid(
                                  selectedNumbers: generatedNumbers,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),
                      // RIGHT PANEL (Latest Number & Winner Section)
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // CALLED NUMBER BOX
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[800],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.amberAccent.withOpacity(0.6),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "📢 Latest Number",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Text(
                                      generatedNumbers.isNotEmpty
                                          ? "${getBingoPrefix(generatedNumbers.last).toUpperCase()} ${generatedNumbers.last}"
                                          : "--",
                                      style: const TextStyle(
                                        color: Colors.amberAccent,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            buildWinnerBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.amber)),
        ],
      ),
    );
  }

 Widget buildWinnerBox() {
  final int totalSelected = widget.selectedNumbers.length;
  final int winAmount =
      (totalSelected * widget.amount) -
      ((totalSelected * widget.amount * widget.cutAmountPercent) ~/ 100);

  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        colors: [Colors.green.shade700, Colors.green.shade900],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: Colors.amberAccent.withOpacity(0.5),
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.emoji_events, color: Colors.amber, size: 28),
            SizedBox(width: 10),
            Text(
              "Winner",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        Text(
          "Amount: $winAmount ETB",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.amberAccent,
          ),
        ),
      ],
    ),
  );
}

  Widget _buildTopControls(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: deviceWidth + 5, // 👈 Add 5 pixels to width
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              offset: const Offset(0, 3),
              blurRadius: 8,
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _iconTextButton(
                icon: Icons.play_arrow,
                label: "ጀምር",
                color: Colors.greenAccent,
                onPressed: hasStarted
                    ? null
                    : () {
                        setState(() {
                          generatedNumbers = [];
                          allNumbers = List.generate(75, (i) => i + 1)
                            ..shuffle();
                        });
                        startGenerating();
                      },
              ),
              const SizedBox(width: 16),
              _iconTextButton(
                icon: isPaused ? Icons.play_circle : Icons.pause_circle,
                label: isPaused ? "Resume" : "Pause",
                color: Colors.amberAccent,
                onPressed: togglePauseResume,
              ),
              const SizedBox(width: 16),
              _iconTextButton(
                icon: isMuted ? Icons.volume_off : Icons.volume_up,
                label: isMuted ? "Muted" : "Sound",
                color: Colors.white70,
                onPressed: () {
                  setState(() {
                    isMuted = !isMuted;
                  });
                  _audioPlayer.setVolume(isMuted ? 0.0 : 1.0);
                },
              ),
              const SizedBox(width: 16),
              _iconTextButton(
                icon: Icons.gamepad,
                label: "Play Game",
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() => _isLoading = true);

                  final gameProvider = Provider.of<GameProvider>(
                    context,
                    listen: false,
                  );
                  bool result = false;

                  try {
                    result = await gameProvider.createGame(
                      stakeAmount: widget.amount,
                      numberOfPlayers: widget.selectedNumbers.length,
                      cutAmountPercent: widget.cutAmountPercent,
                      cartela: widget.selectedNumbers.length,
                    );
                  } catch (e) {
                    print("Error creating game: $e");
                  }

                  setState(() => _isLoading = false);

                  showDialog(
                    barrierColor: const Color(0xFF1E1E2E),
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.grey[900],
                      title: Text(
                        result ? "✅ Success" : "❌ Failed",
                        style: const TextStyle(color: Colors.white),
                      ),
                      content: Text(
                        result
                            ? "Game created successfully!"
                            : "Failed to create game.",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "OK",
                            style: TextStyle(color: Colors.amber),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              _iconTextButton(
                icon: Icons.pattern,
                label: "Pattern",
                color: Colors.redAccent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PatternShowPage()),
                  );
                },
              ),
              const SizedBox(width: 16),
              _iconTextButton(
                icon: Icons.search,
                label: "Search",
                color: Colors.redAccent,
                onPressed: () {
                  final input = _cardNumberController.text.trim();
                  final number = int.tryParse(input);
                  if (number != null) {
                    _cardNumberController.clear();
                    _openSelectedNumbersPage(openCardNumber: number);
                  } else {
                    _openSelectedNumbersPage(openCardNumber: number);
                  }
                },
              ),
             
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconTextButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8), // reduced from 12
            child: Icon(
              icon,
              color: color,
              size: 20, // reduced from 28
            ),
          ),
          const SizedBox(height: 4), // optional: slightly smaller spacing
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11, // optional: smaller text
            ),
          ),
        ],
      ),
    );
  }
}
