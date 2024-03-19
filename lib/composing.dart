import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ComposeNumbersScreen extends StatefulWidget {
  const ComposeNumbersScreen({super.key});

  @override
  _ComposeNumbersScreenState createState() => _ComposeNumbersScreenState();
}

class _ComposeNumbersScreenState extends State<ComposeNumbersScreen> {
  int firstNumber = 0;
  List<int> secondNumbers = [];
  List<bool> isSelected = [];
  Random random = Random();
  int score = 0;
  int secondsElapsed = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    generateNumbers();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  //generate the first number
  void generateNumbers() {
    setState(() {
      firstNumber = random.nextInt(999);
      //generate 3 numbers to compose the first number
      secondNumbers.clear();
      isSelected.clear();
      int smallerNumber = random.nextInt(firstNumber - 1) + 1;
      //2 out of 3 numbers are answers to compose the first number
      secondNumbers.add(smallerNumber);
      secondNumbers.add(firstNumber - smallerNumber);
      //1 out of 3 number is a random number
      secondNumbers.add(random.nextInt(999));
      secondNumbers.shuffle();
      isSelected = List.generate(3, (index) => false);
    });
  }

  //select 2 numbers to compose
  void toggleSelection(int index) {
    setState(() {
      if (isSelected[index]) {
        isSelected[index] = false;
      } else {
        int count = 0;
        for (int i = 0; i < isSelected.length; i++) {
          if (isSelected[i]) count++;
        }
        if (count < 2) {
          isSelected[index] = true;
        } else {
          //alert user that only 2 numbers can be selected to compose
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Alert"),
                content: const Text(
                    "You can only select up to 2 numbers. Please deselect before selecting another."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  //check whether compose correctly
  bool isSelectionCorrect() {
    int sum = 0;
    for (int i = 0; i < secondNumbers.length; i++) {
      if (isSelected[i]) {
        sum += secondNumbers[i];
      }
    }
    return sum == firstNumber;
  }

  //add feature - timer
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  //set timer format
  String getTimerText() {
    int minutes = (secondsElapsed / 60).truncate();
    int seconds = secondsElapsed % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
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
          title: const Text('Composing Number'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg2.jpg'),
              fit: BoxFit.fill,
              opacity: 0.8,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                const SizedBox(height: 20),
                Text(
                  'Select 2 numbers that compose $firstNumber',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    width: 70,
                    height: 70,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Text(
                        '$firstNumber',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < secondNumbers.length; i++)
                      GestureDetector(
                        onTap: () {
                          toggleSelection(i);
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: isSelected[i]
                                  ? Colors.lightBlue[300]
                                  : Colors.white,
                              border: Border.all(),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: Text(
                              '${secondNumbers[i]}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: generateNumbers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    'Generate Numbers',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    bool correct = isSelectionCorrect();
                    if (correct) {
                      generateNumbers();
                      //added feature - score
                      score++;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: correct ? Colors.green : Colors.red,
                        content: Text(
                          correct
                              ? 'Yeay! You composed the number correctly.'
                              : 'Opps! You composed the number wrongly.',
                          style: const TextStyle(color: Colors.white),
                        ),
                        duration: const Duration(milliseconds: 600),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
