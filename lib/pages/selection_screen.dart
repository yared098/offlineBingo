import 'package:flutter/material.dart';
import 'package:offlinebingo/pages/game_screen.dart';

class NumberSelectionScreen extends StatefulWidget {
  @override
  _NumberSelectionScreenState createState() => _NumberSelectionScreenState();
}

class _NumberSelectionScreenState extends State<NumberSelectionScreen> {
  int betAmount = 20;
  List<int> selectedNumbers = [];
  String cutAmountPercent = '10%';

  void toggleNumber(int number) {
    setState(() {
      if (selectedNumbers.contains(number)) {
        selectedNumbers.remove(number);
      } else {
        selectedNumbers.add(number);
      }
    });
  }

  void startGame() {
      final cutAmount = int.tryParse(cutAmountPercent.replaceAll('%', '')) ?? 10;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BingoHomePage(selectedNumbers: selectedNumbers, amount: betAmount,
            cutAmountPercent: cutAmount,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2E),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E2E),
        title: Text(
          'Select Numbers',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        actions: [
          ElevatedButton(
            onPressed: startGame,
            child: Text('Start'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => setState(() => selectedNumbers.clear()),
            child: Text('Reset'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          buildTopControls(),
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.all(16),
              crossAxisCount: 10,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: List.generate(80, (index) {
                int number = index + 1;
                bool isSelected = selectedNumbers.contains(number);
                return GestureDetector(
                  onTap: () => toggleNumber(number),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$number',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text('Bet', style: TextStyle(color: Colors.white)),
          SizedBox(width: 8),
          IconButton(
            onPressed: () => setState(() {
              if (betAmount > 0) betAmount--;
            }),
            icon: Icon(Icons.remove, color: Colors.white),
          ),
          Text('$betAmount', style: TextStyle(color: Colors.white)),
          IconButton(
            onPressed: () => setState(() {
              betAmount++;
            }),
            icon: Icon(Icons.add, color: Colors.white),
          ),
          Spacer(),

          DropdownButton<String>(
            dropdownColor: Colors.grey[900],
            value: cutAmountPercent,
            items: ['10%', '20%', '50%']
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: TextStyle(color: Colors.white)),
                  ),
                )
                .toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  cutAmountPercent = val;
                });
              }
            },
          ),

          Spacer(),
          SizedBox(
            width: 100,
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cartela ID',
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
