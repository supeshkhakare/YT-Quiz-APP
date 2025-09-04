import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:quiz_generator_app/Auth/auth_page.dart';
import 'package:quiz_generator_app/Database/database.dart';

import '../Provider/theme_provider.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Drawer(
      backgroundColor: isDark
          ? const Color(0xFF2B2B2B)
          : const Color(0xff2f4f36),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: StreamBuilder(
            stream: DataBaseMethods.getUserDetails(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No user data found"));
              }

              DocumentSnapshot ds = snapshot.data!.docs.first;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: (user?.photoURL != null)
                            ? NetworkImage(user!.photoURL!) as ImageProvider
                            : const AssetImage("Assets/Images/person_img.png"),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              FirebaseAuth.instance.currentUser?.displayName ??
                                  ds["name"],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              FirebaseAuth.instance.currentUser?.email ??
                                  "No email",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Menu Items
                  drawerItem(
                    icon: LucideIcons.user,
                    title: "Profile",
                    selected: true,
                    onTap: () {},
                  ),
                  drawerItem(
                    icon: LucideIcons.info,
                    title: "About",
                    onTap: () {},
                  ),
                  drawerItem(
                    icon: LucideIcons.history,
                    title: "Recents",
                    onTap: () {},
                  ),
                  SwitchListTile(
                    title: Text(
                      "Dark Theme",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    value: context.watch<ThemeProvider>().isDarkMode,
                    onChanged: (value) {
                      context.read<ThemeProvider>().toggleTheme(value);
                    },
                    activeColor: Colors.white,
                  ),
                  drawerItem(
                    icon: LucideIcons.logOut,
                    title: "Logout",
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Sign out Successfully!"),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                        // Navigate after showing the snackbar
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const AuthPage(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                  ),

                  const Spacer(),

                  // Footer
                  Text(
                    'Generate quizzes from YouTube\nvideos in seconds.\n"Learn smarter, play better."',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget drawerItem({
  required IconData icon,
  required String title,
  bool selected = false,
  VoidCallback? onTap,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: selected ? Colors.white.withOpacity(0.15) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
    ),
    child: ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      onTap: onTap,
    ),
  );
}
