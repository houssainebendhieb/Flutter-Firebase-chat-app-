import 'package:chat_app/screen/chat_page.dart';
import 'package:chat_app/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screen/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    routes: {
      'chatApp': (context) => ChatPage(),
      'profileScreen': (context) => ProfileScreen()
    },
    home: 
    
    LoginPage(),
  ));
}
