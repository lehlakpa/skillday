import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillday/bloc/auth_bloc.dart';
import 'package:skillday/repositry/auth_repositry.dart';
import 'package:skillday/screens/login_screen.dart';
import 'package:skillday/custom_widgets.dart/custom_appbar.dart';
import 'package:skillday/custom_widgets.dart/custom_buttom_navigation.dart';
import 'package:skillday/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authRepository = AuthRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authRepository),
      child: MaterialApp(
        title: 'SkillDay',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasData) {
              return const HomeScreen();
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppbar(), // Added the missing comma here
      body: Center(
        child: Text(
          "Main Content Area",
        ), // This is where your page content goes
      ),
      bottomNavigationBar: CustomBottomNavigation(), // Moved from body to here
    );
  }
}
