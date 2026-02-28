import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_signup/screens/dashpage.dart';

class MatchGameScreen extends StatefulWidget {
  @override
  _MatchGameScreenState createState() => _MatchGameScreenState();
}

class _MatchGameScreenState extends State<MatchGameScreen> {
  List<String> laws = [];
  Map<String, String> descriptions = {};
  Map<String, String?> matched = {};
  Map<String, bool> isCorrect = {};
  List<String> availableLaws = [];
  bool showResult = false;
  DocumentSnapshot? currentMatchDocument;
  int currentMatchIndex = 0;
  List<DocumentSnapshot>? matchDocuments;

  @override
  void initState() {
    super.initState();
    fetchMatchData();
  }

  Future<void> fetchMatchData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('matchData')
          .orderBy(FieldPath.documentId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        matchDocuments = snapshot.docs;
        currentMatchDocument = matchDocuments![currentMatchIndex];
        setDataFromDocument(currentMatchDocument!);
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void setDataFromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    laws = List<String>.from(data['laws']);
    descriptions = Map<String, String>.from(data['descriptions']);
    matched = {for (var law in laws) law: null};
    isCorrect = {for (var law in laws) law: false};
    availableLaws = List.from(laws);
    setState(() {});
  }

  void checkAnswers() {
    for (var law in laws) {
      isCorrect[law] = matched[law] == law;
    }
    setState(() => showResult = true);
  }

  void showCorrectAnswersDialog() {
    final incorrectAnswers = laws.where((law) => !isCorrect[law]!).toList();
    final correctAnswers = laws
        .where((law) => isCorrect[law]!)
        .map((law) => '$law: ${descriptions[law]}')
        .join('\n');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B2D33),
        title: const Text("Results",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Correct Answers:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              Text(
                correctAnswers.isEmpty ? "None" : correctAnswers,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              const Text('Incorrect Answers:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              Text(
                incorrectAnswers.isEmpty
                    ? "No incorrect answers 🎉"
                    : incorrectAnswers.join('\n'),
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              nextMatch();
            },
            child: const Text("Next Match",
                style: TextStyle(color: Colors.tealAccent)),
          ),
        ],
      ),
    );
  }

  void nextMatch() {
    if (matchDocuments == null) return;
    setState(() {
      matched = {for (var law in laws) law: null};
      isCorrect = {for (var law in laws) law: false};
      showResult = false;
    });

    if (currentMatchIndex < matchDocuments!.length - 1) {
      currentMatchIndex++;
      currentMatchDocument = matchDocuments![currentMatchIndex];
      setDataFromDocument(currentMatchDocument!);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF1B2D33),
          title: const Text("End of Game",
              style: TextStyle(color: Colors.white)),
          content: const Text("You've completed all matches!",
              style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => Dashpage()));
              },
              child: const Text("Return to Dashboard",
                  style: TextStyle(color: Colors.tealAccent)),
            ),
          ],
        ),
      );
    }
  }

  void previousMatch() {
    if (matchDocuments == null || currentMatchIndex == 0) return;
    setState(() {
      currentMatchIndex--;
      currentMatchDocument = matchDocuments![currentMatchIndex];
      setDataFromDocument(currentMatchDocument!);
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color darkColor = Color(0xFF0D1B2A);
    const Color accent = Color(0xFF00B4D8);
    const Color light = Color(0xFF90E0EF);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Constitution Match Game',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: darkColor,
        centerTitle: true,
        elevation: 6,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF001F3F), Color(0xFF003554)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: laws.isEmpty
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Column(
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: descriptions.keys.length,
                      itemBuilder: (context, index) {
                        String law = descriptions.keys.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  border: Border.all(
                                      color: Colors.white24, width: 1.2),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        descriptions[law]!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    DragTarget<String>(
                                      builder: (context, candidateData, _) {
                                        final highlight =
                                            candidateData.isNotEmpty;
                                        return AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          width: 180,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: showResult
                                                ? (isCorrect[law] == true
                                                    ? Colors.greenAccent
                                                        .withOpacity(0.6)
                                                    : Colors.redAccent
                                                        .withOpacity(0.6))
                                                : (highlight
                                                    ? accent.withOpacity(0.3)
                                                    : Colors.white
                                                        .withOpacity(0.1)),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            border: Border.all(
                                                color: Colors.white24),
                                          ),
                                          child: Center(
                                            child: Text(
                                              matched[law] ?? "Drop here",
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        );
                                      },
                                      onAccept: (data) {
                                        setState(() {
                                          matched[law] = data;
                                          availableLaws.remove(data);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // draggable cards
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: availableLaws.map((law) {
                      return Draggable<String>(
                        data: law,
                        child: DraggableCard(law: law),
                        feedback: Material(
                          color: Colors.transparent,
                          child: DraggableCard(law: law),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.4,
                          child: DraggableCard(law: law),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  if (showResult)
                    ElevatedButton(
                      onPressed: showCorrectAnswersDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 6,
                      ),
                      child: const Text("Show Correct Answers",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  if (!showResult)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _modernIcon(Icons.arrow_back, previousMatch, light),
                        const SizedBox(width: 16),
                        _modernButton("Check Answers", checkAnswers, accent),
                        const SizedBox(width: 16),
                        _modernIcon(Icons.arrow_forward, nextMatch, light),
                      ],
                    ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }

  Widget _modernButton(String label, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 6,
      ),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _modernIcon(IconData icon, VoidCallback onPressed, Color color) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}

class DraggableCard extends StatelessWidget {
  final String law;

  const DraggableCard({super.key, required this.law});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF00B4D8).withOpacity(0.8),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          law,
          style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5),
        ),
      ),
    );
  }
}
