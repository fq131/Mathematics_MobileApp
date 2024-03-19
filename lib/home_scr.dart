import 'package:flutter/material.dart';
import 'compare_num.dart';
import 'asc_desc.dart';
import 'composing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        title: const Text('Individual Practical Assignment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome, Pick one to Start!',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompareNumberScreen()),
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 150,
                    child: Ink.image(
                      image: const AssetImage('assets/images/icon1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text(
                    'Compare Numbers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderSelectionScreen()),
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 150,
                    child: Ink.image(
                      image: const AssetImage('assets/images/icon2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text(
                    'Ordering of Numbers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ComposeNumbersScreen()),
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 150,
                    child: Ink.image(
                      image: const AssetImage('assets/images/icon3.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text(
                    'Composing Numbers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
