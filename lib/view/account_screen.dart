import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  TextEditingController _controladorNome = TextEditingController();

  String displayName = 'Nome';
  late User onlineUser;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        onlineUser = user;
        _controladorNome.text = user.displayName!;
        // WARNING: Usar setState
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controladorNome.dispose();
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
            Image.asset('images/account.png'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 20),
              child: Row(
                children: const [
                  Text(
                    'Conta',
                    style:
                        TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 30),
              child: Row(
                children: const [
                  Text(
                    'Atualizar dados',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 5),
              child: Container(
                height: 50,
                child: TextField(
                  controller: _controladorNome,
                  decoration: const InputDecoration(
                      labelText: 'Qual o seu nome?',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_circle)),
                  onSubmitted: (String value) async {
                    try {
                      FocusManager.instance.primaryFocus?.unfocus();
                      EasyLoading.show(status: 'Atualizando');

                      FirebaseAuth.instance
                          .authStateChanges()
                          .listen((User? user) {
                        if (user != null) {
                          user?.updateDisplayName(_controladorNome.text);
                        }
                      });

                      EasyLoading.dismiss();

                      EasyLoading.instance.toastPosition =
                          EasyLoadingToastPosition.bottom;
                      EasyLoading.showToast('Dados atualizados');
                    } on FirebaseAuthException catch (e) {
                      EasyLoading.instance.toastPosition =
                          EasyLoadingToastPosition.center;
                      EasyLoading.showToast('Erro ao atualizar dados');
                    }
                  },
                ),
              ),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 3, 18, 20),
                  child: Text('Ele será exibido para outros usuários.'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 10),
              child: Row(
                children: const [
                  Text(
                    'Gerenciar',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 18, 10),
              child: Row(
                children: [
                  GestureDetector(
                    child: const Text(
                      'Sair',
                      style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                    ),
                    onTap: () {
                      try {
                        FirebaseAuth.instance.signOut();
                        EasyLoading.showToast('Saiu');
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/welcome', (Route<dynamic> route) => false);
                      } catch (e) {
                        EasyLoading.showToast('Erro ao sair');
                        // Error
                      }
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 18, 10),
              child: Row(
                children: [
                  GestureDetector(
                    child: const Text(
                      'Excluir conta',
                      style: TextStyle(fontSize: 15, color: Colors.redAccent),
                    ),
                    onTap: () {
                      try {
                        onlineUser?.delete();
                        EasyLoading.showToast('Conta excluída');
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/welcome', (Route<dynamic> route) => false);
                      } catch (e) {
                        EasyLoading.showToast('Erro ao excluir');
                        // Error
                      }
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 18, 10),
              child: Row(
                children: [
                  GestureDetector(
                    child: const Text(
                      'Recuperar senha',
                      style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                    ),
                    onTap: () {
                      try {
                        FirebaseAuth.instance.sendPasswordResetEmail(email: onlineUser.email!);
                        EasyLoading.instance.toastPosition =
                            EasyLoadingToastPosition.bottom;
                        EasyLoading.showToast('Email de recuperação enviado');
                      } catch (e) {
                        EasyLoading.showToast('Erro ao enviar email de recuperação');
                        // Error
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
