import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future<void> sigInWithGoogle() async {
    try {
      EasyLoading.show(status: 'Entrando');
      final GoogleSignIn googleSignIn = await GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser
          ?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential authResult = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final User? user = authResult.user;

      EasyLoading.dismiss();

      if (user != null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(
            '/home', (Route<dynamic> route) => false);
      }
    } catch (e) {
      EasyLoading.instance.toastPosition = EasyLoadingToastPosition.center;
      EasyLoading.showToast('Erro ao entrar');
      print(e);
    }

  }
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
              const SizedBox(
                height: 35,
              ),
              Image.asset('images/welcome.png'),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/loginWithEmail');
                  },
                  child: const Text('Entrar', style: TextStyle(fontSize: 16),)),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/registerWithEmail');
                  },
                  child: const Text('Criar uma nova conta', style: TextStyle(fontSize: 16),)),
              const SizedBox(
                height: 40,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: sigInWithGoogle,
                        child: Container(
                            height: 35,
                            child: Image.asset('images/google.png')
                        ),
                      ),
                      const SizedBox(width: 25,),
                      Container(
                          height: 35,
                          child: Image.asset('images/facebook.png')
                      ),
                      const SizedBox(width: 25,),
                      Container(
                          height: 35,
                          child: Image.asset('images/apple.png')
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
