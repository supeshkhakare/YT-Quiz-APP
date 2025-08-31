import 'dart:convert';
import 'dart:developer'; //

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

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
    log('[INIT] LoadingScreen initState called');
    generateQuiz();
  }

  Future<void> generateQuiz() async {
    final backendUrl = "http://192.168.43.65:4000/transcript".trim();

    log('[STEP 1] generateQuiz() started');
    log('[STEP 2] Received YouTube link: ${widget.youtubeLink}');
    log('[STEP 3] Backend URL: $backendUrl');

    try {
      final uri = Uri.parse(backendUrl);
      final body = jsonEncode({"video_url": widget.youtubeLink});

      log('[STEP 4] Preparing POST request...');
      log('[STEP 5] Request headers: {Content-Type: application/json}');
      log('[STEP 6] Request body: $body');

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      log('[STEP 7] Response received. Status: ${response.statusCode}');
      log('[STEP 8] Raw response length: ${response.body.length} chars');

      if (response.statusCode == 200) {
        log('[STEP 9] Parsing response JSON...');
        final Map<String, dynamic> data = jsonDecode(response.body);

        log('[STEP 10] Checking "quiz" key in JSON...');
        log('[INFO] data keys: ${data.keys.toList()}');

        log('[STEP 11] Mapping JSON -> AutoGenerate model...');
        AutoGenerate autoGenerate = AutoGenerate.fromJson(data);
        List<Quiz> quizList = autoGenerate.quiz;

        log('[STEP 12] quizList created. Count: ${quizList.length}');
        if (quizList.isNotEmpty) {
          log('[INFO] First question preview: ${quizList.first.question}');
        }

        log('[STEP 13] Ensuring minimum Lottie time (3s) ...');
        await Future.delayed(const Duration(seconds: 3));
        log('[STEP 14] Lottie wait done');

        log('[STEP 15] Navigating to QuizPage (mounted: $mounted)');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => QuizPage(questions: quizList)),
          );
          log('[STEP 16] Navigation triggered -> QuizPage');
        } else {
          log('[WARN] Widget not mounted. Navigation skipped.');
        }
      } else {
        final msg = "Error: ${response.statusCode}";
        log(
          '[ERROR] Non-200 status. $msg. Body snippet: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}',
        );
        showErrorSnack(msg);
      }
    } catch (e, st) {
      log('[EXCEPTION] ${e.toString()}');
      log('[STACKTRACE]\n$st');
      showErrorSnack("Failed to connect: $e");
    }
  }

  void showErrorSnack(String message) {
    log('[SNACK] $message');
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } else {
      log('[WARN] Snack not shown because widget is not mounted.');
    }
  }

  @override
  Widget build(BuildContext context) {
    log('[BUILD] LoadingScreen build()');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'Assets/Lottie/gemini.json',
          width: 600,
          height: 600,
        ),
      ),
    );
  }
}
