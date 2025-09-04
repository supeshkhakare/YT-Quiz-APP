import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_generator_app/Auth/auth_services.dart';
import 'package:quiz_generator_app/Provider/sign_in_provider.dart';
import 'package:quiz_generator_app/screens/forgot_screen.dart';
import 'package:quiz_generator_app/screens/home_page.dart';

class GlassLoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const GlassLoginPage({super.key, required this.showRegisterPage});

  @override
  State<GlassLoginPage> createState() => _GlassLoginPageState();
}

class _GlassLoginPageState extends State<GlassLoginPage>
    with TickerProviderStateMixin {
  final _formkey = GlobalKey<FormState>();

  // Textfield Controllers
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  int count = 0;
  @override
  Widget build(BuildContext context) {
    print("build ${count++}");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF0B0B0D), // dark background
      body: Stack(
        children: [
          // Animated Star Background
          AnimatedBackground(
            vsync: this,
            behaviour: RandomParticleBehaviour(
              options: ParticleOptions(
                baseColor: Colors.white,
                spawnMinRadius: 1.5,
                spawnMaxRadius: 2.5,
                spawnMaxSpeed: 20,
                spawnMinSpeed: 10,
                particleCount: 90,
              ),
            ),
            child: Container(),
          ),

          // Center Glassmorphic Card
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 11, sigmaY: 11),
                child: Container(
                  width: 330,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 17),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.02),
                      width: 1.5,
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo
                          const CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white24,
                            child: Icon(
                              Icons.login,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Title
                          Text(
                            "SIGN-IN",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Email Field
                          Consumer<SignInProvider>(
                            builder: (context, obj, child) {
                              return TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "please enter email";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  obj.updateEmail(value);
                                },
                                controller: _emailcontroller,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withValues(
                                    alpha: 0.1,
                                  ),
                                  hintText: "Email",
                                  hintStyle: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 15),

                          Consumer<SignInProvider>(
                            builder: (context, obj, child) {
                              return TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "please enter password";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  obj.updatePassword(value);
                                },
                                controller: _passwordcontroller,
                                obscureText: obj.obscureText,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withValues(
                                    alpha: 0.1,
                                  ),
                                  hintText: "Password",
                                  hintStyle: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obj.obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      obj.toggleObscureText();
                                    },
                                    color: Colors.white70,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          // Sign IN Provider BUTTON
                          Consumer<SignInProvider>(
                            builder: (context, obj, child) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.15,
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: obj.isLoading
                                      ? null
                                      : () async {
                                          if (_formkey.currentState!
                                              .validate()) {
                                            final user = await obj.signIn(
                                              _emailcontroller.text,
                                              _passwordcontroller.text,
                                            );

                                            if (!mounted) return;

                                            if (user != null) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    content: Text(
                                                      "Login Successful!",
                                                    ),
                                                  ),
                                                );

                                                // Navigator bhi safe only if mounted
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage(),
                                                  ),
                                                );
                                              }
                                            } else {
                                              if (context.mounted) {
                                                // ✅ again check
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                    content: Text(
                                                      obj.errorMessage ??
                                                          "Login failed",
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        },

                                  child: obj.isLoading
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          "Sign in",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 15),

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Forgotpassword(),
                                ),
                              );
                            },
                            child: Text(
                              "Forgot password?",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Google Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.15,
                                ),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                final user =
                                    await AuthServices.signInWithGoogle();
                                if (user != null && mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    ),
                                  ).then(
                                    (val) => ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            content: Text(
                                              "Welcome ${user.displayName}",
                                            ),
                                          ),
                                        ),
                                  );
                                }
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.red,
                              ),
                              label: Text(
                                "Sign in with Google",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Footer
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 4,
                            children: [
                              Text(
                                "Don’t have an account?",
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  widget.showRegisterPage();
                                },
                                child: Text(
                                  "Sign up",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
