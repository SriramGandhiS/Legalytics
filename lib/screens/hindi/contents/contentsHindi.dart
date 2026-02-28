import 'package:flutter/material.dart';
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
import 'package:login_signup/screens/hindi/contents/pt_1hindi.dart';
import 'package:login_signup/screens/hindi/contents/pt_2hindi.dart';
import 'package:login_signup/screens/hindi/dashpageHindi.dart';

class Contentshindi extends StatefulWidget {
  const Contentshindi({super.key});

  @override
  State<Contentshindi> createState() => _ContentsState();
}

class _ContentsState extends State<Contentshindi> {
  final List<Map<String, String>> contents = [
    {'title': 'भाग I: संघ और इसका क्षेत्र', 'route': '/part1'},
    {'title': 'भाग II: नागरिकता', 'route': '/part2'},
    {'title': 'भाग III: मौलिक अधिकार', 'route': '/part3'},
    {'title': 'भाग IV: राज्य नीति के निदेशक सिद्धांत', 'route': '/part4'},
    {'title': 'भाग IV-A: मौलिक कर्तव्य', 'route': '/part4A'},
    {'title': 'भाग V: संघ', 'route': '/part5'},
    {'title': 'भाग VI: राज्य', 'route': '/part6'},
    {
      'title': 'भाग VII: पहले अनुसूची के बी भाग में राज्य (रद्द)',
      'route': '/part7'
    },
    {'title': 'भाग VIII: संघ क्षेत्र', 'route': '/part8'},
    {'title': 'भाग IX: पंचायतें', 'route': '/part9'},
    {'title': 'भाग IX-A: नगरपालिकाएँ', 'route': '/part9A'},
    {'title': 'भाग X: अनुसूचित और जनजातीय क्षेत्र', 'route': '/part10'},
    {'title': 'भाग XI: संघ और राज्यों के बीच संबंध', 'route': '/part11'},
    {'title': 'भाग XII: वित्त, संपत्ति, अनुबंध और मुकदमे', 'route': '/part12'},
    {
      'title': 'भाग XIII: भारत के क्षेत्र के भीतर व्यापार, वाणिज्य, और संचार',
      'route': '/part13'
    },
    {'title': 'भाग XIV: संघ और राज्यों के अंतर्गत सेवाएँ', 'route': '/part14'},
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
      'title': 'भाग XXI: अस्थायी, संक्रमणकालीन, और विशेष प्रावधान',
      'route': '/part21'
    },
    {
      'title': 'भाग XXII: संक्षिप्त शीर्षक, प्रारंभ और रद्द',
      'route': '/part22'
    },
    {'title': 'अनुसूची I: संघ और राज्यों के क्षेत्र', 'route': '/schedule1'},
    {'title': 'अनुसूची II: शपथ और प्रतिज्ञाएँ', 'route': '/schedule2'},
    {'title': 'अनुसूची III: शपथ और प्रतिज्ञाओं के रूप', 'route': '/schedule3'},
    {'title': 'अनुसूची IV: राज्यसभा में सीटों का आवंटन', 'route': '/schedule4'},
    {
      'title':
          'अनुसूची V: अनुसूचित क्षेत्रों और जनजातीय क्षेत्रों के प्रशासन और नियंत्रण से संबंधित प्रावधान',
      'route': '/schedule5'
    },
    {
      'title':
          'अनुसूची VI: असम, मेघालय, त्रिपुरा, और मिजोरम के राज्यों में जनजातीय क्षेत्रों के प्रशासन से संबंधित प्रावधान',
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
    {'title': 'अनुसूची X: दलबदल विरोधी अधिनियम', 'route': '/schedule10'},
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
        '/part1': (context) => VideoPlayerScreen1hindi(),
        '/part2': (context) => VideoPlayerScreen2hindi(),
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
          title: const Text('सामग्री : वीडियो'),
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
