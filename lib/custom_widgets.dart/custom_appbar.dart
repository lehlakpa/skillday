import 'package:flutter/material.dart';
import 'package:skillday/custom_widgets.dart/fade_annimation.dart';
import 'package:skillday/screens/notification_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    // Return just the AppBar, NOT a Scaffold
    return AppBar(
      backgroundColor: Colors.blue,
      centerTitle: false,
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.person, color: Colors.blue),
        ),
      ),
      title: Text(
        "History",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.white,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                FadePageRoute(page: const NotificationScreen()),
              );
            },
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // This defines the height of your app bar (kToolbarHeight is the standard Flutter height)
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
