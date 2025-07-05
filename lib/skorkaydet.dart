import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SkorKaydet {
  // Skoru kaydetmek için metot
  Future<void> kaydetSkor(int skor) async {
    try {
      // Firebase Authentication'dan kullanıcı UID'sini al
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        throw Exception("Kullanıcı kimliği alınamadı!");
      }

      // Firestore'daki "skorlar" koleksiyonuna yeni bir skor ekle
      await FirebaseFirestore.instance.collection('skorlar').add({
        'id': uid, // Kullanıcının UID'si
        'skor': skor, // Puan
        'tarih': FieldValue.serverTimestamp(), // Skor tarihi
      });

      print("Skor Firestore'a başarıyla kaydedildi!");
    } catch (e) {
      print("Skor kaydedilirken bir hata oluştu: $e");
    }
  }
}
