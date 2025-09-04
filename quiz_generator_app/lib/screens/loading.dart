import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quiz_generator_app/Provider/theme_provider.dart';
import 'package:quiz_generator_app/screens/home_page.dart';

import '../model/quiz_model.dart';
import 'quiz_page.dart';

class LoadingScreen extends StatefulWidget {
  final String youtubeLink;
  const LoadingScreen({super.key, required this.youtubeLink});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    generateQuiz();
  }

  Future<void> generateQuiz() async {
    final backendUrl = "http://192.168.43.65:4000/transcript".trim();
    try {
      final uri = Uri.parse(backendUrl);
      final body = jsonEncode({"video_url": widget.youtubeLink});
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        AutoGenerate autoGenerate = AutoGenerate.fromJson(data);
        List<Quiz> quizList = autoGenerate.quiz;
        await Future.delayed(const Duration(seconds: 3));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => QuizPage(questions: quizList)),
          );
         
        } else {
         
        }
      } else {
        final msg = "Error: ${response.statusCode}";
        log(
          '[ERROR] Non-200 status. $msg. Body snippet: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text("No transcript found for video"),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e, st) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text("No transcript found for video"),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      log('[EXCEPTION] ${e.toString()}');
      log('[STACKTRACE]\n$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
   
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xff000000)
          : const Color(0xfff8f9fc),
      body: Center(
        child: Lottie.asset(
          isDark
              ? 'Assets/Lottie/Loader_black.json'
              : 'Assets/Lottie/Loader_white.json',
          width: 600,
          height: 600,
        ),
      ),
    );
  }
}
