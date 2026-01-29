import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';
import 'firebase_options.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF22C6FF);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NightlifePass',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0E0E0E),
      ),
      home: const AuthGate(),
    );
  }
}

/// AUTH GATE — decides whether to show login or home
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Not logged in → show login
        if (!snapshot.hasData) return const NightlifeScreen();

        // Logged in → show home screen
        return const HomeScreen();
      },
    );
  }
}

class ImageBox extends StatelessWidget {
  final String? image;
  const ImageBox({super.key, this.image});

  static const String _defaultImage =
      'https://assets.api.uizard.io/api/cdn/stream/3e69235f-0dce-4e87-98c7-b1bc7cf8c0a7.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 194,
      height: 194,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(image ?? _defaultImage),
          fit: BoxFit.cover,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 24,
            spreadRadius: -6,
            offset: Offset(0, 10),
            color: Color(0x8000B7FF),
          ),
        ],
      ),
    );
  }
}

/// Your LOGIN screen remains almost untouched
class NightlifeScreen extends StatelessWidget {
  const NightlifeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final authService = AuthService();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const ImageBox(),
                const SizedBox(height: 40),
                Text(
                  'NightlifePass',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: cs.onBackground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your gateway to nightlife adventures',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 36),

                // GOOGLE LOGIN
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                  ),
                  onPressed: () async {
                    final user = await authService.signInWithGoogle();
                    if (user != null) {
                      // Navigation handled by AuthGate automatically
                      debugPrint("Google login success");
                    }
                  },
                  icon: const FaIcon(FontAwesomeIcons.google, size: 20),
                  label: const Text(
                    'Login with Google',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),

                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
