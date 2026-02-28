import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:login_signup/contents/contents.dart';
import 'package:login_signup/quizeasy/contentsquize.dart';
import 'package:login_signup/quizhard/contentsquizh.dart';
import 'package:login_signup/screens/match.dart';
import 'package:login_signup/mock_parliament/role_selection_screen.dart';

class Dashpage extends StatefulWidget {
  const Dashpage({super.key});

  @override
  State<Dashpage> createState() => _DashpageState();
}

class _DashpageState extends State<Dashpage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _bgController;
  late AnimationController _swiperController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _bgAnimation;
  late Animation<double> _swiperAnimation;
  late List<AnimationController> _buttonControllers;

  final List<Map<String, String>> _constitutionSlides = [
    {
      'image': 'assets/images/b1.jpg',
      'quote': '“The power to tax is the power to destroy.” - John Marshall',
    },
    {
      'image': 'assets/images/b1.jpg',
      'quote': '“Injustice anywhere is a threat to justice everywhere.” - Martin Luther King Jr.',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Background subtle parallax
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _bgAnimation = Tween<double>(begin: 0, end: 10)
        .animate(CurvedAnimation(parent: _bgController, curve: Curves.easeInOut));

    // Page fade-in
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();

    // Swiper pop animation
    _swiperController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _swiperAnimation =
        CurvedAnimation(parent: _swiperController, curve: Curves.elasticOut);
    _swiperController.forward();

    // Buttons stagger animation
    _buttonControllers = List.generate(
      5,
      (index) => AnimationController(
        duration: Duration(milliseconds: 900 + (index * 150)),
        vsync: this,
      )..forward(),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _bgController.dispose();
    _swiperController.dispose();
    for (var c in _buttonControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1B2D33);
    const Color accentColor = Color(0xFF3E7B87);
    const Color lightAccent = Color(0xFFB4D6CD);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
        ),
        backgroundColor: primaryColor,
        elevation: 4,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("About the App"),
                  content: const Text(
                    "This app helps you learn about the Constitution of India through engaging quizzes and interactive modules.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK",
                          style: TextStyle(color: Colors.blueAccent)),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: AnimatedBuilder(
        animation: _bgAnimation,
        builder: (context, _) {
          return Stack(
            children: [
              // 🌄 Background with parallax motion
              Positioned.fill(
                top: _bgAnimation.value,
                child: Image.asset(
                  'assets/images/hbg.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.black.withOpacity(0.35)),
              ),

              // 📜 Scrollable content
              FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Column(
                    children: [
                      // 🌀 Swiper Section with slide animation
                      SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(0, 0.3), end: Offset.zero)
                            .animate(_swiperAnimation),
                        child: ScaleTransition(
                          scale: _swiperAnimation,
                          child: Container(
                            height: 200,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Swiper(
                                autoplay: true,
                                pagination: const SwiperPagination(),
                                itemCount: _constitutionSlides.length,
                                itemBuilder: (context, index) {
                                  final slide = _constitutionSlides[index];
                                  return Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.asset(slide['image']!,
                                          fit: BoxFit.cover),
                                      Container(color: Colors.black45),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(
                                            slide['quote']!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 8,
                                                  color: Colors.black54,
                                                  offset: Offset(1, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // 🎯 Animated Buttons Section
                      _animatedButton(0, "Contents", Icons.menu_book_outlined,
                          accentColor, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Contents()),
                        );
                      }),
                      _animatedButton(1, "Stage 1 : Easy Mode", Icons.light_mode,
                          accentColor, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Contents1()),
                        );
                      }),
                      _animatedButton(2, "Stage 2 : Hard Mode", Icons.bolt,
                          accentColor, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Contents2()),
                        );
                      }),
                      _animatedButton(3, "Match Game", Icons.extension,
                          accentColor, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MatchGameScreen()),
                        );
                      }),
                      _animatedButton(4, "Mock Parliament", Icons.gavel_rounded,
                          accentColor, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RoleSelectionScreen()),
                        );
                      }),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // 🎬 Modern Animated Button with Glow + Shimmer
  Widget _animatedButton(int index, String title, IconData icon, Color color,
      VoidCallback onPressed) {
    final controller = _buttonControllers[index];
    final animation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack);

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.4),
          end: Offset.zero,
        ).animate(animation),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          child: GestureDetector(
            onTap: onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: color.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onPressed,
                splashColor: Colors.white24,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // ✨ Subtle shimmer effect overlay
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: controller,
                        builder: (context, _) {
                          final shimmerOffset =
                              (controller.value * 300) % 300 - 150;
                          return ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.white.withOpacity(0.15),
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.15),
                                ],
                                stops: [
                                  (0.4 + shimmerOffset / 300).clamp(0.0, 1.0),
                                  (0.5 + shimmerOffset / 300).clamp(0.0, 1.0),
                                  (0.6 + shimmerOffset / 300).clamp(0.0, 1.0),
                                ],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.srcATop,
                            child: Container(),
                          );
                        },
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: onPressed,
                      icon: Icon(icon, color: Colors.white, size: 28),
                      label: Text(
                        title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 70),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
