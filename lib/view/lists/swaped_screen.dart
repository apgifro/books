import 'package:books/model/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/book.dart';

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
      final query = allBooksLiked
          .where("userid", isEqualTo: onlineUser)
          .where('swapid', isNotEqualTo: 'false');
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
                      urlBookImage: fetch['volumeInfo']['imageLinks']
                          ['thumbnail'],
                      swapEmail: docSnapshot.data()['swapid']),
                );
              });
            });
          }
        },
        onError: (e) => print(e),
      );
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    final User? user = auth.currentUser;
    onlineUser = user!.email!;
    getSwap();
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
                    'Trocas',
                    style:
                        TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            isLoading
                ? SingleChildScrollView(
                    child: Column(children: [
                      Image.asset('images/swap.png'),
                      const Text(
                        'Os livros que trocar aparecerão aqui!',
                        style: TextStyle(fontSize: 17),
                      ),
                    ]),
                  )
                : Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: swapedBooks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Container(
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 20, 0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 0, 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          swapedBooks[index].bookName,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        )),
                                        const Icon(Icons.chevron_right),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.black12,
                                            child: Icon(Icons.account_circle),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Você trocou com:'),
                                            Text(
                                              swapedBooks[index].swapEmail!,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('/book',
                                arguments: swapedBooks[index]);
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
