import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_generator_app/Auth/auth_page.dart';
import 'package:quiz_generator_app/Provider/sign_in_provider.dart';
import 'package:quiz_generator_app/Provider/theme_provider.dart';
import 'package:quiz_generator_app/firebase_options.dart';
import 'package:quiz_generator_app/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Firebase needs this
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // from firebase_options.dart
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignInProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(builder: (context, obj, _) {
        return MaterialApp(
             debugShowCheckedModeBanner: false,
            themeMode: obj.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.deepPurple,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.deepPurple,
            ),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return HomePage();
                } else {
                  return AuthPage();
                }
              },
            ),
          );
      }),
    );
  }
}
