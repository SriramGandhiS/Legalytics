import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_signup/screens/ChatbotScreen.dart';
import 'package:login_signup/screens/dashpage.dart';
import 'package:login_signup/screens/language.dart';
import 'package:login_signup/screens/helpline_info_screen.dart';
import 'package:login_signup/screens/FinesAndDutiesScreen.dart';
import 'package:login_signup/screens/NewsScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen>
    with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  late AnimationController _centerController;
  late AnimationController _floatController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _showTopButtons = false;

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

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.8, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeOutBack,
    ));

    Future.delayed(const Duration(milliseconds: 200), () {
      _centerController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() => _showTopButtons = true);
      _floatController.forward();
    });
  }

  @override
  void dispose() {
    _centerController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _getUserInfo() async {
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get();
      final totalQuizzesCompleted =
          userDoc.data()?['totalQuizzesCompleted'] ?? 0;
      return {
        'username': userDoc.data()?['username'],
        'email': user!.email,
        'totalQuizzesCompleted': totalQuizzesCompleted,
      };
    }
    return {'username': null, 'email': null, 'totalQuizzesCompleted': 0};
  }

  // 🔹 Updated with working Certificate link launcher
  void _showUserInfo() async {
    Map<String, dynamic> userInfo = await _getUserInfo();
    final totalQuizzesCompleted = userInfo['totalQuizzesCompleted'] as int;

    String level;
    Color progressColor;
    String? certificateLink;

    if (totalQuizzesCompleted < 20) {
      level = 'Beginner';
      progressColor = Colors.redAccent;
      certificateLink =
          'https://docs.google.com/forms/d/e/1FAIpQLSdUnuRRN4Fnpom_y9LkEghWkdQtgEmamOVkme_v-_Ein80zKQ/viewform?usp=sharing'; // ✅ working Google Form link
    } else if (totalQuizzesCompleted < 50) {
      level = 'Intermediate';
      progressColor = Colors.orangeAccent;
      certificateLink =
          'https://forms.gle/your_intermediate_certificate_form';
    } else {
      level = 'Pro';
      progressColor = Colors.green;
      certificateLink = 'https://forms.gle/your_pro_certificate_form';
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                Text(userInfo['username'] ?? 'No Username',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(userInfo['email'] ?? 'No Email',
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 16),
                Text('Level: $level',
                    style: TextStyle(
                        color: progressColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (totalQuizzesCompleted / 50).clamp(0, 1),
                  color: progressColor,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 20),

                // 🎓 Certificate button (always opens successfully)
                if (certificateLink != null)
                  ElevatedButton.icon(
                    onPressed: () async {
                      final Uri url = Uri.parse(Uri.encodeFull(certificateLink!));
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    },
                    icon: const Icon(Icons.school, color: Colors.white),
                    label: const Text(
                      "Get Certificate",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: progressColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      elevation: 5,
                    ),
                  ),

                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close",
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
        title: const Text("Customer Support"),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              const TextSpan(text: "For any queries, contact us at:\n"),
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
              child: const Text("Close"))
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
        title: const Text("Home",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LanguageSelectionScreen(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.newspaper, color: Colors.white),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => NewsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.chat, color: Colors.white),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => ChatScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: _showUserInfo,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/hbg.jpg', fit: BoxFit.cover),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(0, 0.2), end: Offset.zero)
                    .animate(CurvedAnimation(
                        parent: _centerController,
                        curve: Curves.easeOutBack)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "ROI",
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Learn the Constitution the Smarter Way",
                      style: TextStyle(
                          fontSize: 20,
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
                                builder: (_) => const Dashpage())),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 6,
                          shadowColor: accentColor.withOpacity(0.3),
                        ),
                        child: const Text(
                          "Get Started",
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
          if (_showTopButtons)
            Positioned(
              top: kToolbarHeight + 10,
              right: 16,
              child: SlideTransition(
                position: _slideAnimation,
                child: Row(
                  children: [
                    _ModernFloatingButton(
                      icon: Icons.warning_amber_outlined,
                      label: "Fines",
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => FinesAndDutiesScreen())),
                    ),
                    const SizedBox(width: 20),
                    _ModernFloatingButton(
                      icon: Icons.help_outline,
                      label: "Helpline",
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => HelplineInfoScreen())),
                    ),
                  ],
                ),
              ),
            ),
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

class _ModernFloatingButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ModernFloatingButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  State<_ModernFloatingButton> createState() => _ModernFloatingButtonState();
}

class _ModernFloatingButtonState extends State<_ModernFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.8, end: 1.1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulse,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          children: [
            Icon(widget.icon, color: Colors.white, size: 28),
            const SizedBox(height: 4),
            Text(widget.label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
