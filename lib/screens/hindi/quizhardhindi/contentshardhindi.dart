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
import 'package:login_signup/screens/hindi/dashpageHindi.dart';
import 'package:login_signup/screens/hindi/quizhardhindi/pt_3hhindi.dart';

class Contents2hindi extends StatefulWidget {
  const Contents2hindi({super.key});

  @override
  State<Contents2hindi> createState() => _ContentsState();
}

class _ContentsState extends State<Contents2hindi> {
  final List<Map<String, String>> contents = [
    {'title': 'भाग I: संघ और उसका क्षेत्र', 'route': '/part1'},
    {'title': 'भाग II: नागरिकता', 'route': '/part2'},
    {'title': 'भाग III: मौलिक अधिकार', 'route': '/part3'},
    {'title': 'भाग IV: राज्य नीति के निर्देशक सिद्धांत', 'route': '/part4'},
    {'title': 'भाग IV-A: मौलिक कर्तव्य', 'route': '/part4A'},
    {'title': 'भाग V: संघ', 'route': '/part5'},
    {'title': 'भाग VI: राज्य', 'route': '/part6'},
    {
      'title': 'भाग VII: पहले अनुसूची के B-भाग में राज्य (रद्द)',
      'route': '/part7'
    },
    {'title': 'भाग VIII: संघ क्षेत्रों', 'route': '/part8'},
    {'title': 'भाग IX: पंचायतें', 'route': '/part9'},
    {'title': 'भाग IX-A: नगरपालिकाएँ', 'route': '/part9A'},
    {'title': 'भाग X: अनुसूचित और आदिवासी क्षेत्र', 'route': '/part10'},
    {'title': 'भाग XI: संघ और राज्यों के बीच संबंध', 'route': '/part11'},
    {'title': 'भाग XII: वित्त, संपत्ति, अनुबंध और मुकदमे', 'route': '/part12'},
    {
      'title': 'भाग XIII: व्यापार, वाणिज्य और भारत के क्षेत्र में संपर्क',
      'route': '/part13'
    },
    {'title': 'भाग XIV: संघ और राज्यों के अंतर्गत सेवाएँ', 'route': '/part14'},
    {'title': 'भाग XIV-A: न्यायाधिकरण', 'route': '/part14A'},
    {'title': 'भाग XV: चुनाव', 'route': '/part15'},
    {
      'title': 'भाग XVI: कुछ वर्गों के संबंध में विशेष प्रावधान',
      'route': '/part16'
    },
    {'title': 'भाग XVII: आधिकारिक भाषा', 'route': '/part17'},
    {'title': 'भाग XVIII: आपातकालीन प्रावधान', 'route': '/part18'},
    {'title': 'भाग XIX: विविध', 'route': '/part19'},
    {'title': 'भाग XX: संविधान में संशोधन', 'route': '/part20'},
    {
      'title': 'भाग XXI: अस्थायी, संक्रमणकालीन और विशेष प्रावधान',
      'route': '/part21'
    },
    {
      'title': 'भाग XXII: संक्षिप्त शीर्षक, प्रारंभ और रद्द',
      'route': '/part22'
    },
    {'title': 'अनुसूची I: संघ और राज्यों के क्षेत्र', 'route': '/schedule1'},
    {'title': 'अनुसूची II: शपथ और अन्नम', 'route': '/schedule2'},
    {'title': 'अनुसूची III: शपथ और अन्नम के रूप', 'route': '/schedule3'},
    {'title': 'अनुसूची IV: राज्यसभा में सीटों का आवंटन', 'route': '/schedule4'},
    {
      'title':
          'अनुसूची V: अनुसूचित क्षेत्रों और आदिवासी क्षेत्रों के प्रशासन और नियंत्रण से संबंधित प्रावधान',
      'route': '/schedule5'
    },
    {
      'title':
          'अनुसूची VI: असम, मेघालय, त्रिपुरा और मिजोरम राज्यों में आदिवासी क्षेत्रों के प्रशासन से संबंधित प्रावधान',
      'route': '/schedule6'
    },
    {
      'title':
          'अनुसूची VII: संघ और राज्यों के बीच शक्तियों और जिम्मेदारियों का वितरण',
      'route': '/schedule7'
    },
    {'title': 'अनुसूची VIII: भाषाएँ', 'route': '/schedule8'},
    {
      'title': 'अनुसूची IX: संपत्तियों के अधिग्रहण के लिए कानून',
      'route': '/schedule9'
    },
    {'title': 'अनुसूची X: एंटी-डिफेक्शन एक्ट', 'route': '/schedule10'},
    {
      'title': 'अनुसूची XI: पंचायतों के शक्तियाँ, अधिकार और जिम्मेदारियाँ',
      'route': '/schedule11'
    },
    {
      'title': 'अनुसूची XII: नगरपालिकाओं के शक्तियाँ, अधिकार और जिम्मेदारियाँ',
      'route': '/schedule12'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'संविधान ऐप',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/part1': (context) => QuizScreen1h(),
        '/part2': (context) => QuizScreen2h(),
        '/part3': (context) => QuizScreen3hhindi(),
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
          title: const Text('सामग्री : कठिन'),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Dashpagehindi()),
              );
            },
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg4.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Scrollbar(
              child: ListView.builder(
                itemCount: contents.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, contents[index]['route']!);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.white.withOpacity(0.8),
                      shadowColor: Colors.black54,
                      elevation: 8,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      child: ListTile(
                        title: Text(
                          contents[index]['title']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.blue,
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
