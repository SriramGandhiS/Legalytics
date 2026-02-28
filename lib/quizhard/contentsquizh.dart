import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:login_signup/quizhard/pt_1h.dart';
import 'package:login_signup/quizhard/pt_10h.dart';
import 'package:login_signup/quizhard/pt_11h.dart';
import 'package:login_signup/quizhard/pt_12h.dart';
import 'package:login_signup/quizhard/pt_13h.dart';
import 'package:login_signup/quizhard/pt_14h.dart';
import 'package:login_signup/quizhard/pt_14A.dart';
import 'package:login_signup/quizhard/pt_15h.dart';
import 'package:login_signup/quizhard/pt_16h.dart';
import 'package:login_signup/quizhard/pt_17h.dart';
import 'package:login_signup/quizhard/pt_18h.dart';
import 'package:login_signup/quizhard/pt_19h.dart';
import 'package:login_signup/quizhard/pt_2h.dart';
import 'package:login_signup/quizhard/pt_20h.dart';
import 'package:login_signup/quizhard/pt_21h.dart';
import 'package:login_signup/quizhard/pt_22h.dart';
import 'package:login_signup/quizhard/pt_3h.dart';
import 'package:login_signup/quizhard/pt_4h.dart';
import 'package:login_signup/quizhard/pt_4Ah.dart';
import 'package:login_signup/quizhard/pt_5h.dart';
import 'package:login_signup/quizhard/pt_6h.dart';
import 'package:login_signup/quizhard/pt_7h.dart';
import 'package:login_signup/quizhard/pt_8h.dart';
import 'package:login_signup/quizhard/pt_9h.dart';
import 'package:login_signup/quizhard/s1h.dart';
import 'package:login_signup/quizhard/s10h.dart';
import 'package:login_signup/quizhard/s11h.dart';
import 'package:login_signup/quizhard/s12h.dart';
import 'package:login_signup/quizhard/s2h.dart';
import 'package:login_signup/quizhard/s3h.dart';
import 'package:login_signup/quizhard/s4h.dart';
import 'package:login_signup/quizhard/s5h.dart';
import 'package:login_signup/quizhard/s6h.dart';
import 'package:login_signup/quizhard/s7h.dart';
import 'package:login_signup/quizhard/s8h.dart';
import 'package:login_signup/quizhard/s9h.dart';
import 'package:login_signup/screens/dashpage.dart';

class Contents2 extends StatefulWidget {
  const Contents2({super.key});

  @override
  State<Contents2> createState() => _Contents2State();
}

class _Contents2State extends State<Contents2> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> contents = [
    {'title': 'Part I: Union and its Territory', 'route': '/part1'},
    {'title': 'Part II: Citizenship', 'route': '/part2'},
    {'title': 'Part III: Fundamental Rights', 'route': '/part3'},
    {'title': 'Part IV: Directive Principles of State Policy', 'route': '/part4'},
    {'title': 'Part IV-A: Fundamental Duties', 'route': '/part4A'},
    {'title': 'Part V: The Union', 'route': '/part5'},
    {'title': 'Part VI: The States', 'route': '/part6'},
    {'title': 'Part VII: States in the B-Part of the First Schedule (repealed)', 'route': '/part7'},
    {'title': 'Part VIII: The Union Territories', 'route': '/part8'},
    {'title': 'Part IX: The Panchayats', 'route': '/part9'},
    {'title': 'Part IX-A: The Municipalities', 'route': '/part9A'},
    {'title': 'Part X: The Scheduled and Tribal Areas', 'route': '/part10'},
    {'title': 'Part XI: Relations between the Union and the States', 'route': '/part11'},
    {'title': 'Part XII: Finance, Property, Contracts, and Suits', 'route': '/part12'},
    {'title': 'Part XIII: Trade, Commerce, and Intercourse', 'route': '/part13'},
    {'title': 'Part XIV: Services under the Union and States', 'route': '/part14'},
    {'title': 'Part XIV-A: Tribunals', 'route': '/part14A'},
    {'title': 'Part XV: Elections', 'route': '/part15'},
    {'title': 'Part XVI: Special Provisions relating to certain classes', 'route': '/part16'},
    {'title': 'Part XVII: Official Language', 'route': '/part17'},
    {'title': 'Part XVIII: Emergency Provisions', 'route': '/part18'},
    {'title': 'Part XIX: Miscellaneous', 'route': '/part19'},
    {'title': 'Part XX: Amendment of the Constitution', 'route': '/part20'},
    {'title': 'Part XXI: Temporary and Transitional Provisions', 'route': '/part21'},
    {'title': 'Part XXII: Short Title, Commencement, and Repeal', 'route': '/part22'},
    {'title': 'Schedule I: Territories of the Union and States', 'route': '/schedule1'},
    {'title': 'Schedule II: Oaths and Affirmations', 'route': '/schedule2'},
    {'title': 'Schedule III: Forms of Oaths and Affirmations', 'route': '/schedule3'},
    {'title': 'Schedule IV: Allocation of Seats in Rajya Sabha', 'route': '/schedule4'},
    {'title': 'Schedule V: Scheduled and Tribal Areas', 'route': '/schedule5'},
    {'title': 'Schedule VI: Administration of Tribal Areas', 'route': '/schedule6'},
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
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Constitution App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      routes: {
        '/part1': (context) => QuizScreen1h(),
        '/part2': (context) => QuizScreen2h(),
        '/part3': (context) => QuizScreen3h(),
        '/part4': (context) => QuizScreen4h(),
        '/part4A': (context) => QuizScreen4Ah(),
        '/part5': (context) => QuizScreen5h(),
        '/part6': (context) => QuizScreen6h(),
        '/part7': (context) => QuizScreen7h(),
        '/part8': (context) => QuizScreen8h(),
        '/part9': (context) => QuizScreen9h(),
        '/part10': (context) => QuizScreen10h(),
        '/part11': (context) => QuizScreen11h(),
        '/part12': (context) => QuizScreen12h(),
        '/part13': (context) => QuizScreen13h(),
        '/part14': (context) => QuizScreen14h(),
        '/part14A': (context) => QuizScreen14Ah(),
        '/part15': (context) => QuizScreen15h(),
        '/part16': (context) => QuizScreen16h(),
        '/part17': (context) => QuizScreen17h(),
        '/part18': (context) => QuizScreen18h(),
        '/part19': (context) => QuizScreen19h(),
        '/part20': (context) => QuizScreen20h(),
        '/part21': (context) => QuizScreen21h(),
        '/part22': (context) => QuizScreen22h(),
        '/schedule1': (context) => QuizScreenS1h(),
        '/schedule2': (context) => QuizScreenS2h(),
        '/schedule3': (context) => QuizScreenS3h(),
        '/schedule4': (context) => QuizScreenS4h(),
        '/schedule5': (context) => QuizScreenS5h(),
        '/schedule6': (context) => QuizScreenS6h(),
        '/schedule7': (context) => QuizScreenS7h(),
        '/schedule8': (context) => QuizScreenS8h(),
        '/schedule9': (context) => QuizScreenS9h(),
        '/schedule10': (context) => QuizScreenS10h(),
        '/schedule11': (context) => QuizScreenS11h(),
        '/schedule12': (context) => QuizScreenS12h(),
      },
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contents: Hard Quiz'),
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Dashpage()),
              );
            },
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('assets/images/hbg.jpg', fit: BoxFit.cover),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: ListView.builder(
                itemCount: contents.length,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(
                          context, contents[index]['route']!),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                contents[index]['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
