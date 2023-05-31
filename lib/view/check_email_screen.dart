import 'package:flutter/material.dart';

class CheckYourEmailScreen extends StatefulWidget {
  const CheckYourEmailScreen({Key? key}) : super(key: key);

  @override
  State<CheckYourEmailScreen> createState() => _CheckYourEmailScreenState();
}

class _CheckYourEmailScreenState extends State<CheckYourEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('images/email_sent.png'),
              SizedBox(height: 25,),
              Text('Verifique sua caixa de e-mail'),
              Text('Inclusive a pasta spam'),
              Text('E após validar seu e-mail'),
              Text('Volte e faça seu login!'),
              SizedBox(height: 25,),
              ElevatedButton(onPressed: () {
                Navigator.of(context).pushNamed('/welcome');
              }, child: Text('Voltar para a tela inicial')),
            ],
          ),
        ),
      ),
    );
  }
}
