import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';
import 'event_model.dart';
import 'event_details_screen.dart';
import 'my_tickets_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

// SCREEN WRAPPER
class ScreenContainer extends StatelessWidget {
  final Widget child;
  const ScreenContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF161616),
      child: child,
    );
  }
}

// EVENT IMAGE WIDGET
class EventImageBox extends StatelessWidget {
  final String imageUrl;
  const EventImageBox({super.key, required this.imageUrl});

  static const String _fallbackAsset = 'images/imagenotfound.png';

  bool get _hasValidUrl => imageUrl.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 148,
        width: double.infinity,
        child: _hasValidUrl
            ? Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Image.asset(
              _fallbackAsset,
              fit: BoxFit.cover,
            );
          },
        )
            : Image.asset(
          _fallbackAsset,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// FOOTER NAVIGATION
class BottomNavFooter extends StatelessWidget {
  const BottomNavFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: const BoxDecoration(color: Color(0xFF2E2E2E)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(Icons.location_on_outlined, color: Colors.white70),
          Icon(Icons.calendar_month_outlined, color: Colors.white70),
          Icon(Icons.favorite_border, color: Colors.white70),
          Icon(Icons.person_outline, color: Colors.white70),
        ],
      ),
    );
  }
}

// MAIN SCREEN
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? "Night Owl";

    final EventData event1 = EventData(
      title: "Neon Nights Extravaganza",
      date: "Saturday, April 15, 2024",
      time: "9:00 PM – 3:00 AM",
      venue: "Electric Venue, Downtown",
      imageUrl:
      "https://images.unsplash.com/photo-1464375117522-1311d6a5b81a",
      generalPrice: "\$50",
      vipPrice: "\$120",
    );

    final EventData event2 = EventData(
      title: "Retro Vibes Party",
      date: "Saturday, April 22, 2024",
      time: "10:00 PM – 4:00 AM",
      venue: "Club Retro, 5th Avenue",
      imageUrl:
      "https://images.unsplash.com/photo-1489515217757-5fd1be406fef",
      generalPrice: "\$40",
      vipPrice: "\$100",
    );

    return ScreenContainer(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,

        // DRAWER
        drawer: Drawer(
          backgroundColor: const Color(0xFF1E1E1E),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Menu",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Divider(color: Colors.white24),

                _drawerButton(
                  context,
                  Icons.explore_outlined,
                  "Explore Events",
                      () => Navigator.pop(context),
                ),

                _drawerButton(
                  context,
                  Icons.confirmation_number_outlined,
                  "My Tickets",
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyTicketsScreen(),
                    ),
                  ),
                ),

                _drawerButton(
                  context,
                  Icons.person_outline,
                  "Profile",
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  ),
                ),

                _drawerButton(
                  context,
                  Icons.settings_outlined,
                  "Settings",
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  ),
                ),

                const Spacer(),

                _drawerButton(
                  context,
                  Icons.logout,
                  "Logout",
                      () async {
                    await AuthService().signOut();
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // BODY
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1581974898390-0b7dbcfb4490",
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Image.asset(
                            'images/imagenotfound.png',
                            height: 190,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),

                    Positioned(
                      top: 16,
                      left: 12,
                      child: GestureDetector(
                        onTap: () =>
                            scaffoldKey.currentState?.openDrawer(),
                        child: const Icon(Icons.menu,
                            color: Colors.white, size: 28),
                      ),
                    ),

                    const Positioned(
                      top: 16,
                      right: 12,
                      child:
                      Icon(Icons.person, color: Colors.white, size: 28),
                    ),

                    Positioned(
                      bottom: 16,
                      left: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome, $displayName!",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Explore nightlife at your fingertips",
                            style:
                            TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 30),

                Text(
                  "Featured events",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: cs.onBackground,
                  ),
                ),

                const SizedBox(height: 14),

                EventImageBox(imageUrl: event1.imageUrl),
                const SizedBox(height: 8),
                Text(
                  event1.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(event1.venue,
                    style: const TextStyle(color: Colors.white60)),
                const SizedBox(height: 8),
                _ticketsButton(context, event1),

                const SizedBox(height: 20),

                EventImageBox(imageUrl: event2.imageUrl),
                const SizedBox(height: 8),
                Text(
                  event2.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(event2.venue,
                    style: const TextStyle(color: Colors.white60)),
                const SizedBox(height: 8),
                _ticketsButton(context, event2),

                const SizedBox(height: 140),
              ],
            ),
          ),
        ),

        bottomNavigationBar: const BottomNavFooter(),
      ),
    );
  }

  // DRAWER BUTTON
  Widget _drawerButton(
      BuildContext context,
      IconData icon,
      String text,
      VoidCallback onTap,
      ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  // TICKETS BUTTON
  Widget _ticketsButton(BuildContext context, EventData event) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventDetailsScreen(event: event),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF4A72FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Get Tickets",
            style:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
