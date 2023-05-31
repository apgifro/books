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
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Seja bem-vindo!',
                      speed: const Duration(milliseconds: 200),
                    ),
                  ],
                  totalRepeatCount: 4,
                  pause: const Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ),
              SizedBox(height: 25,),
              Image.asset('images/welcome.png'),
              SizedBox(height: 25,),
              ElevatedButton(onPressed: () {
                Navigator.of(context).pushNamed('/loginWithEmail');
              }, child: Text('Entrar')),
              TextButton(onPressed: () {
                Navigator.of(context).pushNamed('/registerWithEmail');
              }, child: Text('Criar uma nova conta')),
              SizedBox(height: 40,),
              Container(child: ElevatedButton(onPressed: () {}, child: Text('Entrar com Google')), width: screenWidth - 30,),
              SizedBox(height: 10,),
              Container(child: ElevatedButton(onPressed: () {}, child: Text('Entrar com Facebook')), width: screenWidth - 30,),
            ],
          ),
        ),
      ),
    );
  }
}
