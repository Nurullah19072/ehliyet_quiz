import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobilodev/girisEkrani.dart';
import 'package:mobilodev/genelsoru.dart';
import 'package:mobilodev/tumskorgoster.dart';
import 'package:mobilodev/ilkyardim.dart';
import 'package:mobilodev/trafikvecevre.dart';
import 'package:mobilodev/motoraracteknigi.dart';
import 'package:mobilodev/genelskor.dart';

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Çıkış yapılamadı: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade700,
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade500, Colors.indigo.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hoş Geldiniz!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildButton('Genel Skorlar', context, GenelSkorPage()),
                  _buildButton('Tüm Skorlarım', context, const TumSkorGoster()),
                  _buildButton('Genel', context, const GenelSoru()),
                  _buildButton('İlk Yardım', context, IlkYardimPage()),
                  _buildButton('Trafik ve Çevre', context, TrafikVeCevrePage()),
                  _buildButton('Motor ve Araç Tekniği', context, MotorAracTeknikBilgisiPage()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String title, BuildContext context, Widget? nextPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          if (nextPage != null) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => nextPage),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber.shade700,
          minimumSize: const Size(200, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
