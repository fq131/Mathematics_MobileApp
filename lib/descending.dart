import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class DescendingOrderNumbersScreen extends StatefulWidget {
  const DescendingOrderNumbersScreen({super.key});

  @override
  _DescendingOrderNumbersScreenState createState() =>
      _DescendingOrderNumbersScreenState();
}

class _DescendingOrderNumbersScreenState
    extends State<DescendingOrderNumbersScreen> {
  List<int> numbers = [];
  List<int> orderedNumbers = [];
  List<int> userArrangement = [];
  bool submitted = false;
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

  //random generate 5 numbers
  void generateNumbers() {
    numbers.clear();
    Set<int> generatedNumbers = <int>{}; //check no repeated numbers
    while (numbers.length < 5) {
      int randomNumber = Random().nextInt(999);
      if (!generatedNumbers.contains(randomNumber)) {
        numbers.add(randomNumber);
        generatedNumbers.add(randomNumber);
      }
    }
    setState(() {
      orderedNumbers = List.from(numbers);
      //descending
      orderedNumbers.sort((a, b) => b.compareTo(a));
      submitted = false;
      userArrangement.clear();
    });
  }

  void submitArrangement() {
    bool allCorrect = true;
    for (int i = 0; i < userArrangement.length; i++) {
      if (userArrangement[i] != orderedNumbers[i]) {
        allCorrect = false;
        userArrangement.removeAt(i);
        i--;
      }
    }

    //added feature - score
    //once all sequence correct 1 mark is awarded
    if (allCorrect) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Congratulations!'),
            content: const Text('You arranged the numbers correctly.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  generateNumbers();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      score++;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 600),
          content: Text('Try Again'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      submitted = true;
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

  //add timer feature
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
          title: const Text('Descending Order'),
        ),
        body: Center(
          child: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg3.jpg'),
          fit: BoxFit.cover,
          opacity: 0.7,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Arrange the numbers in Descending Order',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              5,
              (index) => Draggable<int>(
                data: numbers[index],
                feedback: Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.purple[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    numbers[index].toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                childWhenDragging: Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    numbers[index].toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                child: Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    numbers[index].toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              5,
              (index) => DragTarget<int>(
                builder: (context, candidateData, rejectedData) {
                  int? draggedNumber;
                  if (index < userArrangement.length) {
                    draggedNumber = userArrangement[index];
                  }
                  return Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                      color: submitted && orderedNumbers[index] != draggedNumber
                          ? Colors.red.withOpacity(0.3)
                          : Colors.transparent,
                    ),
                    child: Text(
                      draggedNumber != null ? draggedNumber.toString() : '',
                      style: const TextStyle(fontSize: 24),
                    ),
                  );
                },
                onWillAcceptWithDetails: (DragTargetDetails<int> details) =>
                    !userArrangement.contains(details.data),
                onAcceptWithDetails: (details) {
                  setState(() {
                    if (userArrangement.length <= index) {
                      userArrangement.add(details.data);
                    } else {
                      userArrangement[index] = details.data;
                    }
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Score: $score',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Timer: ${getTimerText()}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              generateNumbers();
            },
            child: const Text(
              'Generate New Numbers',
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: submitArrangement,
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
