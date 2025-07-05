import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Tarih formatlama için kütüphane

class TumSkorGoster extends StatefulWidget {
  const TumSkorGoster({super.key});

  @override
  _TumSkorGosterState createState() => _TumSkorGosterState();
}

class _TumSkorGosterState extends State<TumSkorGoster> {
  List<Map<String, dynamic>> userScores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserScores();
  }

  Future<void> _fetchUserScores() async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        throw Exception('Kullanıcı giriş yapmamış!');
      }

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('skorlar')
          .where('id', isEqualTo: uid)
          .orderBy('skor', descending: true)
          .get();

      List<Map<String, dynamic>> fetchedScores = snapshot.docs.map((doc) {
        Timestamp timestamp = doc['tarih'] as Timestamp;
        DateTime dateTime = timestamp.toDate();
        String formattedDate =
            DateFormat('dd MMMM yyyy, HH:mm').format(dateTime);

        return {
          'id': doc['id'],
          'skor': int.tryParse(doc['skor'].toString()) ?? 0,
          'tarih': formattedDate,
        };
      }).toList();

      setState(() {
        userScores = fetchedScores;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veri çekme hatası: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kendi Skorlarım',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade700,
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : userScores.isEmpty
                ? const Center(
                    child: Text(
                      'Hiç skor bulunamadı.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: userScores.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: index % 2 == 0
                            ? Colors.orange.shade100
                            : Colors.teal.shade100,
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            'Skor: ${userScores[index]['skor']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            'Tarih: ${userScores[index]['tarih']}',
                            style: const TextStyle(
                              fontSize: 14,
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
