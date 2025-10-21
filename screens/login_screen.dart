import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../main.dart';
import 'package:shimmer/shimmer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isPasswordVisible = false;

  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  void _login() {
   final isValid = _formKey.currentState!.validate();

    
    
    if (isValid) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login Berhasil! Mengalihkan...'),
          backgroundColor: Colors.green, 
          duration: const Duration(seconds: 2), 
        ),
      );

      
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) { 
          final String username = _emailController.text.split('@')[0];
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => HomeScreen(email: username)),
          );
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), 
    )..repeat(reverse: true); 

    
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.05).animate( 
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }


  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: Container( 
        decoration: kAppBackgroundGradient(), 
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox( 
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, 
                    children: [

                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Image.asset('assets/images/logo.png', height: 80),
                      ),
                      
                      const SizedBox(height: 40),
                      Shimmer.fromColors(
                        baseColor: Colors.blueGrey, 
                        highlightColor: Colors.white, 
                        period: const Duration(seconds: 3),
                      child:  Text(
                        "Selamat Datang di MotionCars",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Masuk untuk melanjutkan",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade400), 
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: 'Alamat Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty || !value.contains('@')) {
                            return 'Mohon masukkan email yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outlined),
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),  
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 8) {
                            return 'Password harus memiliki minimal 8 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _login,
                        child: const Text('Sign In'),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Lupa Password?'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}