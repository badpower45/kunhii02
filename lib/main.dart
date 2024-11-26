import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// استيراد فقط الملفات المستخدمة
import 'screens/start/start_screen.dart';
import 'screens/start/login_screen.dart';
import 'screens/start/register_screen.dart';
import 'screens/start/forget_password_screen.dart';
import 'screens/start/reset_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kunhii App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forget_password': (context) => const LostPasswordPage(),
        '/reset_password': (context) => const ResetPasswordPage(),
      },
    );
  }
}
