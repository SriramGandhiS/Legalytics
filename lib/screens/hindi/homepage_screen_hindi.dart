import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_signup/screens/hindi/ChatbotScreenHindi.dart';
import 'package:login_signup/screens/hindi/dashpageHindi.dart';
import 'package:login_signup/screens/language.dart';
import 'package:url_launcher/url_launcher.dart';

class HomepageScreenHindi extends StatefulWidget {
  const HomepageScreenHindi({super.key});

  @override
  State<HomepageScreenHindi> createState() => _HomepageScreenHindiState();
}

class _HomepageScreenHindiState extends State<HomepageScreenHindi>
    with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;

  late AnimationController _centerController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _centerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _centerController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _centerController, curve: Curves.easeOutBack),
    );

    _centerController.forward();
  }

  @override
  void dispose() {
    _centerController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _getUserInfo() async {
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      final totalQuizzesCompleted = userDoc.data()?['totalQuizzesCompleted'] ?? 0;
      return {
        'username': userDoc.data()?['username'],
        'email': user!.email,
        'totalQuizzesCompleted': totalQuizzesCompleted,
      };
    }
    return {'username': null, 'email': null, 'totalQuizzesCompleted': 0};
  }

  void _showUserInfo() async {
    Map<String, dynamic> userInfo = await _getUserInfo();
    final totalQuizzesCompleted = userInfo['totalQuizzesCompleted'] as int;

    String level;
    Color progressColor;
    if (totalQuizzesCompleted < 20) {
      level = 'शुरुआती';
      progressColor = Colors.redAccent;
    } else if (totalQuizzesCompleted < 50) {
      level = 'मध्यम';
      progressColor = Colors.orangeAccent;
    } else {
      level = 'प्रो';
      progressColor = Colors.green;
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFF7DAEA4),
                  child: Text(
                    userInfo['username']?[0].toUpperCase() ?? '?',
                    style: const TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Text(userInfo['username'] ?? 'नाम उपलब्ध नहीं',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(userInfo['email'] ?? 'ईमेल उपलब्ध नहीं',
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 16),
                Text('स्तर: $level',
                    style: TextStyle(
                        color: progressColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: totalQuizzesCompleted / 30,
                  color: progressColor,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("बंद करें",
                      style: TextStyle(color: Colors.blueAccent)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCustomerSupport() {
    const email = "sivasaran8667@gmail.com";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ग्राहक सहायता"),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              const TextSpan(text: "किसी भी प्रश्न के लिए संपर्क करें:\n"),
              TextSpan(
                text: email,
                style: const TextStyle(
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launch("mailto:$email"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("बंद करें"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1B2D33);
    const Color accentColor = Color(0xFF3E7B87);
    const Color lightAccent = Color(0xFFB4D6CD);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 3,
        title: const Text("होम",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LanguageSelectionScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat, color: Colors.white),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => ChatScreenHindi())),
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: _showUserInfo,
          ),
        ],
      ),
      body: Stack(
        children: [
          // 🌄 Background image with blur overlay
          Positioned.fill(
            child: Image.asset('assets/images/hbg.jpg', fit: BoxFit.cover),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          // ✨ Center animated text and button
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "आरओआई",
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "संविधान को सरल तरीके से सीखें",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 40),
                    ScaleTransition(
                      scale: CurvedAnimation(
                        parent: _centerController,
                        curve: Curves.elasticOut,
                      ),
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const Dashpagehindi()),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 6,
                          shadowColor: accentColor.withOpacity(0.4),
                        ),
                        child: const Text(
                          "शुरू करें",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 💬 Floating customer support button
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: lightAccent,
              onPressed: _showCustomerSupport,
              child: const Icon(Icons.support_agent, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
