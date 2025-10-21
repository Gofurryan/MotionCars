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

  // 3. Definisikan controller dan animasi
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  void _login() {
   final isValid = _formKey.currentState!.validate();

    // Jika validasi GAGAL (karena password < 8), validator sudah menampilkan Snackbar error.
    // Jadi, kita hanya perlu menangani kasus SUKSES di sini.
    if (isValid) {
      // 1. Tampilkan Snackbar Sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login Berhasil! Mengalihkan...'),
          backgroundColor: Colors.green, // Warna hijau untuk sukses
          duration: const Duration(seconds: 2), // Durasi tampil
        ),
      );

      // 2. Tunggu sebentar agar Snackbar terlihat, lalu navigasi
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) { // Pastikan widget masih ada
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

    // 4. Inisialisasi controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Durasi 3 detik per siklus
    )..repeat(reverse: true); // Ulangi bolak-balik (besar-kecil-besar)

    // 5. Inisialisasi animasi
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.05).animate( // Ber-animasi antara 95% dan 105% ukuran asli
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }


  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose(); // 6. JANGAN LUPA dispose controller!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Tambahkan ini
      body: Container( // Bungkus dengan Container
        decoration: kAppBackgroundGradient(), // Terapkan gradient
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox( // Batasi lebar form
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, // Ubah ke center
                    children: [
                      
                      // --- PERUBAHAN DI SINI ---
                      // 7. Bungkus Image.asset dengan ScaleTransition
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Image.asset('assets/images/logo.png', height: 80),
                      ),
                      // --- AKHIR PERUBAHAN ---

                      const SizedBox(height: 40),
                      Shimmer.fromColors(
                        baseColor: Colors.blueGrey, // Warna teks dasar
                        highlightColor: Colors.white, // Warna kilauan
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
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade400), // Ganti ke warna tema
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