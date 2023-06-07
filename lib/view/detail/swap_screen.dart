import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:validatorless/validatorless.dart';

import '../../model/book.dart';

class SwapScreen extends StatefulWidget {
  final Book receivedBook;
  const SwapScreen({Key? key, required this.receivedBook}) : super(key: key);

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  TextEditingController _controladorEmail = TextEditingController();

  bool inLibrary = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  String onlineUser = '';
  bool isLoading = true;
  List<Book> listSwipedBooks = [];
  Map<String, dynamic> fetch = {};

  Future<void> getStateInLibrary() async {
    await db.collection("libraries").get().then((event) {
      final libraryState = db.collection("libraries");
      final query = libraryState
          .where("userid", isEqualTo: onlineUser)
          .where("bookid", isEqualTo: widget.receivedBook.bookID);
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
  void initState() {
    super.initState();
    final User? user = auth.currentUser;
    onlineUser = user!.email!;
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
          Image.asset('images/swap.png'),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 30),
                child: Row(
                  children: const [
                    Text(
                      'Com quem trocar?',
                      style: TextStyle(
                          fontSize: 26.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 5),
                child: TextFormField(
                  controller: _controladorEmail,
                  validator: Validatorless.multiple([
                    Validatorless.email('Digite um e-mail válido'),
                    Validatorless.required('Digite um e-mail válido')
                  ]),
                  decoration: const InputDecoration(
                      label: Text('E-mail'),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: screenWidth - 25,
                child: ElevatedButton(
                    onPressed: swapBook,
                    child: const Text(
                      'Trocar',
                      style: TextStyle(fontSize: 16),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ]
      )
    );
  }

  Future<void> swapBook() async {
      EasyLoading.instance.toastPosition = EasyLoadingToastPosition.bottom;

      var collection = FirebaseFirestore.instance.collection('libraries');

      var snapshot = await collection
          .where('userid', isEqualTo: onlineUser)
          .where('bookid', isEqualTo: widget.receivedBook.bookID)
          .get();

      snapshot.docs[0].reference.update(<String, dynamic>{
        'swapid': _controladorEmail.text,
        'nolibrary': 'true'
      });

      final swapBook = <String, dynamic>{
        "userid": _controladorEmail.text,
        "bookid": widget.receivedBook.bookID,
        "swapid": onlineUser,
        "nolibrary": "false",
      };

      db.collection("libraries").add(swapBook).then((DocumentReference doc) =>
          print('DocumentSnapshot added with ID: ${doc.id}'));

      EasyLoading.showToast('Trocado');

      Navigator.of(context).pop();
  }
}
