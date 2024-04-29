import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../db/SQLHelper.dart';
import '../widgets/exit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SQLHelper _db = SQLHelper.instance;
  int _unfinishedCount = 0;
  int _finishedCount = 0;
  int _totalists = 0;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final items = await _db.getAllItemsIn();
    final lists = await _db.getAllShoppingLists();
    int unfinishedCount = 0;
    int finishedCount = 0;
    for (var item in items) {
      if (item.isFinished) {
        finishedCount++;
      } else {
        unfinishedCount++;
      }
    }
    for (var slist in lists) {
      _totalists++;
    }
    setState(() {
      _unfinishedCount = unfinishedCount;
      _finishedCount = finishedCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              showExitDialog(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Your Stats",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 40),
            FadeInLeft(
              animate: true,
              duration: const Duration(milliseconds: 400),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 150,
                  maxWidth: 300,
                  minHeight: 50,
                  maxHeight: 100,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.deepPurpleAccent, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          '$_totalists Shopping Lists',
                          style: const TextStyle(
                              fontSize: 22, color: Colors.deepPurpleAccent),
                        ),
                      )),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeInLeft(
              animate: true,
              duration: const Duration(milliseconds: 600),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 150,
                  maxWidth: 300,
                  minHeight: 50,
                  maxHeight: 100,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        '$_unfinishedCount Waiting',
                        style: const TextStyle(fontSize: 22, color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeInLeft(
              animate: true,
              duration: const Duration(milliseconds: 800),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 150,
                  maxWidth: 300,
                  minHeight: 50,
                  maxHeight: 100,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          '$_finishedCount Bought',
                          style: const TextStyle(
                              fontSize: 22, color: Colors.green),
                        ),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
