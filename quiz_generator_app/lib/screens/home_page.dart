import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_generator_app/Provider/theme_provider.dart';
import 'package:quiz_generator_app/Widgets/custom_drawer.dart';
import 'package:quiz_generator_app/screens/loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final linkController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    linkController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    print("Build DupliHOME");
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xff000000)
          : const Color(0xfff8f9fc),
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  'Quiz App',
                  style: GoogleFonts.dancingScript(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  'Quiz is generated on basis of your provided video content.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: isDark ? Colors.grey[300] : Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 40),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: linkController,
                        decoration: InputDecoration(
                          hintText: 'Paste YT link here...',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          filled: true,
                         fillColor: isDark ? Colors.black54 : Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          log("loading page PUSHED");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LoadingScreen(
                                youtubeLink: linkController.text,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Go!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
