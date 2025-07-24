import 'package:flutter/material.dart';

class PatternGrid extends StatelessWidget {
  final List<List<int>> pattern;
  final List<int> generatedNumbers;

  const PatternGrid({
    super.key,
    required this.pattern,
    required this.generatedNumbers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['B', 'I', 'N', 'G', 'O']
              .map(
                (e) => Text(
                  e,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        Column(
          children: pattern.map((row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((number) {
                final isMatched =
                    number != 0 && generatedNumbers.contains(number);
                return Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.all(2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: number == 0
                        ? Colors.transparent
                        : isMatched
                        ? Colors.green
                        : Colors.blueGrey[700],
                    borderRadius: BorderRadius.circular(6),
                    border: number != 0
                        ? Border.all(color: Colors.white24)
                        : null,
                  ),
                  child: number == 0
                      ? const SizedBox()
                      : Text(
                          "$number",
                          style: const TextStyle(color: Colors.white),
                        ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ],
    );
  }
}
