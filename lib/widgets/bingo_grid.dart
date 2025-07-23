import 'package:flutter/material.dart';
import 'number_tile.dart';

class BingoGrid extends StatelessWidget {
  final List<int> numbers;
  final Set<int> markedNumbers;

  const BingoGrid({
    super.key,
    required this.numbers,
    required this.markedNumbers,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: numbers.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // return NumberTile(
        //   number: numbers[index],
        //   isMarked: markedNumbers.contains(numbers[index]),
        // );
        return NumberTile(
  key: ValueKey(numbers[index]), // ✅ Unique key per number
  number: numbers[index],
  isMarked: markedNumbers.contains(numbers[index]),
);
      },
    );
  }
}
