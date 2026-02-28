import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'vote_screen.dart';

class DebateScreen extends StatefulWidget {
  final String billId;

  const DebateScreen({super.key, required this.billId});

  @override
  State<DebateScreen> createState() => _DebateScreenState();
}

class _DebateScreenState extends State<DebateScreen>
    with SingleTickerProviderStateMixin {
  final _argumentController = TextEditingController();
  late AnimationController _fadeController;

  Stream<QuerySnapshot> get _debatesStream => FirebaseFirestore.instance
      .collection('bills')
      .doc(widget.billId)
      .collection('debates')
      .orderBy('timestamp')
      .snapshots();

  Future<DocumentSnapshot> get _billFuture => FirebaseFirestore.instance
      .collection('bills')
      .doc(widget.billId)
      .get();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _argumentController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final msg = _argumentController.text.trim();
    if (msg.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('bills')
        .doc(widget.billId)
        .collection('debates')
        .add({
      'message': msg,
      'sender': FirebaseAuth.instance.currentUser?.email ?? 'Anonymous',
      'timestamp': Timestamp.now(),
    });

    _argumentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1B2D33);
    const Color accentColor = Color(0xFF3E7B87);
    const Color lightAccent = Color(0xFFB4D6CD);

    return FutureBuilder<DocumentSnapshot>(
      future: _billFuture,
      builder: (context, billSnap) {
        if (billSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }
        if (!billSnap.hasData || !billSnap.data!.exists) {
          return const Scaffold(
            body: Center(
              child: Text('Bill not found', style: TextStyle(color: Colors.white)),
            ),
          );
        }

        final billData = billSnap.data!.data()! as Map<String, dynamic>;
        final billTitle = billData['title'] ?? 'Untitled Bill';

        return Scaffold(
          appBar: AppBar(
            title: Text("Debate: $billTitle"),
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
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _debatesStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator(color: Colors.white));
                          }
                          final debates = snapshot.data!.docs;

                          if (debates.isEmpty) {
                            return const Center(
                              child: Text(
                                "No discussions yet. Be the first to comment!",
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: debates.length,
                            itemBuilder: (context, index) {
                              final data = debates[index].data()! as Map<String, dynamic>;
                              final sender = data['sender'] ?? "Anonymous";
                              final message = data['message'] ?? "";

                              return Align(
                                alignment: sender ==
                                        FirebaseAuth.instance.currentUser?.email
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: sender ==
                                              FirebaseAuth.instance.currentUser?.email
                                          ? lightAccent
                                          : Colors.white24,
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: const Offset(2, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sender,
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        message,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // Input Field
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _argumentController,
                              maxLines: 2,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter your argument...',
                                hintStyle: const TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Colors.white30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: lightAccent, width: 1.4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: _sendMessage,
                            borderRadius: BorderRadius.circular(50),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: accentColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: accentColor.withOpacity(0.6),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.send, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Proceed to Vote Button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => VoteScreen(billId: widget.billId)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor.withOpacity(0.9),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          shadowColor: accentColor.withOpacity(0.6),
                          elevation: 10,
                        ),
                        child: const Text(
                          'Proceed to Vote',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
