import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobilodev/girisEkrani.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
      apiKey: "AIzaSyBPiPEHWqgzx1GZWvhfVKNvth7XjPHkA7k",
      authDomain: "mobil-80f96.firebaseapp.com",
      projectId: "mobil-80f96",
      storageBucket: "mobil-80f96.firebasestorage.app",
      messagingSenderId: "220461510810",
      appId: "1:220461510810:web:863a5988eae67a80ff6f23"),
    );
  }else{
      await Firebase.initializeApp();
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giriş ve Kayıt Ekranı',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthScreen(), // Ana sayfa olarak AuthScreen
    );
  }
}
