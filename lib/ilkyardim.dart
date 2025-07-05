import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IlkYardimPage extends StatefulWidget {
  @override
  _IlkYardimPageState createState() => _IlkYardimPageState();
}

class _IlkYardimPageState extends State<IlkYardimPage> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('ilkyardimsorular').get();

      final allQuestions = querySnapshot.docs
          .map((doc) => {
                "id": doc.id,
                "question": doc["soru"],
                "options": [
                  doc["A"],
                  doc["B"],
                  doc["C"],
                  doc["D"],
                ],
                "correctAnswer": doc["cevap"],
              })
          .toList();

      allQuestions.shuffle();
      setState(() {
        questions = allQuestions.take(20).toList();
      });
    } catch (e) {
      print("Soruları yüklerken hata oluştu: $e");
    }
  }

  void answerQuestion(String selectedAnswer) {
    if (questions[currentQuestionIndex]["correctAnswer"] == selectedAnswer) {
      score++;
    }

    if (currentQuestionIndex + 1 < questions.length) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            "Test Tamamlandı!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Toplam puanınız: $score/${questions.length}",
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                "Kapat",
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("İlk Yardım Soruları"),
          backgroundColor: Colors.deepPurple,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Soru ${currentQuestionIndex + 1}/${questions.length}",
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Soru Metni
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      currentQuestion["question"],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Şıklar
                Expanded(
                  child: ListView.builder(
                    itemCount: currentQuestion["options"].length,
                    itemBuilder: (context, index) {
                      final option = currentQuestion["options"][index];
                      final harfler = ['A', 'B', 'C', 'D'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: ElevatedButton(
                          onPressed: () => answerQuestion(option),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            minimumSize: const Size.fromHeight(60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Text(
                                  harfler[index],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  option,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
