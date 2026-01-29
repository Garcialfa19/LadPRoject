import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161616),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Settings"),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text("Notifications", style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.chevron_right, color: Colors.white54),
          ),
          Divider(color: Colors.white24),
          ListTile(
            title: Text("Privacy", style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.chevron_right, color: Colors.white54),
          ),
          Divider(color: Colors.white24),
          ListTile(
            title: Text("About", style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.chevron_right, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
