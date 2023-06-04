import 'package:books/models/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String onlineUser = '';
  bool isLoading = true;
  List<Book> listLikedBooks = [];
  Map<String, dynamic> fetch = {};

  Future<void> getLibrary() async {
    await db.collection("libraries").get().then((event) {
      final allBooksLiked = db.collection("libraries");
      final query = allBooksLiked
          .where("userid", isEqualTo: onlineUser)
          .where('nolibrary', isEqualTo: 'false');
      query.get().then(
        (querySnapshot) {
          listLikedBooks.clear();
          for (var docSnapshot in querySnapshot.docs) {
            String bookid = docSnapshot.data()['bookid'];
            fetchOneBook(bookid).then((data) {
              fetch = data;
              setState(() {
                listLikedBooks!.add(
                  Book(
                    bookID: bookid,
                    bookName: fetch['volumeInfo']['title'],
                    description: fetch['volumeInfo']['description'],
                    authors: fetch['volumeInfo']['authors'].join(),
                    urlBookImage: fetch['volumeInfo']['imageLinks']
                        ['thumbnail'],
                  ),
                );
              });
            });
          }
          isLoading = !isLoading;
        },
        onError: (e) => print(e),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    final User? user = auth.currentUser;
    onlineUser = user!.email!;
    getLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
              child: Row(
                children: const [
                  Text(
                    'Biblioteca',
                    style:
                        TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            isLoading
                ? SingleChildScrollView(
                    child: Column(children: [
                      Image.asset('images/library.png'),
                      const Text(
                        'Seus livros aparecerão aqui!',
                        style: TextStyle(fontSize: 17),
                      ),
                    ]),
                  )
                : Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: listLikedBooks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Container(
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    listLikedBooks[index].bookName,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('/book',
                                arguments: listLikedBooks[index]);
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
