import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math'; // Soruları karıştırmak için
import 'package:mobilodev/sonucgoster.dart';

class GenelSoru extends StatefulWidget {
  const GenelSoru({super.key});

  @override
  State<GenelSoru> createState() => _GenelSoruState();
}

class _GenelSoruState extends State<GenelSoru> {
  int _currentQuestionIndex = 0; // Mevcut soru
  int _score = 0; // Toplam puan
  late List<DocumentSnapshot> _questions; // Sorular
  bool _isLoading = true; // Sorular yükleniyor
  late DateTime _endTime; // Sınav bitiş süresi
  late Timer _timer; // Zamanlayıcı
  Duration _remainingTime = const Duration(minutes: 60); // Kalan süre

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Timer'ı durdurmayı unutmayalım
    super.dispose();
  }

  Future<void> _fetchQuestions() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('genelsorular')
        .get();

    List<DocumentSnapshot> allQuestions = snapshot.docs;

    allQuestions.shuffle(Random());

    setState(() {
      _questions = allQuestions.take(50).toList();
      _isLoading = false;
    });
  }

  void _startTimer() {
    _endTime = DateTime.now().add(_remainingTime);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = _endTime.difference(DateTime.now());
      });

      if (_remainingTime.isNegative) {
        _timer.cancel();
        _endExam();
      }
    });
  }

  void _endExam() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SonucGoster(score: _score),
      ),
    );
  }

  void _answerQuestion(String selectedAnswer) {
    String correctAnswer = _questions[_currentQuestionIndex]['cevap'];
    if (selectedAnswer == correctAnswer) {
      setState(() {
        _score += 2; // Doğru cevap 2 puan
      });
    }

    if (_currentQuestionIndex + 1 < _questions.length) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _endExam();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Yükleniyor...'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Geri navigasyon
            },
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    Map<String, dynamic> currentQuestion =
        _questions[_currentQuestionIndex].data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Soru ${_currentQuestionIndex + 1}/${_questions.length}'),
        actions: [
          Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            'Süre: ${_remainingTime.inMinutes}:${_remainingTime.inSeconds % 60} dk',
            style: const TextStyle(fontSize: 16),
          ),
        ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
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
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      currentQuestion['soru'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: ['A', 'B', 'C', 'D'].map(
                      (option) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () =>
                                _answerQuestion(currentQuestion[option]),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              minimumSize: const Size.fromHeight(60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    option,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '${currentQuestion[option]}',
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
                    ).toList(),
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
