import 'package:flutter/material.dart';

class PatternShowPage extends StatefulWidget {
  const PatternShowPage({super.key});

  @override
  State<PatternShowPage> createState() => _PatternShowPageState();
}

class _PatternShowPageState extends State<PatternShowPage> {
  int currentPatternIndex = 0;

  final List<Map<String, dynamic>> patterns = [
    {
      "name": "Horizontal Line",
      "positions": List.generate(5, (i) => [2, i]),
    },
    {
      "name": "Vertical Line",
      "positions": List.generate(5, (i) => [i, 1]),
    },
    {
      "name": "Diagonal ↘️",
      "positions": List.generate(5, (i) => [i, i]),
    },
    {
      "name": "Diagonal ↙️",
      "positions": List.generate(5, (i) => [i, 4 - i]),
    },
    {
      "name": "Four Corners",
      "positions": [
        [0, 0],
        [0, 4],
        [4, 0],
        [4, 4],
      ],
    },
    {
      "name": "Full Card",
      "positions": List.generate(5, (i) => List.generate(5, (j) => [i, j])).expand((e) => e).toList(),
    },
  ];

  void _nextPattern() {
    setState(() {
      currentPatternIndex = (currentPatternIndex + 1) % patterns.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPattern = patterns[currentPatternIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      
      appBar: AppBar(
        title: const Text("Patterns"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currentPattern["name"],
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemCount: 25,
                itemBuilder: (context, index) {
                  int row = index ~/ 5;
                  int col = index % 5;

                  bool isActive = currentPattern["positions"]
                      .any((pos) => pos[0] == row && pos[1] == col);

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.greenAccent : Colors.grey[800],
                      border: Border.all(color: Colors.white54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "${row * 5 + col + 1}",
                        style: TextStyle(
                          color: isActive ? Colors.black : Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _nextPattern,
            icon: const Icon(Icons.change_circle),
            label: const Text("Next Pattern"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
