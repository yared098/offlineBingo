import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:offlinebingo/providers/game_provider.dart';
import 'package:offlinebingo/widgets/_widgetBingoGrid.dart' show BingoGrid;
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

  final AudioPlayer _audioPlayer = AudioPlayer();

  void startGenerating() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (allNumbers.isNotEmpty && !isPaused) {
        final number = allNumbers.removeAt(0);

        setState(() {
          generatedNumbers.add(number);
        });

        await playBingoSound(number);
      } else {
        timer.cancel();
      }
    });
  }

  void togglePauseResume() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void stopGenerating() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    stopGenerating();
    _audioPlayer.dispose();
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

  // Future<void> playBingoSound(int number) async {
  //   final prefix = getBingoPrefix(number);
  //   final file = 'assets/sounds/${prefix}${number}.ogg';

  //   try {
  //     await _audioPlayer.stop();
  //     await _audioPlayer.play(AssetSource(file.replaceFirst('assets/', '')));
  //   } catch (e) {
  //     print('Error playing sound: $e');
  //   }
  // }
//  Future<void> playBingoSound(int number) async {
//   final prefix = getBingoPrefix(number);
//   final file = 'sounds/${prefix}${number}.ogg'; // changed .ogg to .mp3

//   try {
//     await _audioPlayer.stop();
//     await _audioPlayer.play(AssetSource(file));
//   } catch (e) {
//     print('Error playing sound: $e');
//   }
// }

Future<void> playBingoSound(int number) async {
  final prefix = getBingoPrefix(number);
  final file = 'sounds/${prefix}${number}.mp3';  // <-- Use .mp3 here

  try {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(file));
  } catch (e) {
    print('Error playing sound: $e');
  }
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
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
            Text(
              "Selected Numbers: ${widget.selectedNumbers.join(', ')}",
              style: const TextStyle(color: Colors.white),
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
            final gameProvider = Provider.of<GameProvider>(context, listen: false);

            bool result = await gameProvider.createGame(
              stakeAmount: widget.amount,
              numberOfPlayers: widget.selectedNumbers.length,
              cutAmountPercent: widget.cutAmountPercent,
              cartela: widget.selectedNumbers.length,
            );

            showDialog(
              barrierColor: const Color(0xFF1E1E2E),
              context: context,
              builder: (context) => AlertDialog(
                title: Text(result ? "✅ Success" : "❌ Failed"),
                content: Text(
                  result ? "Game created successfully!" : "Failed to create game.",
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
