import 'package:flutter/material.dart';
import 'package:offlinebingo/config/wining_pattern.dart';
import 'package:offlinebingo/widgets/pattern_grid.dart';

class SelectedNumbersPage extends StatefulWidget {
  final List<int> selectedNumbers;
  final List<Map<String, dynamic>> cards;
  final List<int> generatedNumbers;
  final int? openCardNumber; // optional: open dialog on load

  const SelectedNumbersPage({
    super.key,
    required this.selectedNumbers,
    required this.cards,
    required this.generatedNumbers,
    this.openCardNumber,
  });

  @override
  State<SelectedNumbersPage> createState() => _SelectedNumbersPageState();
}

class _SelectedNumbersPageState extends State<SelectedNumbersPage> {


  bool isPatternCompleted(List<String> pattern, Map<String, dynamic> card) {
    // Check if every cell in pattern exists in card AND
    // the number in that cell has been generated (i.e., called)
    for (final cell in pattern) {
      final number = card[cell];
      if (number == null || !widget.generatedNumbers.contains(number)) {
        return false;
      }
    }
    return true;
  }

  bool checkAnyTwoLineWin(Map<String, dynamic> card) {
    // Check if any of the 'anyTwoLine' patterns is fully matched
    for (final pattern in BingoPatterns.anyTwoLine) {
      if (isPatternCompleted(pattern, card)) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();

    // Open dialog if number was passed
    if (widget.openCardNumber != null) {
      // Delay to let page build
      Future.delayed(const Duration(milliseconds: 300), () {
        _showGridDialog(context, widget.openCardNumber!);
      });
    }
  }

  List<List<int>> convertCardToGridReversed(Map<String, dynamic> card) {
    return List.generate(5, (index) {
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
    final patternCard = widget.cards.firstWhere(
      (card) => card["cardId"] == selectedNumber,
      orElse: () => {},
    );

    if (patternCard.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No pattern found for card ID $selectedNumber")),
      );
      return;
    }

    final patternGrid = convertCardToGridReversed(patternCard);

    // Check if winner for this card based on anyTwoLine patterns
    final isWinner = checkAnyTwoLineWin(patternCard);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Pattern for $selectedNumber" + (isWinner ? " - 🎉 WINNER! 🎉" : ""),
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PatternGrid(
              pattern: patternGrid,
              generatedNumbers: widget.generatedNumbers,
            ),
            const SizedBox(height: 20),
            if (isWinner)
              Text(
                "This card has completed an 'Any Two Line' pattern!",
                style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
              )
            else
              Text(
                "No winning pattern completed yet.",
                style: const TextStyle(color: Colors.redAccent),
              )
          ],
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
    final pages = (widget.selectedNumbers.length / 20).ceil();

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text("እባክዎ ይምረጡ", style: TextStyle(color: Colors.amberAccent)),
        foregroundColor: Colors.amberAccent,
        elevation: 0,
      ),
      body: SizedBox(
        height: 250,
        child: PageView.builder(
          itemCount: pages,
          controller: PageController(viewportFraction: 0.95),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, pageIndex) {
            final start = pageIndex * 20;
            final end = (start + 20).clamp(0, widget.selectedNumbers.length);
            final currentSlice = widget.selectedNumbers.sublist(start, end);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 20,
                runSpacing: 10,
                children: currentSlice.map((number) {
                  return GestureDetector(
                    onTap: () => _showGridDialog(context, number),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 45,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[800],
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.amberAccent.withOpacity(0.6),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        "$number",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
