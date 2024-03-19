import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CompareNumberScreen extends StatefulWidget {
  const CompareNumberScreen({super.key});

  @override
  _CompareNumberScreenState createState() => _CompareNumberScreenState();
}

class _CompareNumberScreenState extends State<CompareNumberScreen> {
  int a = 0;
  int b = 0;
  int score = 0;
  int secondsElapsed = 0;
  Timer? timer;

//added feature - timer
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    generateRandomNumbers();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

//random generate 2 numbers to compare
  void generateRandomNumbers() {
    setState(() {
      a = Random().nextInt(999);
      b = Random().nextInt(999);
    });
  }

//alert for back button
  Future<bool> _showBackDialog() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Quit'),
            content: const Text('Are you sure you want to quit the game?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

//check for each answer
  void checkAnswer(String comparison) {
    bool isCorrect;
    switch (comparison) {
      case '>':
        isCorrect = a > b;
        break;
      case '<':
        isCorrect = a < b;
        break;
      default:
        isCorrect = false;
    }

//notify when right or wrong
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 1000),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        content: Text(
            isCorrect ? 'Correct! You got 1 mark!' : 'Incorrect! Try harder!'),
      ));
      if (isCorrect) {
        score++;
      } else {
        if (score > 0) {
          score--;
        }
      }
    });

    generateRandomNumbers();
  }

  //set timer format
  String getTimerText() {
    int minutes = (secondsElapsed / 60).truncate();
    int seconds = secondsElapsed % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          final result = await _showBackDialog();
          if (result) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Compare Numbers'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg1.jpg'),
              fit: BoxFit.cover,
              opacity: 0.8,
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Timer: ${getTimerText()}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Score: $score',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      a.toString(),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => checkAnswer('>'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellowAccent,
                          ),
                          child: const Text(
                            'Greater than',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => checkAnswer('<'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue[900],
                          ),
                          child: const Text(
                            'Smaller than',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      b.toString(),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
