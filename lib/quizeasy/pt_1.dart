import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/quizeasy/contentsquize.dart';

class QuizScreen1 extends StatefulWidget {
  const QuizScreen1({super.key});

  @override
  State<QuizScreen1> createState() => _QuizScreen1State();
}

class _QuizScreen1State extends State<QuizScreen1>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<QuizQuestion>> _questionsFuture;

  @override
  void initState() {
    super.initState();
    _questionsFuture = _fetchQuestions();
  }

  Future<List<QuizQuestion>> _fetchQuestions() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('pt_2e').get();
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return QuizQuestion(
          article: data['article'] ?? 'No Article Provided',
          question: data['question'] ?? 'No Question Provided',
          option: List<String>.from(data['option'] ?? []),
          correctAnswer: data['correctAnswer'] ?? 'No Correct Answer',
          audioUrl: data['audioUrl'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error fetching questions: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1B2D33);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Constitution Quiz"),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<List<QuizQuestion>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No questions available.', style: TextStyle(color: Colors.white)),
            );
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

  const QuizWidget({super.key, required this.questions});

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> with TickerProviderStateMixin {
  int _currentIndex = 0;
  String? _selectedOption;
  int _score = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPauseAudio(String url) async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.play(UrlSource(url));
      setState(() => _isPlaying = true);
    }
  }

  void _nextQuestion() {
    if (_selectedOption == null) return;
    bool isCorrect =
        _selectedOption == widget.questions[_currentIndex].correctAnswer;
    if (isCorrect) _score++;

    if (_currentIndex < widget.questions.length - 1) {
      _showFeedbackDialog(isCorrect);
    } else {
      _showFinalScore();
    }
  }

  void _showFeedbackDialog(bool isCorrect) {
    showDialog(
      context: context,
      builder: (context) => _glassDialog(
        title: isCorrect ? "✅ Correct!" : "❌ Wrong!",
        content: isCorrect
            ? "Good job! That’s the right answer."
            : "Oops! The correct answer is:\n${widget.questions[_currentIndex].correctAnswer}",
        color: isCorrect ? Colors.greenAccent : Colors.redAccent,
        onNext: () {
          Navigator.pop(context);
          setState(() {
            _currentIndex++;
            _selectedOption = null;
            _isPlaying = false;
            _audioPlayer.stop();
          });
        },
      ),
    );
  }

  void _showFinalScore() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await _firestore.collection('users').doc(userId).update({
      'easyQuizzesCompleted': FieldValue.increment(1),
      'totalQuizzesCompleted': FieldValue.increment(1),
    });

    showDialog(
      context: context,
      builder: (context) => _glassDialog(
        title: "🏁 Quiz Over!",
        content:
            "Your Score: $_score / ${widget.questions.length}\nGreat job!",
        color: Colors.tealAccent,
        onNext: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const Contents1()));
        },
        extraButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white24,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              _currentIndex = 0;
              _selectedOption = null;
              _score = 0;
            });
          },
          child: const Text("Restart Quiz",
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _glassDialog({
    required String title,
    required String content,
    required Color color,
    required VoidCallback onNext,
    Widget? extraButton,
  }) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: TextStyle(
                        color: color,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(content,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Next",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                if (extraButton != null) ...[
                  const SizedBox(height: 12),
                  extraButton,
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _selectedOption = null;
        _audioPlayer.stop();
        _isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentIndex];
    const Color accentColor = Color(0xFF3E7B87);
    const Color lightAccent = Color(0xFFB4D6CD);

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/hbg.jpg', fit: BoxFit.cover),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(color: Colors.black.withOpacity(0.5)),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🧾 Article & Audio
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black45,
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        question.article,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _playPauseAudio(question.audioUrl),
                      child: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: _pulseController,
                        color: lightAccent,
                        size: 34,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ❓ Question
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text(
                  question.question,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),

              // 🔘 Options
              ...question.option.map((option) {
                bool isSelected = option == _selectedOption;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? lightAccent.withOpacity(0.4)
                        : Colors.white.withOpacity(0.08),
                    border: Border.all(
                      color: isSelected ? lightAccent : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(option,
                        style: const TextStyle(color: Colors.white)),
                    onTap: () => setState(() => _selectedOption = option),
                  ),
                );
              }),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _modernButton("Previous", _previousQuestion, accentColor),
                  _modernButton("Next", _nextQuestion, lightAccent),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _modernButton(String label, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.8),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        shadowColor: color.withOpacity(0.4),
      ),
      child: Text(label,
          style: const TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
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
