import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../lists/discover_screen.dart';
import '../lists/library_screen.dart';
import '../lists/swaped_screen.dart';


class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedPage,
        children: const [
          DiscoverScreen(),
          SwapedScreen(),
          LibraryScreen(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        iconSize: 28.0,
        currentIndex: _selectedPage,
        onTap: (index) => setState(() => _selectedPage = index),
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
