import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:validatorless/validatorless.dart';

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
        // WARNING: Não use em conjunto com setState
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
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
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
              padding: const EdgeInsets.fromLTRB(20, 25, 0, 30),
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
                height: 70,
                child: TextFormField(
                  controller: _controladorNome,
                  validator: Validatorless.required('Digite seu nome'),
                  decoration: const InputDecoration(
                      labelText: 'Qual o seu nome?',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_circle)),
                  onFieldSubmitted: (String value) async {
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
              child: Row(
                children: const [
                  Text(
                    'Entrar',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Container(
                height: 45,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 0, 18, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.logout),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Sair',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Deseja sair?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          try {
                            FirebaseAuth.instance.signOut();
                            EasyLoading.instance.toastPosition =
                                EasyLoadingToastPosition.bottom;
                            EasyLoading.showToast('Saiu');
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/welcome', (Route<dynamic> route) => false);
                          } catch (e) {
                            EasyLoading.showToast('Erro ao sair');
                            // Error
                          }
                        },
                        child: const Text('Sair', style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                );
              },
            ),
            GestureDetector(
              child: Container(
                color: Colors.white,
                height: 45,
                padding: const EdgeInsets.fromLTRB(20, 0, 18, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.delete_outline, color: Colors.redAccent,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Excluir',
                            style: TextStyle(fontSize: 15, color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Excluir sua conta?',),
                    content: const Text('Essa ação não pode ser desfeita.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
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
                        child: const Text('Excluir', style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                );
              },
            ),
            GestureDetector(
              child: Container(
                height: 45,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 0, 18, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.lock_outline),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Editar senha',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Recuperar sua senha?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          try {
                            FirebaseAuth.instance.sendPasswordResetEmail(email: onlineUser.email!);
                            EasyLoading.instance.toastPosition =
                                EasyLoadingToastPosition.bottom;
                            EasyLoading.showToast('Email de recuperação enviado!');
                          } catch (e) {
                            EasyLoading.showToast('Erro ao enviar email de recuperação.');
                            // Error
                          }
                          Navigator.pop(context, 'Close');
                        },
                        child: const Text('Enviar e-mail'),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}
