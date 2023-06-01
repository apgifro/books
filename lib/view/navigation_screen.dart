import 'package:books/view/discover_screen.dart';
import 'package:books/view/friends_screen.dart';
import 'package:books/view/library_screen.dart';
import 'package:books/view/account_screen.dart';
import 'package:books/view/swap_screen.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const <Widget>[
          DiscoverScreen(),
          FriendsScreen(),
          SwapScreen(),
          LibraryScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 28.0,
        backgroundColor: Colors.blueAccent,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: 'Descubra',
              icon: Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.auto_stories),
              )),
          BottomNavigationBarItem(
              label: 'Amigos',
              icon: Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.people),
              )),
          BottomNavigationBarItem(
              label: 'Trocas',
              icon: Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.change_circle),
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
