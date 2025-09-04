import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_generator_app/Provider/theme_provider.dart';

import '../model/quiz_model.dart';
import 'Result_page.dart';

class QuizPage extends StatefulWidget {
  final List<Quiz> questions;
  const QuizPage({super.key, required this.questions});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<bool> answers = [];
  int totalScore = 0;
  int currentQuestionIndex = 0;
  int selectedIndex = -1;
  bool answered = false;

  void nextQuestion() {
    debugPrint("Next Question Clicked");

    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedIndex = -1;
        answered = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(answers: answers, totalScore: totalScore),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = widget.questions[currentQuestionIndex];
    final optionsList = currentQ.options;
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xff000000)
          : const Color(0xfff8f9fc),
      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xff000000)
            : const Color(0xfff8f9fc),
        elevation: 0,
        title: Text(
          "Rapid Quiz",
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${currentQuestionIndex + 1} of ${widget.questions.length}",
              style: const TextStyle(color: Colors.purple, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text(
              currentQ.question,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            // Options
            ...List.generate(optionsList.length, (index) {
              bool isSelected = selectedIndex == index;
              bool isCorrect = index == currentQ.correctIndex;

              Color borderColor = Colors.grey.shade300;
              Color bgColor = Colors.white;
              Color textColor = Colors.black;

              if (answered && isSelected) {
                if (isCorrect) {
                  borderColor = Colors.green;
                  bgColor = Colors.green.withOpacity(0.1);
                  textColor = Colors.green;
                } else {
                  borderColor = Colors.red;
                  bgColor = Colors.red.withOpacity(0.1);
                  textColor = Colors.red;
                }
              }

              return GestureDetector(
                onTap: () {
                  if (!answered) {
                    setState(() {
                      selectedIndex = index;
                      answered = true;

                      bool isCorrect = index == currentQ.correctIndex;
                      answers.add(isCorrect);

                      if (isCorrect) {
                        totalScore += 5; // example points
                      }
                    });
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          optionsList[index],
                          style: TextStyle(fontSize: 15, color: textColor),
                        ),
                      ),
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected
                            ? (answered
                                  ? (isCorrect ? Colors.green : Colors.red)
                                  : Colors.purple)
                            : Colors.grey,
                      ),
                    ],
                  ),
                ),
              );
            }),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: answered ? nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  currentQuestionIndex == widget.questions.length - 1
                      ? "Finish"
                      : "Next",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
