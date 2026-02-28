import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/quizeasy/contentsquize.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizScreen3 extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen3> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<QuizQuestion>> _questionsFuture;

  @override
  void initState() {
    super.initState();
    _questionsFuture = _fetchQuestions();
  }

  Future<List<QuizQuestion>> _fetchQuestions() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('pt_3e').get();
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return QuizQuestion(
          article: data['article'] as String? ?? 'No Article Provided',
          question: data['question'] as String? ?? 'No Question Provided',
          option: List<String>.from(data['option'] ?? []),
          correctAnswer:
              data['correctAnswer'] as String? ?? 'No Correct Answer',
          audioUrl: data['audioUrl'] as String? ?? '', // Fetch audio URL
        );
      }).toList();
    } catch (e) {
      print('Error fetching questions: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        backgroundColor: const Color.fromARGB(255, 171, 128, 245),
      ),
      body: FutureBuilder<List<QuizQuestion>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No questions available.'));
          } else {
            return QuizWidget(questions: snapshot.data!);
          }
        },
      ),
    );
  }
}

class QuizWidget extends StatefulWidget {
  final List<QuizQuestion> questions;

  QuizWidget({required this.questions});

  @override
  _QuizWidgetState createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int _currentIndex = 0;
  String? _selectedOption;
  int _score = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _playPauseAudio(String url) async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _nextQuestion() {
    if (_selectedOption == null) return;

    bool isCorrect =
        _selectedOption == widget.questions[_currentIndex].correctAnswer;
    if (isCorrect) {
      _score++;
    }

    if (_currentIndex < widget.questions.length - 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isCorrect ? 'Correct!' : 'Wrong!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    isCorrect
                        ? 'Good job! That\'s the right answer.'
                        : 'Oops! The correct answer is ${widget.questions[_currentIndex].correctAnswer}.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _currentIndex++;
                        _selectedOption = null;
                        _isPlaying =
                            false; // Reset play state for next question
                        _audioPlayer
                            .stop(); // Stop audio when moving to next question
                      });
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      _showFinalScore();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _selectedOption = null;
        _isPlaying = false;
        _audioPlayer.stop();
      });
    }
  }

  void _showFinalScore() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    final int easyQuizzesIncrement = 1;
    final int totalQuizzesIncrement = 1;

    final DocumentReference userDocRef =
        _firestore.collection('users').doc(userId);

    await userDocRef.update({
      'easyQuizzesCompleted': FieldValue.increment(easyQuizzesIncrement),
      'totalQuizzesCompleted': FieldValue.increment(totalQuizzesIncrement),
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Quiz Over!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Your Score: $_score/${widget.questions.length}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _currentIndex = 0;
                      _score = 0;
                      _selectedOption = null;
                      _isPlaying = false; // Reset play state for restarting
                      _audioPlayer.stop(); // Stop audio when restarting quiz
                    });
                  },
                  child: Text('Restart Quiz'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => Contents1(),
                      ),
                    );
                  },
                  child: Text('Exit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= widget.questions.length) {
      return Center(
        child: Text(
          'Quiz Over!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
    }

    final question = widget.questions[_currentIndex];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question.article,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '                  Audio  :  ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ),
                  ),
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    color: Colors.deepPurple,
                    onPressed: () => _playPauseAudio(question.audioUrl),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.question,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: question.option
                        .map((option) => Container(
                              margin: EdgeInsets.only(bottom: 8),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _selectedOption == option
                                        ? Colors.deepPurple
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(option),
                                  onTap: () {
                                    setState(() {
                                      _selectedOption = option;
                                    });
                                  },
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _previousQuestion,
                        child: Text('Previous'),
                      ),
                      ElevatedButton(
                        onPressed: _nextQuestion,
                        child: Text('Next'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizQuestion {
  final String article;
  final String question;
  final List<String> option;
  final String correctAnswer;
  final String audioUrl;

  QuizQuestion({
    required this.article,
    required this.question,
    required this.option,
    required this.correctAnswer,
    required this.audioUrl,
  });
}
