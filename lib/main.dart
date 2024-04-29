import 'package:flutter/material.dart';

import 'pages/all_shopping_lists.dart';
import 'pages/home.dart';

void main() {
  runApp(const MyList());
}

class MyList extends StatefulWidget {
  const MyList({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyList> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const Home(),
    const AllShoppingLists(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurpleAccent,
        ),
      ),
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Shopping Lists',
            ),
          ],
        ),
      ),
    );
  }
}
