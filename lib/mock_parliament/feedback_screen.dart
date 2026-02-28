import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackScreen extends StatefulWidget {
  final String billId;
  final String voteChoice;

  const FeedbackScreen({super.key, required this.billId, required this.voteChoice});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
          ..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1B2D33);
    const Color accentColor = Color(0xFF3E7B87);
    const Color lightAccent = Color(0xFFB4D6CD);

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('bills').doc(widget.billId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Bill not found',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final data = snapshot.data!.data()!;
        final title = data['title'] ?? 'Untitled Bill';
        final votesFor = data['votesFor'] ?? 0;
        final votesAgainst = data['votesAgainst'] ?? 0;
        final passed = votesFor > votesAgainst;
        final totalVotes = (votesFor + votesAgainst).toDouble().clamp(1, double.infinity);

        return Scaffold(
          appBar: AppBar(
            title: Text("Feedback: $title"),
            centerTitle: true,
            backgroundColor: primaryColor,
            titleTextStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset('assets/images/hbg.jpg', fit: BoxFit.cover),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.black.withOpacity(0.6)),
              ),
              FadeTransition(
                opacity: _fadeController,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            border: Border.all(color: Colors.white30),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'You voted: ${widget.voteChoice.toUpperCase()}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 25),

                              // Animated Bill Status
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 700),
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                                decoration: BoxDecoration(
                                  color: passed
                                      ? Colors.greenAccent.withOpacity(0.2)
                                      : Colors.redAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: passed
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  passed ? "BILL PASSED" : "BILL REJECTED",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: passed
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30),

                              // Animated Progress Bar
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                    begin: 0,
                                    end: votesFor / totalVotes),
                                duration: const Duration(seconds: 1),
                                builder: (context, value, _) => Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: Colors.white12,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        Container(
                                          height: 16,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.85 *
                                              value,
                                          decoration: BoxDecoration(
                                            color: Colors.greenAccent,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "For: $votesFor    Against: $votesAgainst",
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 40),

                              Text(
                                widget.voteChoice == 'for'
                                    ? (passed
                                        ? '✅ Your vote aligned with the majority—well done!'
                                        : '⚠️ You were in favor, but the majority voted otherwise.')
                                    : (passed
                                        ? '⚠️ You were against, but the majority supported it.'
                                        : '✅ Your vote aligned with the majority—well done!'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 50),

                              // Return Button
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor.withOpacity(0.9),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 10,
                                  shadowColor: accentColor.withOpacity(0.5),
                                ),
                                child: const Text(
                                  'Return to Start',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
