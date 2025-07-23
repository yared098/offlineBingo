import 'package:flutter/material.dart';

class BingoGrid extends StatelessWidget {
  final List<int> selectedNumbers;

  const BingoGrid({super.key, required this.selectedNumbers});

  @override
  Widget build(BuildContext context) {
    final List<List<String>> data = _generateBingoData();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: constraints.maxWidth > 400 ? 400 : constraints.maxWidth,
            child: Column(
              children: List.generate(5, (row) {
                return Row(
                  children: List.generate(16, (col) {
                    if (col == 0) {
                      // BINGO header cell
                      return Container(
                        width: 18,
                        height: 18,
                        alignment: Alignment.center,
                        // margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[700],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "BINGO"[row],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }

                    final number = int.parse(data[row][col - 1]);
                    final isSelected = selectedNumbers.contains(number);

                    return Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green : Colors.grey[850],
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        number.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  List<List<String>> _generateBingoData() {
    List<List<String>> data = [];

    // B: 1–15, I: 16–30, N: 31–45, G: 46–60, O: 61–75
    for (int row = 0; row < 5; row++) {
      List<String> rowData = [];
      int start = row * 15 + 1;
      for (int i = 0; i < 15; i++) {
        rowData.add('${start + i}');
      }
      data.add(rowData);
    }

    return data;
  }
}
