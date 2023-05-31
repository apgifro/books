import 'package:books/view/discover_screen.dart';
import 'package:books/view/library_screen.dart';
import 'package:books/view/search_screen.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  final List<Widget> _screens = [
    const DiscoverScreen(),
    const SearchScreen(),
    const LibraryScreen(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 28.0,
        backgroundColor: Colors.blueAccent,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: 'Descubra',
              icon: Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.auto_stories),
              )),
          BottomNavigationBarItem(
              label: 'Pesquisar',
              icon: Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.search_outlined),
              )),
          BottomNavigationBarItem(
            label: 'Biblioteca',
            icon: Padding(
              padding: EdgeInsets.all(5.0),
              child: Icon(Icons.library_books),
            ),
          ),
        ],
      ),
    );
  }
}
