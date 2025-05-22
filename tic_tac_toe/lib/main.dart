import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 153, 71),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 153, 71),
        elevation: 0,
        title:
        Text('Tic Tac Toe', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TicTacToe()),
            );
          },
          child:
          Text('Start Game', style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ),
    );
  }
}

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<String> board = ['', '', '', '', '', '', '', '', ''];
  int playerTurn = 1; // 1 for player 1 (X), 2 for player 2 (O)
  bool gameEnded = false;
  int playerXScore = 0;
  int playerOScore = 0;
  List<int> winningCombination = [];
  int remainingTime = 30; // Time in seconds
  Timer? timer;
  bool timerRunning = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    if (!timerRunning) {
      remainingTime = 30;
      timerRunning = true;
      timer?.cancel();
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (remainingTime > 0) {
            remainingTime--;
          } else {
            timer.cancel();
            gameEnded = true;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 73, 178, 101),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 73, 178, 101),
        elevation: 0,
        title:
        Text('Tic Tac Toe', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
      Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                'Player O',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '$playerOScore',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'Player X',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '$playerXScore',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    ),
    Expanded(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Expanded(
    child: GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    mainAxisSpacing: 6,
    crossAxisSpacing: 6,
    ),
    padding: EdgeInsets.all(41),
    itemCount: 9,
    itemBuilder: (context, index) {
    return GestureDetector(
    onTap: gameEnded
    ? null
        : () {
    setState(() {
    if (board[index] == '') {
    board[index] = playerTurn == 1 ? 'X' : 'O';
    playerTurn = playerTurn == 1 ? 2 : 1;
    checkWinner();
    if (!gameEnded) startTimer();
    }
    });
    },
    child: Container(
    decoration: BoxDecoration(
    color: winningCombination.contains(index)
    ? Colors.blue
        : Colors.yellow,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.black),
    ),
    child: Center(
    child: Text(
    board[index],
    style: TextStyle(
    fontSize: 48,
    color: Colors.red,
    fontWeight: FontWeight.bold),
    ),
    ),
    ),
    );
    },
    ),
    ),
    // Adjust this value to move the timer up or down
    Stack(
    alignment: Alignment.center,
    children: [
    CircularProgressIndicator(
    value: remainingTime / 30,
    strokeWidth: 6,
    backgroundColor: Colors.grey[300],
    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    ),
    Text(
    '$remainingTime',
    style: TextStyle(
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.bold),
    ),
    ],
    ),
    ],
    ),
    ),
    SizedBox(
    height: 39,
    ),
    Padding(
    padding: const EdgeInsets.all(0.0),
    child: Text(
    gameEnded
    ? (winningCombination.isNotEmpty
    ? 'Game Over! ${getWinner()} wins!'
        : 'Game Over! It\'s a Draw!')
        : 'Player ${playerTurn == 1 ? 'X' : 'O'}\'s Turn',
    style: TextStyle(
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.bold),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(52.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    ElevatedButton(
    onPressed: resetScores,
    child: Text(
    'Reset Scores',
    style: TextStyle(fontWeight: FontWeight.bold),
    ),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.grey[300],
    foregroundColor: Colors.black,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
    ),
    ),
    ),
    ElevatedButton(
    onPressed: restartGame,
    child: Text(
    'Play Again!',
    style: TextStyle(fontWeight: FontWeight.bold),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.grey[300],
      foregroundColor: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    ),
    ],
    ),
    ),
          ],
      ),
    );
  }

  void checkWinner() {
    // Define winning combinations
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      if (board[combination[0]] != '' &&
          board[combination[0]] == board[combination[1]] &&
          board[combination[0]] == board[combination[2]]) {
        setState(() {
          gameEnded = true;
          winningCombination = combination;
          if (board[combination[0]] == 'X') {
            playerXScore++;
          } else {
            playerOScore++;
          }
        });
        timer?.cancel(); // Stop the timer
        return;
      }
    }

    // Check if the board is full and no winner is found
    if (!board.contains('')) {
      setState(() {
        gameEnded = true;
      });
      timer?.cancel(); // Stop the timer
    }
  }

  String getWinner() {
    return winningCombination.isNotEmpty ? board[winningCombination[0]] : '';
  }

  void restartGame() {
    setState(() {
      board = ['', '', '', '', '', '', '', '', ''];
      playerTurn = 1;
      gameEnded = false;
      winningCombination = [];
      timerRunning = false;
      startTimer();
    });
  }

  void resetScores() {
    setState(() {
      playerXScore = 0;
      playerOScore = 0;
      restartGame();
    });
  }
}

void throwException() {
  throw Exception("This is a demo of logcat");
}

// done 