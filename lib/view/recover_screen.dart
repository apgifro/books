import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RecoverWithEmailScreen extends StatefulWidget {
  const RecoverWithEmailScreen({Key? key}) : super(key: key);

  @override
  State<RecoverWithEmailScreen> createState() => _RecoverWithEmailScreenState();
}

class _RecoverWithEmailScreenState extends State<RecoverWithEmailScreen> {
  TextEditingController _controladorEmail = TextEditingController();

  Future<void> signIn() async {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: _controladorEmail.text!);
      EasyLoading.instance.toastPosition =
          EasyLoadingToastPosition.bottom;
      EasyLoading.showToast('Email de recuperação enviado!');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);
    } catch (e) {
      EasyLoading.showToast('Erro ao enviar email de recuperação.');
      // Error
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
            Image.asset('images/recover.png'),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 30),
                  child: Row(
                    children: const [
                      Text(
                        'Recuperar senha',
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
              child: TextField(
                controller: _controladorEmail,
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
                  onPressed: signIn,
                  child: const Text(
                    'Enviar e-mail de recuperação',
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
