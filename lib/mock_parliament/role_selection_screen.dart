import 'dart:ui';
import 'package:flutter/material.dart';
import 'create_bill_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  final roles = [
    {
      'title': 'Member of Parliament (MP)',
      'description': 'Propose new laws & debate!',
      'icon': Icons.how_to_vote,
      'color': const Color(0xFF80C8FF),
    },
    {
      'title': 'Minister',
      'description': 'Defend policies & convince!',
      'icon': Icons.account_balance,
      'color': const Color(0xFFFFD56B),
    },
    {
      'title': 'Speaker',
      'description': 'Moderate debates & keep order!',
      'icon': Icons.record_voice_over,
      'color': const Color(0xFFB48BFF),
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Mock Parliament"),
        backgroundColor: primaryColor.withOpacity(0.9),
        centerTitle: true,
        elevation: 3,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset("assets/images/hbg.jpg", fit: BoxFit.cover),
          ),
          // Frosted Blur Overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          FadeTransition(
            opacity: _fadeController,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    ShaderMask(
                      shaderCallback: (rect) => const LinearGradient(
                        colors: [Color(0xFFB4D6CD), Colors.white],
                      ).createShader(rect),
                      child: const Text(
                        "Choose Your Role",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                color: Colors.black54,
                                blurRadius: 10,
                                offset: Offset(2, 2)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Animated Role Cards
                    Column(
                      children: roles
                          .map((role) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 22, vertical: 10),
                                child: _buildRoleCard(
                                  context,
                                  title: role['title'] as String,
                                  description:
                                      role['description'] as String,
                                  icon: role['icon'] as IconData,
                                  color: role['color'] as Color,
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateBillScreen(role: title)),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white38, size: 20),
          ],
        ),
      ),
    );
  }
}
