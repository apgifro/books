import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../model/book.dart';

class BookScreen extends StatefulWidget {
  final Book receivedBook;
  const BookScreen({Key? key, required this.receivedBook}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  bool inLibrary = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  String onlineUser = '';

  @override
  void initState() {
    super.initState();
    final User? user = auth.currentUser;
    onlineUser = user!.email!;
    getStateInLibrary();
  }

  Future<void> getStateInLibrary() async {
    await db.collection("libraries").get().then((event) {
      final libraryState = db.collection("libraries");
      final query = libraryState
          .where("userid", isEqualTo: onlineUser)
          .where("bookid", isEqualTo: widget.receivedBook.bookID)
          .where('nolibrary', isEqualTo: 'false');
      query.get().then(
        (querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            setState(() {
              inLibrary = true;
            });
          }
        },
        onError: (e) => print(e),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              height: 240,
              width: 170,
              margin: const EdgeInsets.symmetric(horizontal: 11.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                      image: NetworkImage(widget.receivedBook.urlBookImage),
                      fit: BoxFit.cover)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 5),
            child: SizedBox(
              width: screenWidth - 30,
              child: Text(
                widget.receivedBook.bookName,
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: addOrRemoveFromLibrary,
                  icon: inLibrary
                      ? Icon(Icons.library_add)
                      : Icon(Icons.library_add_outlined)),
              ElevatedButton.icon(
                onPressed: swapBook,
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: inLibrary
                        ? Theme.of(context).primaryColor
                        : Colors.grey),
                label: const Text(
                  'Trocar com um amigo',
                ),
                icon: Icon(Icons.change_circle_outlined),
              )
            ],
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
              child: Container(
                height: 45,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 0, 18, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.person),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Autores',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            onTap: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Autores'),
                  content: Text(widget.receivedBook.authors),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Fechar'),
                    ),
                  ],
                ),
              );
            },
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Container(
                height: 45,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 0, 18, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.description_outlined),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Descrição',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            onTap: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Descrição'),
                  content: SingleChildScrollView(
                      child: Text(
                    widget.receivedBook.description,
                    textAlign: TextAlign.justify,
                  )),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Fechar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void addOrRemoveFromLibrary() {
    setState(() {
      inLibrary = !inLibrary;
      EasyLoading.instance.toastPosition = EasyLoadingToastPosition.bottom;
      if (inLibrary) {
        addToFirebaseLibrary();
        EasyLoading.showToast('Adicionado');
      } else {
        removeFromFirebaseLibrary();
        EasyLoading.showToast('Removido');
      }
    });
  }

  Future<void> addToFirebaseLibrary() async {
    final likedBook = <String, dynamic>{
      "userid": onlineUser,
      "bookid": widget.receivedBook.bookID,
      "swapid": "false",
      "nolibrary": "false",
    };

    db.collection("libraries").add(likedBook).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  Future<void> removeFromFirebaseLibrary() async {
    var collection = FirebaseFirestore.instance.collection('libraries');
    var snapshot = await collection
        .where('userid', isEqualTo: onlineUser)
        .where('bookid', isEqualTo: widget.receivedBook.bookID)
        .get();
    snapshot.docs[0].reference.delete();
  }

  void swapBook() {
    EasyLoading.instance.toastPosition = EasyLoadingToastPosition.bottom;
    if (inLibrary) {
      Navigator.of(context)
          .pushNamed('/swap', arguments: widget.receivedBook);
    } else {
      EasyLoading.showToast('Adicione a bilioteca para trocar!');
    }
  }
}
