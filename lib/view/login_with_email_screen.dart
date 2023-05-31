import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _controladorEmail.text, password: _controladorSenha.text
    );
    bool? emailValidado = credential.user?.emailVerified;
    Navigator.of(context).pushNamedAndRemoveUntil('/homeLogin', (Route<dynamic> route) => false);
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
