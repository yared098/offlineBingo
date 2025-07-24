import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // Replace audioplayers
import 'package:offlinebingo/config/anbesa.dart';

import 'package:offlinebingo/providers/game_provider.dart';
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

  void startGenerating() async {
    stopGenerating(); // cancel any previous generation

    while (allNumbers.isNotEmpty && !isPaused) {
      final number = allNumbers.removeAt(0);

      setState(() {
        generatedNumbers.add(number);
      });

      await playBingoSound(number); // wait until audio finishes

      await Future.delayed(const Duration(milliseconds: 300)); // optional pause

      if (isPaused) break; // stop if paused during loop
    }
  }

  void togglePauseResume() {
    setState(() {
      isPaused = !isPaused;
    });

    if (!isPaused) {
      startGenerating(); // resume generating when unpaused
    }
  }

  void stopGenerating() {
    _timer?.cancel();
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
    startGenerating();
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

  void _showGridDialog(BuildContext context, int selectedNumber) {
    final patternCard = cards.firstWhere(
      (card) => card["cardId"] == selectedNumber,
      orElse: () => {},
    );

    if (patternCard.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No pattern found for card ID $selectedNumber")),
      );
      return;
    }

    // Convert the Map<String, dynamic> to List<List<int>>
    final patternGrid = convertCardToGridReversed(patternCard);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Pattern for $selectedNumber",
          style: const TextStyle(color: Colors.white),
        ),
        content: Container(
          width: double.maxFinite,
          child: PatternGrid(
            pattern: patternGrid,
            generatedNumbers: generatedNumbers,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text("ቢንጎ ጨዋታ", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E2E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Colors.greenAccent),
            onPressed: startGenerating,
          ),
          IconButton(
            icon: Icon(
              isPaused ? Icons.play_circle : Icons.pause_circle,
              color: Colors.yellow,
            ),
            onPressed: togglePauseResume,
          ),
          IconButton(
            onPressed: stopGenerating,
            icon: const Icon(Icons.stop, color: Colors.red),
          ),
          IconButton(
            icon: Icon(
              isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isMuted = !isMuted;
              });
              _audioPlayer.setVolume(isMuted ? 0.0 : 1.0);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                _buildTopControls(context),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "እባክዎ ይምረጡ",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.selectedNumbers.map((number) {
                    return GestureDetector(
                      onTap: () => _showGridDialog(context, number),
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[700],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Text(
                          "$number",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),
                Expanded(
                  child: Center(
                    child: BingoGrid(selectedNumbers: generatedNumbers),
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

  Widget _buildTopControls(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _smallButton("ጀምር", startGenerating),
          const SizedBox(width: 8),
          _smallButton("Play", () async {
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
                title: Text(result ? "✅ Success" : "❌ Failed"),
                content: Text(
                  result
                      ? "Game created successfully!"
                      : "Failed to create game.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(width: 8),
          _smallButton("Pause", togglePauseResume),
          const SizedBox(width: 8),
          _smallButton("Stop", stopGenerating),
        ],
      ),
    );
  }

  Widget _smallButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey[800],
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        textStyle: const TextStyle(fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label),
    );
  }
}
