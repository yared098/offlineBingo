// import 'package:flutter/material.dart';

// void _showSelectedNumberDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (_) => AlertDialog(
//       title: const Text('Selected Number Patterns'),
//       content: SizedBox(
//         width: double.maxFinite,
//         child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: widget.selectedNumbers.length,
//           itemBuilder: (_, index) {
//             final number = widget.selectedNumbers[index];

//             final matches = cards.map((card) {
//               final key = findKeyForNumber(number, card);
//               return key != null && key.isNotEmpty
//                   ? 'Card ${card['cardId']} ➜ $key = $number'
//                   : null;
//             }).where((e) => e != null).toList();

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Number $number:",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 if (matches.isNotEmpty)
//                   ...matches.map((m) => Text(m!)).toList()
//                 else
//                   const Text("No match found"),
//                 const Divider(),
//               ],
//             );
//           },
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("Close"),
//         ),
//       ],
//     ),
//   );
// }
