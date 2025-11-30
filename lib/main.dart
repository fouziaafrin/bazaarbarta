import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:bazaarbarta/screens/login_screen.dart';
import 'package:bazaarbarta/screens/phone_login.dart';
import 'package:bazaarbarta/screens/otp_verify.dart';
import 'package:bazaarbarta/services/language_service.dart';
import 'package:bazaarbarta/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('bn')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageService()),
        ],
        child: BazaarBartaApp(),
      ),
    ),
  );
}

class BazaarBartaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BazaarBarta',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      //home: LoginScreen(),
      home: FirebaseAuth.instance.currentUser == null ? const PhoneLogin() : const HomeScreen(),
      routes: {
        '/home': (_) => const HomeScreen(),
      },
      //home: PhoneLogin(),

    );
  }
}
