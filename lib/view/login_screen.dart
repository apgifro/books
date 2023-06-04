import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:validatorless/validatorless.dart';

class LoginWithEmailScreen extends StatefulWidget {
  const LoginWithEmailScreen({Key? key}) : super(key: key);

  @override
  State<LoginWithEmailScreen> createState() => _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends State<LoginWithEmailScreen> {
  TextEditingController _controladorEmail = TextEditingController();
  TextEditingController _controladorSenha = TextEditingController();

  Future<void> signIn() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      EasyLoading.show(status: 'Entrando');

      var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _controladorEmail.text, password: _controladorSenha.text);
      EasyLoading.dismiss();

      bool? emailValidado = credential.user?.emailVerified;
      if (emailValidado!) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      } else {
        EasyLoading.instance.toastPosition = EasyLoadingToastPosition.bottom;
        EasyLoading.showToast('Verifique seu e-mail');
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.instance.toastPosition = EasyLoadingToastPosition.center;
      EasyLoading.showToast('Erro ao entrar');
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
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('images/login.png'),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 30),
                  child: Row(
                    children: const [
                      Text(
                        'Entrar',
                        style: TextStyle(
                            fontSize: 26.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
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
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 5, 18, 5),
              child: TextFormField(
                controller: _controladorSenha,
                validator: Validatorless.required('Digite uma senha'),
                obscureText: true,
                decoration: const InputDecoration(
                    label: Text('Senha'),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.password_outlined)),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/recoverWithEmail');
                },
                child: const Text('Esqueceu sua senha?', style: TextStyle(fontSize: 16),)),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: screenWidth - 25,
              child: ElevatedButton(
                  onPressed: signIn,
                  child: const Text(
                    'Entrar',
                    style: TextStyle(fontSize: 16),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),

          ],
        ),
      ),
    );
  }
}
