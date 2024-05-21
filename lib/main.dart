import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:kithap_app/const.dart';
import 'package:kithap_app/provider/auth_provider.dart';
import 'package:kithap_app/screens/LandingPage.dart';
import 'package:provider/provider.dart';
import 'colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Gemini.init(apiKey: GEMINI_API_KEY);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'KitHap',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.appBarBackground,
            iconTheme: IconThemeData(color: AppColors.textPrimary),
            titleTextStyle:
                TextStyle(color: AppColors.textPrimary, fontSize: 20),
          ),
        ),
        home: LandingPage(),
      ),
    );
  }
}
