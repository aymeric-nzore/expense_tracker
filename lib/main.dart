import 'package:expense_tracker_app/features/auth/services/auth_gate.dart';
import 'package:expense_tracker_app/firebase_options.dart';
import 'package:expense_tracker_app/features/transaction/providers/transaction_provider.dart';
import 'package:expense_tracker_app/features/transaction/providers/category_provider.dart';
import 'package:expense_tracker_app/core/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Guu-Guu',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themedata.copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          darkTheme: themeProvider.themedata.copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(
              ThemeData(brightness: Brightness.dark).textTheme,
            ),
          ),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: AuthGate(),
        );
      },
    );
  }
}
