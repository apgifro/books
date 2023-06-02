import 'dart:math';

import 'package:flutter/material.dart';

import '../models/api.dart';
import '../models/book.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {

  Map<String, dynamic> fetch = {};
  List<Book>? books = [];

  bool isLoading = true;

  final volumes = [
    'python',
    'flutter',
    'biologia',
    'historia',
    'carreira',
    'autoajuda'
  ];

  @override
  void initState() {
    super.initState();

    String random = volumes[Random().nextInt(volumes.length)];

    callFetchBooks(random);
  }

  void callFetchBooks(String content) {
    isLoading = true;
    fetchBooks(content).then((data) {
      setState(() {
        fetch = data;
        books?.clear();
        for (Map<String, dynamic> book in fetch['items']) {
          try {
            books!.add(Book(
                bookID: book['id'],
                bookName: book['volumeInfo']['title'],
                urlBookImage: book['volumeInfo']['imageLinks']['thumbnail']));
          } catch (e) {
            // Error;
          }
        }
      });
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Descobrir',
                    style:
                        TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: Colors.black12,
                      child: Icon(Icons.account_circle),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/account');
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
              child: Container(
                height: 70,
                child: TextField(
                  decoration: const InputDecoration(
                      labelText: 'Busque um livro, autor ou gênero',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search)),
                  onSubmitted: (String value) {
                    setState(() {
                      callFetchBooks(value);
                    });
                  },
                ),
              ),
            ),
            isLoading
                ? const Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 15.0,
                          childAspectRatio: 0.8,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 6.0),
                        itemCount: books?.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Book recipe = books![index];
                          return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('/book',
                                    arguments: recipe.bookID);
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 11.0),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            NetworkImage(recipe.urlBookImage),
                                        fit: BoxFit.cover)),
                              ));
                        }),
                  ),
          ],
        ),
      ),
    );
  }
}
