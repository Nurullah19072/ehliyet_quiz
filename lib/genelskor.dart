import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GenelSkorPage extends StatefulWidget {
  @override
  _GenelSkorPageState createState() => _GenelSkorPageState();
}

class _GenelSkorPageState extends State<GenelSkorPage> {
  List<Map<String, dynamic>> skorListesi = [];

  @override
  void initState() {
    super.initState();
    fetchSkorlar();
  }

  Future<void> fetchSkorlar() async {
    try {
      final skorlarSnapshot =
          await FirebaseFirestore.instance.collection('skorlar').get();

      List<Map<String, dynamic>> fetchedSkorlar = [];
      for (var doc in skorlarSnapshot.docs) {
        final uid = doc["id"];
        final skor = doc["skor"];

        final kullaniciSnapshot = await FirebaseFirestore.instance
            .collection('kullanıcı')
            .doc(uid)
            .get();

        if (kullaniciSnapshot.exists) {
          final adSoyad = kullaniciSnapshot["ad_soyad"];
          fetchedSkorlar.add({
            "adSoyad": adSoyad,
            "skor": skor,
          });
        }
      }

      fetchedSkorlar.sort((a, b) => b["skor"].compareTo(a["skor"]));

      setState(() {
        skorListesi = fetchedSkorlar;
      });
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Genel Skorlar",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade400, Colors.indigo.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: skorListesi.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: skorListesi.length,
                itemBuilder: (context, index) {
                  final skorItem = skorListesi[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.amber.shade700,
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(
                        skorItem["adSoyad"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: Text(
                        "Skor: ${skorItem["skor"]}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}