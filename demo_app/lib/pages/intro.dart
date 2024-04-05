import 'package:demo_app/models/user.dart';
import 'package:demo_app/pages/authenticate/register.dart';
import 'package:demo_app/pages/authenticate/sign_in.dart';
import 'package:demo_app/pages/home/home.dart';
import 'package:demo_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatefulWidget {
  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<myUser?>(context);

    if (user == null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: const AssetImage('lib/images/chiori.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.4), BlendMode.dstATop),
              )),
              child: null,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 60, 0, 10),
              child: Center(
                  child: Column(
                children: [
                  const Text(
                    'Genshin Collection Album',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Just some random art found on the Internet.\n I do not own any of them.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Three buttons
                  IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Sign in
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const SignIn()));
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        // Register
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const Register()));
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        // Visit as guest
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[500],
                            padding: const EdgeInsets.symmetric(horizontal: 80),
                          ),
                          child: const Text(
                            'Visit as a guest',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () async {
                            // dynamic: can be null or user
                            dynamic result = await _auth.signInAsGuest();
                            if (result == null) {
                              print('error signing in');
                            } else {
                              print('onPress: signed in as a guest');
                              print('onPress: ${result.uid}');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      );
    } else {
      return const Home();
    }
  }
}
