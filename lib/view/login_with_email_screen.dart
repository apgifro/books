import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginWithEmailScreen extends StatefulWidget {
  const LoginWithEmailScreen({Key? key}) : super(key: key);

  @override
  State<LoginWithEmailScreen> createState() =>
      _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends State<LoginWithEmailScreen> {
  TextEditingController _controladorEmail = TextEditingController();
  TextEditingController _controladorSenha = TextEditingController();

  Future<void> signIn() async {
    try {
      var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _controladorEmail.text, password: _controladorSenha.text
      );
      bool? emailValidado = credential.user?.emailVerified;
      if (emailValidado!) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/home', (Route<dynamic> route) => false);
      } else {
        EasyLoading.showToast('Verifique seu e-mail antes de continuar');
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.instance.toastPosition = EasyLoadingToastPosition.center;
      EasyLoading.showToast('Não entrou');
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
        title: Text('Entrar'),
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
                onPressed: signIn, child: const Text('Entrar')),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
