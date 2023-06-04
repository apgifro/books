import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:validatorless/validatorless.dart';

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

    try {
      FocusManager.instance.primaryFocus?.unfocus();
      EasyLoading.show(status: 'Criando');

      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _controladorEmail.text, password: _controladorSenha.text);
      final user = credential.user;
      if (user != null) user.sendEmailVerification();

      EasyLoading.dismiss();

      EasyLoading.instance.toastPosition = EasyLoadingToastPosition.bottom;
      EasyLoading.showToast('Conta criada!');

      Navigator.of(context).pushNamedAndRemoveUntil(
          '/checkYourEmail', (Route<dynamic> route) => false);
    } on FirebaseAuthException catch (e) {
      EasyLoading.instance.toastPosition = EasyLoadingToastPosition.center;
      EasyLoading.showToast('Conta não criada :(');
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
            Image.asset('images/create.png'),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 0, 30),
                  child: Row(
                    children: const [
                      Text(
                        'Crie uma nova conta',
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
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: screenWidth - 25,
              child: ElevatedButton(
                  onPressed: signUp,
                  child: const Text(
                    'Criar',
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
