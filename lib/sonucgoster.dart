import 'package:flutter/material.dart';
import 'package:mobilodev/anasayfa.dart';
import 'package:mobilodev/skorkaydet.dart'; // SkorKaydet import

class SonucGoster extends StatelessWidget {
  final int score;

  const SonucGoster({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    // Skoru Firestore'a kaydet
    SkorKaydet().kaydetSkor(score);

    bool isPassed = score >= 70;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Toplam Puanınız',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$score',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: isPassed ? Colors.greenAccent : Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isPassed ? 'Sınavı Geçtiniz!' : 'Sınavdan Kaldınız!',
                  style: TextStyle(
                    fontSize: 22,
                    color: isPassed ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const AnaSayfa()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Ana Menüye Dön',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
