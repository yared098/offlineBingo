// import 'package:flutter/material.dart';

// class PatternGrid extends StatelessWidget {
//   final List<List<int>> pattern;
//   final List<int> generatedNumbers;

//   const PatternGrid({
//     super.key,
//     required this.pattern,
//     required this.generatedNumbers,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: ['B', 'I', 'N', 'G', 'O']
//               .map(
//                 (e) => Text(
//                   e,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               )
//               .toList(),
//         ),
//         const SizedBox(height: 8),
//         Column(
//           children: pattern.map((row) {
//             return Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: row.map((number) {
//                 final isMatched =
//                     number != 0 && generatedNumbers.contains(number);
//                 return Container(
//                   width: 40,
//                   height: 40,
//                   margin: const EdgeInsets.all(2),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: number == 0
//                         ? Colors.transparent
//                         : isMatched
//                         ? Colors.green
//                         : Colors.blueGrey[700],
//                     borderRadius: BorderRadius.circular(6),
//                     border: number != 0
//                         ? Border.all(color: Colors.white24)
//                         : null,
//                   ),
//                   child: number == 0
//                       ? const SizedBox()
//                       : Text(
//                           "$number",
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                 );
//               }).toList(),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';

class PatternGrid extends StatelessWidget {
  final List<List<int>> pattern;
  final List<int> generatedNumbers;

  const PatternGrid({
    super.key,
    required this.pattern,
    required this.generatedNumbers,
  });

  // Check if all numbers except center (free space) are matched
  bool get isWinner {
    for (int i = 0; i < pattern.length; i++) {
      for (int j = 0; j < pattern[i].length; j++) {
        // Skip center cell (usually row=2, col=2)
        if (i == 2 && j == 2) continue;

        int num = pattern[i][j];
        if (num != 0 && !generatedNumbers.contains(num)) {
          return false; // found unmatched number
        }
      }
    }
    return true;
  }

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
                  style: const TextStyle(
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
          children: List.generate(pattern.length, (i) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pattern[i].length, (j) {
                final number = pattern[i][j];
                final isCenterCell = (i == 2 && j == 2);
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
                        : (isCenterCell
                            ? Colors.orangeAccent
                            : (isMatched ? Colors.green : Colors.blueGrey[700])),
                    borderRadius: BorderRadius.circular(6),
                    border: number != 0
                        ? Border.all(color: Colors.white24)
                        : null,
                  ),
                  child: isCenterCell
                      ? const Text(
                          "FREE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : (number == 0
                          ? const SizedBox()
                          : Text(
                              "$number",
                              style: const TextStyle(color: Colors.white),
                            )),
                );
              }),
            );
          }),
        ),
        const SizedBox(height: 16),
        if (isWinner)
          const Center(
            child: Text(
              "🎉 Congratulations! You won! 🎉",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
