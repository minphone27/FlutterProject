import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:simp_3/pages/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Mono',
    ),
    home: LoginPage(),
  ));
}
