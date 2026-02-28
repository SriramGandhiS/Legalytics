import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:login_signup/contents/pt_1.dart';
import 'package:login_signup/contents/pt_10.dart';
import 'package:login_signup/contents/pt_11.dart';
import 'package:login_signup/contents/pt_12.dart';
import 'package:login_signup/contents/pt_13.dart';
import 'package:login_signup/contents/pt_14.dart';
import 'package:login_signup/contents/pt_14A.dart';
import 'package:login_signup/contents/pt_15.dart';
import 'package:login_signup/contents/pt_16.dart';
import 'package:login_signup/contents/pt_17.dart';
import 'package:login_signup/contents/pt_18.dart';
import 'package:login_signup/contents/pt_19.dart';
import 'package:login_signup/contents/pt_2.dart';
import 'package:login_signup/contents/pt_20.dart';
import 'package:login_signup/contents/pt_21.dart';
import 'package:login_signup/contents/pt_22.dart';
import 'package:login_signup/contents/pt_3.dart';
import 'package:login_signup/contents/pt_4.dart';
import 'package:login_signup/contents/pt_4A.dart';
import 'package:login_signup/contents/pt_5.dart';
import 'package:login_signup/contents/pt_6.dart';
import 'package:login_signup/contents/pt_7.dart';
import 'package:login_signup/contents/pt_8.dart';
import 'package:login_signup/contents/pt_9.dart';
import 'package:login_signup/contents/s1.dart';
import 'package:login_signup/contents/s10.dart';
import 'package:login_signup/contents/s11.dart';
import 'package:login_signup/contents/s12.dart';
import 'package:login_signup/contents/s2.dart';
import 'package:login_signup/contents/s3.dart';
import 'package:login_signup/contents/s4.dart';
import 'package:login_signup/contents/s5.dart';
import 'package:login_signup/contents/s6.dart';
import 'package:login_signup/contents/s7.dart';
import 'package:login_signup/contents/s8.dart';
import 'package:login_signup/contents/s9.dart';
import 'package:login_signup/screens/dashpage.dart';

class Contents extends StatefulWidget {
  const Contents({super.key});

  @override
  State<Contents> createState() => _ContentsState();
}

class _ContentsState extends State<Contents> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late List<AnimationController> _cardControllers;

  final List<Map<String, String>> contents = [
    {'title': 'Part I: Union and its Territory', 'route': '/part1'},
    {'title': 'Part II: Citizenship', 'route': '/part2'},
    {'title': 'Part III: Fundamental Rights', 'route': '/part3'},
    {'title': 'Part IV: Directive Principles of State Policy', 'route': '/part4'},
    {'title': 'Part IV-A: Fundamental Duties', 'route': '/part4A'},
    {'title': 'Part V: The Union', 'route': '/part5'},
    {'title': 'Part VI: The States', 'route': '/part6'},
    {'title': 'Part VII: States in the B-Part (repealed)', 'route': '/part7'},
    {'title': 'Part VIII: The Union Territories', 'route': '/part8'},
    {'title': 'Part IX: The Panchayats', 'route': '/part9'},
    {'title': 'Part IX-A: The Municipalities', 'route': '/part9A'},
    {'title': 'Part X: The Scheduled and Tribal Areas', 'route': '/part10'},
    {'title': 'Part XI: Relations between the Union and States', 'route': '/part11'},
    {'title': 'Part XII: Finance, Property, and Suits', 'route': '/part12'},
    {'title': 'Part XIII: Trade and Commerce', 'route': '/part13'},
    {'title': 'Part XIV: Services under the Union and States', 'route': '/part14'},
    {'title': 'Part XIV-A: Tribunals', 'route': '/part14A'},
    {'title': 'Part XV: Elections', 'route': '/part15'},
    {'title': 'Part XVI: Special Provisions for Classes', 'route': '/part16'},
    {'title': 'Part XVII: Official Language', 'route': '/part17'},
    {'title': 'Part XVIII: Emergency Provisions', 'route': '/part18'},
    {'title': 'Part XIX: Miscellaneous', 'route': '/part19'},
    {'title': 'Part XX: Amendment of the Constitution', 'route': '/part20'},
    {'title': 'Part XXI: Transitional Provisions', 'route': '/part21'},
    {'title': 'Part XXII: Short Title and Repeal', 'route': '/part22'},
    {'title': 'Schedule I: Territories of India', 'route': '/schedule1'},
    {'title': 'Schedule II: Oaths and Affirmations', 'route': '/schedule2'},
    {'title': 'Schedule III: Forms of Oaths', 'route': '/schedule3'},
    {'title': 'Schedule IV: Rajya Sabha Seats', 'route': '/schedule4'},
    {'title': 'Schedule V: Scheduled Areas', 'route': '/schedule5'},
    {'title': 'Schedule VI: Tribal Areas', 'route': '/schedule6'},
    {'title': 'Schedule VII: Distribution of Powers', 'route': '/schedule7'},
    {'title': 'Schedule VIII: Languages', 'route': '/schedule8'},
    {'title': 'Schedule IX: Acquisition of Estates', 'route': '/schedule9'},
    {'title': 'Schedule X: Anti-defection Act', 'route': '/schedule10'},
    {'title': 'Schedule XI: Panchayats', 'route': '/schedule11'},
    {'title': 'Schedule XII: Municipalities', 'route': '/schedule12'},
  ];

  @override
  void initState() {
    super.initState();

    _fadeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();

    _cardControllers = List.generate(
      contents.length,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 900 + (index * 40)),
      )..forward(),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1B2D33);
    const Color accentColor = Color(0xFF3E7B87);
    const Color lightAccent = Color(0xFFB4D6CD);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Constitution App',
      routes: {
        '/part1': (context) => VideoPlayerScreen1(),
        '/part2': (context) => VideoPlayerScreen2(),
        '/part3': (context) => VideoPlayerScreen3(),
        '/part4': (context) => VideoPlayerScreen4(),
        '/part4A': (context) => VideoPlayerScreen4A(),
        '/part5': (context) => VideoPlayerScreen5(),
        '/part6': (context) => VideoPlayerScreen6(),
        '/part7': (context) => VideoPlayerScreen7(),
        '/part8': (context) => VideoPlayerScreen8(),
        '/part9': (context) => VideoPlayerScreen9(),
        '/part10': (context) => VideoPlayerScreen10(),
        '/part11': (context) => VideoPlayerScreen11(),
        '/part12': (context) => VideoPlayerScreen12(),
        '/part13': (context) => VideoPlayerScreen13(),
        '/part14': (context) => VideoPlayerScreen14(),
        '/part14A': (context) => VideoPlayerScreen14A(),
        '/part15': (context) => VideoPlayerScreen15(),
        '/part16': (context) => VideoPlayerScreen16(),
        '/part17': (context) => VideoPlayerScreen17(),
        '/part18': (context) => VideoPlayerScreen18(),
        '/part19': (context) => VideoPlayerScreen19(),
        '/part20': (context) => VideoPlayerScreen20(),
        '/part21': (context) => VideoPlayerScreen21(),
        '/part22': (context) => VideoPlayerScreen22(),
        '/schedule1': (context) => VideoPlayerScreenS1(),
        '/schedule2': (context) => VideoPlayerScreenS2(),
        '/schedule3': (context) => VideoPlayerScreenS3(),
        '/schedule4': (context) => VideoPlayerScreenS4(),
        '/schedule5': (context) => VideoPlayerScreenS5(),
        '/schedule6': (context) => VideoPlayerScreenS6(),
        '/schedule7': (context) => VideoPlayerScreenS7(),
        '/schedule8': (context) => VideoPlayerScreenS8(),
        '/schedule9': (context) => VideoPlayerScreenS9(),
        '/schedule10': (context) => VideoPlayerScreenS10(),
        '/schedule11': (context) => VideoPlayerScreenS11(),
        '/schedule12': (context) => VideoPlayerScreenS12(),
      },
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Contents : Video',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
          ),
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Dashpage()),
              );
            },
          ),
        ),
        body: Stack(
          children: [
            // 🖼️ Background image with blur
            Positioned.fill(
              child: Image.asset('assets/images/hbg.jpg', fit: BoxFit.cover),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),

            // ✨ Fade-in animated list
            FadeTransition(
              opacity: _fadeAnimation,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: contents.length,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                itemBuilder: (context, index) {
                  final controller = _cardControllers[index];
                  final animation =
                      CurvedAnimation(parent: controller, curve: Curves.easeOutBack);

                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.25),
                      end: Offset.zero,
                    ).animate(animation),
                    child: ScaleTransition(
                      scale: animation,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, contents[index]['route']!);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withOpacity(0.5),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 20),
                            title: Text(
                              contents[index]['title']!,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios,
                                color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 💬 Floating support button
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                backgroundColor: lightAccent,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "For support, contact: sivasaran8667@gmail.com",
                        style: TextStyle(fontSize: 16),
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                child: const Icon(Icons.support_agent, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
