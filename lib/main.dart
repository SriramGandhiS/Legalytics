import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/route_manager.dart';
import 'package:login_signup/screens/wrapper.dart';
import 'package:login_signup/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA4YPYWoKtnlKtJCz-FN4SIAfSfNW1OidE",
      authDomain: "legalytics-78d5f.firebaseapp.com",
      projectId: "legalytics-78d5f",
      storageBucket: "legalytics-78d5f.firebasestorage.app",
      messagingSenderId: "96069188364",
      appId: "1:96069188364:web:71c73aae2eaf0f84ce2729",
      measurementId: "G-KSNQX9QFG6",
    ),
  );
  
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ROI',
      theme: lightMode,
      home: const Wrapper(),
    );
  }
}
