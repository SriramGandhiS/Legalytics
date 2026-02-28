import 'package:flutter/material.dart';
import 'package:login_signup/quizeasy/pt_10.dart';
import 'package:login_signup/quizeasy/pt_11.dart';
import 'package:login_signup/quizeasy/pt_12.dart';
import 'package:login_signup/quizeasy/pt_13.dart';
import 'package:login_signup/quizeasy/pt_14.dart';
import 'package:login_signup/quizeasy/pt_14A.dart';
import 'package:login_signup/quizeasy/pt_15.dart';
import 'package:login_signup/quizeasy/pt_16.dart';
import 'package:login_signup/quizeasy/pt_17.dart';
import 'package:login_signup/quizeasy/pt_18.dart';
import 'package:login_signup/quizeasy/pt_19.dart';
import 'package:login_signup/quizeasy/pt_2.dart';
import 'package:login_signup/quizeasy/pt_20.dart';
import 'package:login_signup/quizeasy/pt_21.dart';
import 'package:login_signup/quizeasy/pt_22.dart';
import 'package:login_signup/quizeasy/pt_4.dart';
import 'package:login_signup/quizeasy/pt_4A.dart';
import 'package:login_signup/quizeasy/pt_5.dart';
import 'package:login_signup/quizeasy/pt_6.dart';
import 'package:login_signup/quizeasy/pt_7.dart';
import 'package:login_signup/quizeasy/pt_8.dart';
import 'package:login_signup/quizeasy/pt_9.dart';
import 'package:login_signup/quizeasy/s1.dart';
import 'package:login_signup/quizeasy/s10.dart';
import 'package:login_signup/quizeasy/s11.dart';
import 'package:login_signup/quizeasy/s12.dart';
import 'package:login_signup/quizeasy/s2.dart';
import 'package:login_signup/quizeasy/s3.dart';
import 'package:login_signup/quizeasy/s4.dart';
import 'package:login_signup/quizeasy/s5.dart';
import 'package:login_signup/quizeasy/s6.dart';
import 'package:login_signup/quizeasy/s7.dart';
import 'package:login_signup/quizeasy/s8.dart';
import 'package:login_signup/quizeasy/s9.dart';
import 'package:login_signup/screens/hindi/dashpageHindi.dart';
import 'package:login_signup/screens/hindi/quizeasyhindi/pt_1ehindi.dart';
import 'package:login_signup/screens/hindi/quizeasyhindi/pt_3ehindi.dart';

class Contents1hindi extends StatefulWidget {
  const Contents1hindi({super.key});

  @override
  State<Contents1hindi> createState() => _ContentsState();
}

class _ContentsState extends State<Contents1hindi> {
  final List<Map<String, String>> contents = [
    {'title': 'भाग I: संघ और इसका क्षेत्र', 'route': '/part1'},
    {'title': 'भाग II: नागरिकता', 'route': '/part2'},
    {'title': 'भाग III: मौलिक अधिकार', 'route': '/part3'},
    {'title': 'भाग IV: राज्य नीति के निदेशात्मक सिद्धांत', 'route': '/part4'},
    {'title': 'भाग IV-A: मौलिक कर्तव्य', 'route': '/part4A'},
    {'title': 'भाग V: संघ', 'route': '/part5'},
    {'title': 'भाग VI: राज्य', 'route': '/part6'},
    {
      'title': 'भाग VII: पहले अनुसूची के B भाग में राज्य (रद्द कर दिए गए)',
      'route': '/part7'
    },
    {'title': 'भाग VIII: संघ क्षेत्र', 'route': '/part8'},
    {'title': 'भाग IX: पंचायतें', 'route': '/part9'},
    {'title': 'भाग IX-A: नगर निगम', 'route': '/part9A'},
    {'title': 'भाग X: अनुसूचित और जनजातीय क्षेत्र', 'route': '/part10'},
    {'title': 'भाग XI: संघ और राज्यों के बीच संबंध', 'route': '/part11'},
    {'title': 'भाग XII: वित्त, संपत्ति, अनुबंध और मुकदमे', 'route': '/part12'},
    {
      'title': 'भाग XIII: भारत के क्षेत्र के भीतर व्यापार, वाणिज्य और संपर्क',
      'route': '/part13'
    },
    {'title': 'भाग XIV: संघ और राज्यों के तहत सेवाएं', 'route': '/part14'},
    {'title': 'भाग XIV-A: न्यायाधिकरण', 'route': '/part14A'},
    {'title': 'भाग XV: चुनाव', 'route': '/part15'},
    {
      'title': 'भाग XVI: कुछ वर्गों से संबंधित विशेष प्रावधान',
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
    {'title': 'अनुसूची I: संघ और राज्यों की सीमाएँ', 'route': '/schedule1'},
    {'title': 'अनुसूची II: शपथ और पुष्टि', 'route': '/schedule2'},
    {'title': 'अनुसूची III: शपथ और पुष्टि के रूप', 'route': '/schedule3'},
    {'title': 'अनुसूची IV: राज्यसभा में सीटों का आवंटन', 'route': '/schedule4'},
    {
      'title':
          'अनुसूची V: अनुसूचित क्षेत्रों और जनजातीय क्षेत्रों के प्रशासन और नियंत्रण से संबंधित प्रावधान',
      'route': '/schedule5'
    },
    {
      'title':
          'अनुसूची VI: असम, मेघालय, त्रिपुरा, और मिजोरम राज्यों में जनजातीय क्षेत्रों के प्रशासन से संबंधित प्रावधान',
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
    {'title': 'अनुसूची X: एंटी-डिफेक्शन अधिनियम', 'route': '/schedule10'},
    {
      'title': 'अनुसूची XI: पंचायतों की शक्तियाँ, अधिकार और जिम्मेदारियाँ',
      'route': '/schedule11'
    },
    {
      'title': 'अनुसूची XII: नगरपालिकाओं की शक्तियाँ, अधिकार और जिम्मेदारियाँ',
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
        '/part1': (context) => QuizScreen1hindi(),
        '/part2': (context) => QuizScreen2(),
        '/part3': (context) => QuizScreen3hindi(),
        '/part4': (context) => QuizScreen4(),
        '/part4A': (context) => QuizScreen4A(),
        '/part5': (context) => QuizScreen5(),
        '/part6': (context) => QuizScreen6(),
        '/part7': (context) => QuizScreen7(),
        '/part8': (context) => QuizScreen8(),
        '/part9': (context) => QuizScreen9(),
        '/part10': (context) => QuizScreen10(),
        '/part11': (context) => QuizScreen11(),
        '/part12': (context) => QuizScreen12(),
        '/part13': (context) => QuizScreen13(),
        '/part14': (context) => QuizScreen14(),
        '/part14A': (context) => QuizScreen14A(),
        '/part15': (context) => QuizScreen15(),
        '/part16': (context) => QuizScreen16(),
        '/part17': (context) => QuizScreen17(),
        '/part18': (context) => QuizScreen18(),
        '/part19': (context) => QuizScreen19(),
        '/part20': (context) => QuizScreen20(),
        '/part21': (context) => QuizScreen21(),
        '/part22': (context) => QuizScreen22(),
        '/schedule1': (context) => QuizScreenS1(),
        '/schedule2': (context) => QuizScreenS2(),
        '/schedule3': (context) => QuizScreenS3(),
        '/schedule4': (context) => QuizScreenS4(),
        '/schedule5': (context) => QuizScreenS5(),
        '/schedule6': (context) => QuizScreenS6(),
        '/schedule7': (context) => QuizScreenS7(),
        '/schedule8': (context) => QuizScreenS8(),
        '/schedule9': (context) => QuizScreenS9(),
        '/schedule10': (context) => QuizScreenS10(),
        '/schedule11': (context) => QuizScreenS11(),
        '/schedule12': (context) => QuizScreenS12(),
      },
      home: Scaffold(
        appBar: AppBar(
          title: const Text('सामग्री : आसान'),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Dashpagehindi()), // Replace with your actual Dashpage class
              );
            },
          ),
        ),
        body: Stack(
          children: [
            // Background image
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
