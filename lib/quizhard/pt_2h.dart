import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/quizeasy/contentsquize.dart';

class QuizScreen2h extends StatefulWidget {
  const QuizScreen2h({super.key});

  @override
  State<QuizScreen2h> createState() => _QuizScreen2hState();
}

class _QuizScreen2hState extends State<QuizScreen2h>
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
      QuerySnapshot snapshot = await _firestore.collection('p_2h').get();
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return QuizQuestion(
          article: data['article'] ?? 'No Article Provided',
          question: data['question'] ?? 'No Question Provided',
          option: List<String>.from(data['option'] ?? []),
          correctAnswer: data['correctAnswer'] ?? 'No Correct Answer',
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
        title: const Text("Hard Quiz - Part II: Citizenship"),
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

class _QuizWidgetState extends State<QuizWidget>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  String? _selectedOption;
  int _score = 0;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
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
            ? "Excellent! That’s the right answer."
            : "The correct answer was:\n${widget.questions[_currentIndex].correctAnswer}",
        color: isCorrect ? Colors.greenAccent : Colors.redAccent,
        onNext: () {
          Navigator.pop(context);
          setState(() {
            _currentIndex++;
            _selectedOption = null;
          });
        },
      ),
    );
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      builder: (context) => _glassDialog(
        title: "🏁 Quiz Complete!",
        content: "Your Score: $_score / ${widget.questions.length}\nKeep it up!",
        color: const Color(0xFF3E7B87),
        onNext: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const Contents1()));
        },
      ),
    );
  }

  Widget _glassDialog({
    required String title,
    required String content,
    required Color color,
    required VoidCallback onNext,
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color)),
                const SizedBox(height: 12),
                Text(content,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Next",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFF3E7B87);
    const Color lightAccent = Color(0xFFB4D6CD);
    final question = widget.questions[_currentIndex];

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/hbg.jpg', fit: BoxFit.cover),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(color: Colors.black.withOpacity(0.5)),
        ),
        FadeTransition(
          opacity: _fadeController,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🔹 Article
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    question.article,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 20),

                // ❓ Question
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    question.question,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(height: 20),

                // 🔘 Options
                ...question.option.map((option) {
                  bool isSelected = option == _selectedOption;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? lightAccent.withOpacity(0.4)
                          : Colors.white.withOpacity(0.08),
                      border: Border.all(
                          color: isSelected ? lightAccent : Colors.transparent,
                          width: 2),
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

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentIndex > 0)
                      _modernButton("Previous", _previousQuestion, accentColor),
                    _modernButton("Next", _nextQuestion, lightAccent),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _modernButton(String label, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.9),
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

  QuizQuestion({
    required this.article,
    required this.question,
    required this.option,
    required this.correctAnswer,
  });
}
