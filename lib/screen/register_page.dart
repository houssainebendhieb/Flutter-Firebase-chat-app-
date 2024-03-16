import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLeading = false;
  Widget build(context) {
    GlobalKey<FormState> formKey = GlobalKey();
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    Future<void> registerUser() async {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      users.add({
        'email': _emailController.text,
        'password': _passwordController.text
      });
    }

    void _SingUp() async {
      if (formKey.currentState!.validate()) {
        try {
          setState(() {
            isLeading = true;
          });
          await registerUser();
          _emailController.clear();
          _passwordController.clear();
          showSnackBar(context, 'succes');
          Navigator.of(context).pushNamed('chatApp');
        } on FirebaseAuthException catch (msg) {
          if (msg.code == 'weak-password')
            showSnackBar(context, 'weak password');
          else if (msg.code == 'email-already-in-use')
            showSnackBar(context, 'email alrady exists ');
        } catch (e) {
          showSnackBar(context, e.toString());
        }
        setState(() {
          isLeading = false;
        });
      }
    }

    return ModalProgressHUD(
      inAsyncCall: isLeading,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Color.fromARGB(255, 1, 62, 93),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 90,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        color: Colors.white,
                        Icons.message_outlined,
                        size: 60,
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Scholar Chat',
                          style: TextStyle(color: Colors.white, fontSize: 30)),
                    ],
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  const Text('Register',
                      style: TextStyle(color: Colors.white, fontSize: 25)),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (data) {
                      if (data!.trim().length == 0 || data.isEmpty)
                        return 'wrong answer';
                    },
                    controller: _emailController,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        hintText: 'Email',
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    validator: (data) {
                      if (data!.trim().length == 0 || data.isEmpty)
                        return 'wrong answer';
                    },
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        hintText: 'password',
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Center(
                      child: TextButton(
                          child: Text('Sign Up',
                              style: TextStyle(
                                  color: Colors.black38, fontSize: 25)),
                          onPressed: () {
                            _SingUp();
                          }),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('already have an account ',
                          style: TextStyle(color: Colors.white)),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Sign In',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)))
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  void showSnackBar(BuildContext context, String e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.toString())));
  }
}
