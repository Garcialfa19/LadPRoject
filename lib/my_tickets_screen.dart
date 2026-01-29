import 'package:flutter/material.dart';

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161616),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("My Tickets"),
      ),
      body: const Center(
        child: Text(
          "Your purchased tickets will appear here",
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
