import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'login_screen.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });

    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: kAppBackgroundGradient(), 
        child: Center(
          child: AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(seconds: 2),
            curve: Curves.easeIn,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: _isVisible ? 1.0 : 0.0,
                  duration: const Duration(seconds: 1), 
                  curve: Curves.elasticOut, 
                  child: Image.asset('assets/images/logo.png', width: 100),
                ),
                
                const SizedBox(height: 20),
                const Text(
                  "MotionCars",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 60),
                LoadingAnimationWidget.staggeredDotsWave(
                  color: kPrimaryColor, // Gunakan warna primer Anda
                  size: 50,
                ),
                const SizedBox(height: 120),
                const Text(
                  "Dibuat oleh: GofurAryan.",
                  style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}