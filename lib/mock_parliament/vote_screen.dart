import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'feedback_screen.dart';

class VoteScreen extends StatefulWidget {
  final String billId;

  const VoteScreen({super.key, required this.billId});

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen>
    with SingleTickerProviderStateMixin {
  String? _voteChoice;
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

  Future<void> _submitVote(BuildContext context) async {
    if (_voteChoice == null) return;
    final field = _voteChoice == 'for' ? 'votesFor' : 'votesAgainst';

    try {
      await FirebaseFirestore.instance
          .collection('bills')
          .doc(widget.billId)
          .update({field: FieldValue.increment(1)});

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FeedbackScreen(
            billId: widget.billId,
            voteChoice: _voteChoice!,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1B2D33);
    const Color accentColor = Color(0xFF3E7B87);
    const Color greenGlow = Color(0xFF4BE383);
    const Color redGlow = Color(0xFFFF6B6B);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cast Your Vote"),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 3,
        titleTextStyle: const TextStyle(
          fontSize: 24,
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
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          FadeTransition(
            opacity: _fadeController,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        border: Border.all(color: Colors.white30),
                        borderRadius: BorderRadius.circular(25),
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
                          const Text(
                            "Do you support this bill?",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),

                          // "FOR" Vote Button
                          _buildVoteButton(
                            label: "For",
                            color: greenGlow,
                            isSelected: _voteChoice == "for",
                            onTap: () => setState(() => _voteChoice = "for"),
                            icon: Icons.thumb_up_alt_outlined,
                          ),
                          const SizedBox(height: 20),

                          // "AGAINST" Vote Button
                          _buildVoteButton(
                            label: "Against",
                            color: redGlow,
                            isSelected: _voteChoice == "against",
                            onTap: () => setState(() => _voteChoice = "against"),
                            icon: Icons.thumb_down_alt_outlined,
                          ),

                          const SizedBox(height: 50),

                          // Submit Vote Button
                          AnimatedOpacity(
                            opacity: _voteChoice != null ? 1 : 0.4,
                            duration: const Duration(milliseconds: 300),
                            child: ElevatedButton(
                              onPressed: _voteChoice == null
                                  ? null
                                  : () => _submitVote(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    accentColor.withOpacity(0.9),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                elevation: 10,
                                shadowColor: accentColor.withOpacity(0.5),
                              ),
                              child: const Text(
                                'Submit Vote',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
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
  }

  Widget _buildVoteButton({
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(isSelected ? 0.4 : 0.15),
              color.withOpacity(isSelected ? 0.7 : 0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: color.withOpacity(isSelected ? 0.8 : 0.3),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.7),
                    blurRadius: 16,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 26),
          ],
        ),
      ),
    );
  }
}
