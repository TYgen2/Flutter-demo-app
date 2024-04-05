import 'package:demo_app/pages/home/home.dart';
import 'package:demo_app/services/auth.dart';
import 'package:demo_app/shared/constants.dart';
import 'package:demo_app/shared/loading.dart';
import 'package:demo_app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo_app/models/user.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<myUser?>(context);

    if (user == null) {
      return loading
          ? const Loading()
          : Theme(
              data: Provider.of<ThemeProvider>(context).defaultTheme,
              child: Scaffold(
                backgroundColor: Colors.grey[100],
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: const Text('Sign up'),
                ),
                body: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  child: Form(
                    // key to track the state of the form
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // email field
                        TextFormField(
                          decoration:
                              textImportDecoration.copyWith(hintText: 'Email'),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        const SizedBox(height: 20),
                        // password field
                        TextFormField(
                          decoration: textImportDecoration.copyWith(
                              hintText: 'Password'),
                          validator: (val) => val!.length < 6
                              ? 'Password should be longer than 6+ chars'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            // if validator all return null, validate() return true
                            if (_formKey.currentState!.validate()) {
                              // result can be null or user
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password);
                              if (result == null) {
                                setState(() {
                                  error = 'please enter a valid email';
                                  loading = false;
                                });
                              }
                            }
                          },
                          child: Text('Register'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown[200]),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          error,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
    } else {
      return const Home();
    }
  }
}
