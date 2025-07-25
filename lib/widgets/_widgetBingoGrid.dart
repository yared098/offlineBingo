// import 'package:flutter/material.dart';

// class BingoGrid extends StatelessWidget {
//   final List<int> selectedNumbers;

//   const BingoGrid({super.key, required this.selectedNumbers});

//   @override
//   Widget build(BuildContext context) {
//     final List<List<String>> data = _generateBingoData();

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Container(
//             width: constraints.maxWidth > 400 ? 400 : constraints.maxWidth,
//             child: Column(
//               children: List.generate(5, (row) {
//                 return Row(
//                   children: List.generate(16, (col) {
//                     if (col == 0) {
//                       // BINGO header cell
//                       return Container(
//                         width: 20,
//                         height: 20,
//                         alignment: Alignment.center,
//                         // margin: const EdgeInsets.all(2),
//                         decoration: BoxDecoration(
//                           color: Colors.blueGrey[700],
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                         child: Text(
//                           "BINGO"[row],
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                             color: Colors.white,
//                           ),
//                         ),
//                       );
//                     }

//                     final number = int.parse(data[row][col - 1]);
//                     final isSelected = selectedNumbers.contains(number);

//                     return Container(
//                       width: 20,
//                       height: 20,
//                       alignment: Alignment.center,
//                       margin: const EdgeInsets.all(1),
//                       decoration: BoxDecoration(
//                         color: isSelected ? Colors.green : Colors.grey[850],
//                         borderRadius: BorderRadius.circular(3),
//                         border: Border.all(color: Colors.white24),
//                       ),
//                       child: Text(
//                         number.toString(),
//                         style: const TextStyle(
//                           fontSize: 10,
//                           color: Colors.white,
//                         ),
//                       ),
//                     );
//                   }),
//                 );
//               }),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   List<List<String>> _generateBingoData() {
//     List<List<String>> data = [];

//     // B: 1–15, I: 16–30, N: 31–45, G: 46–60, O: 61–75
//     for (int row = 0; row < 5; row++) {
//       List<String> rowData = [];
//       int start = row * 15 + 1;
//       for (int i = 0; i < 15; i++) {
//         rowData.add('${start + i}');
//       }
//       data.add(rowData);
//     }

//     return data;
//   }
// }


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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header: BINGO
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (col) {
                    return Container(
                      width: 30,
                      height: 30,
                      margin: const EdgeInsets.all(2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[700],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "BINGO"[col],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 4),

                // Grid: Columns of numbers under BINGO
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (col) {
                    return Column(
                      children: List.generate(15, (row) {
                        final number = int.parse(data[col][row]);
                        final isSelected = selectedNumbers.contains(number);

                        return Container(
                          width: 30,
                          height: 30,
                          margin: const EdgeInsets.all(1),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Colors.green : Colors.grey[850],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            number.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<List<String>> _generateBingoData() {
    List<List<String>> data = [];

    // Columns: B, I, N, G, O => ranges of 15 numbers each
    for (int col = 0; col < 5; col++) {
      List<String> columnData = [];
      int start = col * 15 + 1;
      for (int i = 0; i < 15; i++) {
        columnData.add('${start + i}');
      }
      data.add(columnData);
    }

    return data;
  }
}
