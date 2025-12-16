import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'home_screen.dart';
import 'theme_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.school,
                size: 60,
                color: themeProvider.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'مكتب الرؤية',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'الدراسة في رواندا',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 30),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                // ignore: deprecated_member_use
                Colors.white.withOpacity(0.8),
              ),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
