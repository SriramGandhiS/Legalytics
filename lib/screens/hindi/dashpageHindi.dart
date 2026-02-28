import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:login_signup/screens/hindi/contents/contentsHindi.dart';
import 'package:login_signup/screens/hindi/matchhindi.dart';
import 'package:login_signup/screens/hindi/quizeasyhindi/contentsquizehindi.dart';
import 'package:login_signup/screens/hindi/quizhardhindi/contentshardhindi.dart';

class Dashpagehindi extends StatefulWidget {
  const Dashpagehindi({super.key});

  @override
  State<Dashpagehindi> createState() => _DashpagehindiState();
}

class _DashpagehindiState extends State<Dashpagehindi>
    with TickerProviderStateMixin {
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
      'quote': '“कर लगाने की शक्ति नष्ट करने की शक्ति है।” - जॉन मार्शल',
    },
    {
      'image': 'assets/images/b1.jpg',
      'quote': '“कहीं भी अन्याय हर जगह न्याय के लिए खतरा है।” - मार्टिन लूथर किंग जूनियर',
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

    // Fade animation
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();

    // Swiper animation
    _swiperController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _swiperAnimation =
        CurvedAnimation(parent: _swiperController, curve: Curves.elasticOut);
    _swiperController.forward();

    // Button stagger animation
    _buttonControllers = List.generate(
      4,
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'डैशबोर्ड',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
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
                  title: const Text("एप्लिकेशन के बारे में"),
                  content: const Text(
                    "यह ऐप आपको भारतीय संविधान को सीखने में मदद करता है — मज़ेदार क्विज़ और इंटरैक्टिव मॉड्यूल के माध्यम से।",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("ठीक है",
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
                      // 🌀 Swiper Section
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(_swiperAnimation),
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

                      // 🎯 Animated Buttons
                      _animatedButton(
                        0,
                        "सामग्री",
                        Icons.menu_book_outlined,
                        accentColor,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Contentshindi()),
                          );
                        },
                      ),
                      _animatedButton(
                        1,
                        "चरण 1: आसान मोड",
                        Icons.light_mode,
                        accentColor,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Contents1hindi()),
                          );
                        },
                      ),
                      _animatedButton(
                        2,
                        "चरण 2: कठिन मोड",
                        Icons.bolt,
                        accentColor,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Contents2hindi()),
                          );
                        },
                      ),
                      _animatedButton(
                        3,
                        "मैच गेम",
                        Icons.extension,
                        accentColor,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MatchGameScreenHindi()),
                          );
                        },
                      ),
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
  Widget _animatedButton(
    int index,
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // ✨ Subtle shimmer effect
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
    );
  }
}
