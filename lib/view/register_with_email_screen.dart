import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RegisterWithEmailScreen extends StatefulWidget {
  const RegisterWithEmailScreen({Key? key}) : super(key: key);

  @override
  State<RegisterWithEmailScreen> createState() =>
      _RegisterWithEmailScreenState();
}

class _RegisterWithEmailScreenState extends State<RegisterWithEmailScreen> {
  TextEditingController _controladorEmail = TextEditingController();
  TextEditingController _controladorSenha = TextEditingController();

  Future<void> signUp() async {
    String message;

    EasyLoading.instance.toastPosition = EasyLoadingToastPosition.center;

    try {
      var credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _controladorEmail.text,
          password: _controladorSenha.text
      );
      EasyLoading.showToast('Conta criada!');

    } on FirebaseAuthException catch (e) {
      EasyLoading.showToast('Conta não criada :(dello');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controladorEmail.dispose();
    _controladorSenha.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Criar uma nova conta'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
              child: TextField(
                controller: _controladorEmail,
                decoration: const InputDecoration(
                  label: Text('E-mail'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
              child: TextField(
                controller: _controladorSenha,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text('Senha'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: signUp, child: const Text('Criar')),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
