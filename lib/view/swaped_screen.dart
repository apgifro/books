import 'package:books/models/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';

class SwapedScreen extends StatefulWidget {
  const SwapedScreen({Key? key}) : super(key: key);

  @override
  State<SwapedScreen> createState() => _SwapedScreenState();
}

class _SwapedScreenState extends State<SwapedScreen> {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String onlineUser = '';
  bool isLoading = true;
  List<Book> swapedBooks = [];
  Map<String, dynamic> fetch = {};

  Future<void> getSwap() async {
    await db.collection("libraries").get().then((event) {
      final allBooksLiked = db.collection("libraries");
      final query = allBooksLiked.where("userid", isEqualTo: onlineUser).where('nolibrary', isEqualTo: 'true');
      query.get().then(
            (querySnapshot) {
          swapedBooks.clear();
          for (var docSnapshot in querySnapshot.docs) {
            String bookid = docSnapshot.data()['bookid'];
            fetchOneBook(bookid).then((data) {
              fetch = data;
              setState(() {
                swapedBooks!.add(
                  Book(
                    bookID: bookid,
                    bookName: fetch['volumeInfo']['title'],
                    description: fetch['volumeInfo']['description'],
                    authors: fetch['volumeInfo']['authors'].join(),
                    urlBookImage: fetch['volumeInfo']['imageLinks']['thumbnail'],
                    swapEmail: docSnapshot.data()['swapip']
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
    onlineUser = user!.uid;
    getSwap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
              child: Row(
                children: const [
                  Text(
                    'Trocas',
                    style:
                        TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            isLoading
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: swapedBooks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Container(
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text('Trocou ${swapedBooks[index].bookName} com ${swapedBooks[index].swapEmail}',
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/book', arguments: swapedBooks[index]);
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
