import 'package:flutter/material.dart';

class NumberTile extends StatelessWidget {
  final int number;
  final bool isMarked;

  const NumberTile({
    super.key,
    required this.number,
    required this.isMarked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isMarked ? Colors.deepPurple : Colors.white,
        border: Border.all(color: Colors.deepPurple, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isMarked ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
