import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      RotateAnimatedText('Descubra livros'),
                      RotateAnimatedText('Salve seus favoritos'),
                      RotateAnimatedText('Interaja com outros leitores'),
                      RotateAnimatedText('Crie uma conta agora!'),
                    ],
                    pause: const Duration(milliseconds: 1000),
                    stopPauseOnTap: true,
                    repeatForever: true,
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Image.asset('images/welcome.png'),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/loginWithEmail');
                  },
                  child: Text('Entrar', style: TextStyle(fontSize: 16),)),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/registerWithEmail');
                  },
                  child: Text('Criar uma nova conta', style: TextStyle(fontSize: 16),)),
              SizedBox(
                height: 40,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 35,
                          child: Image.asset('images/google.png')
                      ),
                      SizedBox(width: 25,),
                      Container(
                          height: 35,
                          child: Image.asset('images/facebook.png')
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
