import 'package:chat_app/widgets/buttonwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screen/register_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget build(context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    bool isLoading = false;
    void _SingIn() async {
      isLoading = true;
      setState(() {});
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        //showSnackBar(context, "succes");
        /*   Navigator.of(context)
            .pushNamed('chatApp', arguments: _emailController.text);*/
        Navigator.of(context)
            .pushNamed('profileScreen', arguments: _emailController.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found')
          showSnackBar(context, 'user not found');
        else if (e.code == 'wrong-password') {
          showSnackBar(context, 'incorrect password');
        }
        showSnackBar(context, e.message!);
      } catch (error) {
        showSnackBar(context, 'there is a problem');
      }
      isLoading = false;
      setState(() {});
    }

    GlobalKey<FormState> formKey = GlobalKey();
    return ModalProgressHUD(
      inAsyncCall: isLoading,
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
                  const Text('Sign In',
                      style: TextStyle(color: Colors.white, fontSize: 25)),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
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
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        hintText: 'password',
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Center(
                      child: TextButton(
                          child: Text('Sign In',
                              style: TextStyle(
                                  color: Colors.black38, fontSize: 25)),
                          onPressed: () {
                            _SingIn();
                          }),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('dont hava an account ',
                          style: TextStyle(color: Colors.white)),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return RegisterPage();
                            }));
                          },
                          child: Text('Sign UP',
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
