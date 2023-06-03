import 'package:books/view/discover_screen.dart';
import 'package:books/view/friends_screen.dart';
import 'package:books/view/library_screen.dart';
import 'package:books/view/swap_screen.dart';
import 'package:books/view/swaped_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  int _currentIndex = 0;

  final List<Widget> _screens = [
    DiscoverScreen(),
    SwapedScreen(),
    LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CupertinoTabBar(
        iconSize: 28.0,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: 'Descubra',
              icon: Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.auto_stories_outlined),
              )),
          BottomNavigationBarItem(
              label: 'Trocas',
              icon: Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.change_circle_outlined),
              )),
          BottomNavigationBarItem(
            label: 'Biblioteca',
            icon: Padding(
              padding: EdgeInsets.all(5.0),
              child: Icon(Icons.library_books_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
