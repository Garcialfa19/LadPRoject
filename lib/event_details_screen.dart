// event_details_screen.dart
//
// Interactive, touch/zoom map component (NOT an image)
// Uses OpenStreetMap via flutter_map (free, no API key)
//
// Add to pubspec.yaml:
// dependencies:
//   flutter_map: ^6.1.0
//   latlong2: ^0.9.1

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'event_model.dart';
import 'ticket_purchase_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventData event;

  const EventDetailsScreen({super.key, required this.event});

  LatLng _newYorkLatLng() {
    return const LatLng(40.7128, -74.0060);
  }


  @override
  Widget build(BuildContext context) {
    final LatLng randomLocation = _newYorkLatLng();

    return Scaffold(
      backgroundColor: const Color(0xFF161616),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161616),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "NightOut",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: const [
          Icon(Icons.share, color: Colors.white),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                event.imageUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Image.asset(
                    'images/imagenotfound.png',
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Event title
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              "Date: ${event.date}",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 6),

            Text(
              "Time: ${event.time}",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Venue Section
            const Text(
              "Venue",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              event.venue,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),

            const SizedBox(height: 14),

            // INTERACTIVE MAP (touch + zoom)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: randomLocation,
                    initialZoom: 15,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all, // pan, zoom, rotate, etc.
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.yourcompany.nightout',
                      // Optional: keep tiles dark-ish by reducing brightness with ColorFiltered
                      // but leaving default for simplicity.
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: randomLocation,
                          width: 42,
                          height: 42,
                          child: const Icon(
                            Icons.location_pin,
                            size: 42,
                            color: Color(0xFF4A72FF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Ticket Pricing",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            Text(
              "General Admission: ${event.generalPrice}",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 6),

            Text(
              "VIP: ${event.vipPrice}",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Buy Tickets Button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TicketPurchaseScreen(event: event),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A72FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Buy Tickets",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Add to Calendar", style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.share, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Share", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
