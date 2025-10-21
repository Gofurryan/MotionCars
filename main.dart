import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; 
import 'screens/splash_screen.dart';
import 'screens/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

BoxDecoration kAppBackgroundGradient() {
  return const BoxDecoration(
    gradient: LinearGradient(
      
      
      colors: [Color(0xFF0A0512), Color(0xFF130B1E), Color(0xFF3A1C52)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}
const Color kPrimaryColor = Color.fromARGB(255, 116, 43, 226);
const Color kSurfaceColor = Color(0xFF1F1A33); 

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Katalog Kendaraan',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: kPrimaryColor, 
        scaffoldBackgroundColor: Colors.grey[100], 
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, 
          foregroundColor: Colors.black87, 
          elevation: 1,
        ),
        cardTheme: CardThemeData( 
          color: Colors.white,
          elevation: 2,
          shadowColor: Colors.grey.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme( 
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIconColor: Colors.grey.shade600,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData( 
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
         textButtonTheme: TextButtonThemeData( 
          style: TextButton.styleFrom(
            foregroundColor: kPrimaryColor,
          ),
        ),
        chipTheme: ChipThemeData( 
          backgroundColor: kPrimaryColor.withOpacity(0.1),
          labelStyle: const TextStyle(
              color: kPrimaryColor, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(color: kPrimaryColor),
          ),
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.transparent,
        fontFamily: GoogleFonts.poppins().fontFamily,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          color: kSurfaceColor, 
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kSurfaceColor, 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 197, 184, 217),
          ),
        ),
        
        chipTheme: ChipThemeData(
          backgroundColor: kPrimaryColor.withOpacity(0.2),
          labelStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(color: kPrimaryColor),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}