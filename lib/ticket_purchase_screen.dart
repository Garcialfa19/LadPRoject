// ticket_purchase_screen.dart

import 'package:flutter/material.dart';
import 'event_model.dart';

class TicketPurchaseScreen extends StatefulWidget {
  final EventData event;

  const TicketPurchaseScreen({super.key, required this.event});

  @override
  State<TicketPurchaseScreen> createState() => _TicketPurchaseScreenState();
}

class _TicketPurchaseScreenState extends State<TicketPurchaseScreen>
    with SingleTickerProviderStateMixin {
  // Step tracking
  bool step1Open = true;
  bool step2Open = false;
  bool step3Open = false;

  // Step 1
  int ticketCount = 1;

  // Step 2
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // Step 3 (Credit/Debit card fields)
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final cardholderController = TextEditingController();

  String paymentMethod = "Credit Card";

  double get totalPrice {
    double price =
        double.tryParse(widget.event.generalPrice.replaceAll("\$", "")) ?? 0;
    return price * ticketCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161616),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161616),
        elevation: 0,
        title: const Text("Purchase Tickets",
            style: TextStyle(color: Colors.white)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _stepCard(
              title: "Step 1: Select Tickets",
              isOpen: step1Open,
              content: _step1Content(),
              onContinue: () {
                if (ticketCount > 0) {
                  setState(() {
                    step1Open = false;
                    step2Open = true;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            _stepCard(
              title: "Step 2: Enter Your Information",
              isOpen: step2Open,
              content: _step2Content(),
              onContinue: () {
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  setState(() {
                    step2Open = false;
                    step3Open = true;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            _stepCard(
              title: "Step 3: Confirm Payment",
              isOpen: step3Open,
              content: _step3Content(),
              onContinue: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Payment Successful!")),
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------
  // STEP CARD WRAPPER WITH ANIMATION
  // --------------------------------------------------------------
  Widget _stepCard({
    required String title,
    required bool isOpen,
    required Widget content,
    required VoidCallback onContinue,
  }) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            if (isOpen) content,

            if (isOpen)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A72FF),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: onContinue,
                  child: const Text("Continue"),
                ),
              )
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------
  // STEP 1 — SELECT TICKETS
  // --------------------------------------------------------------
  Widget _step1Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Number of Tickets:",
            style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),

        Row(
          children: [
            _qtyButton("-", () {
              if (ticketCount > 1) setState(() => ticketCount--);
            }),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("$ticketCount",
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ),
            _qtyButton("+", () {
              setState(() => ticketCount++);
            }),
          ],
        ),

        const SizedBox(height: 12),

        Text("Total Price: \$${totalPrice.toStringAsFixed(0)}",
            style: const TextStyle(
              color: Color(0xFF4A72FF),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }

  Widget _qtyButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  // --------------------------------------------------------------
  // STEP 2 — USER INFO
  // --------------------------------------------------------------
  Widget _step2Content() {
    return Column(
      children: [
        _input(nameController, "Name"),
        const SizedBox(height: 12),
        _input(emailController, "Email"),
        const SizedBox(height: 12),
        _input(phoneController, "Phone Number"),
      ],
    );
  }

  // --------------------------------------------------------------
  // STEP 3 — PAYMENT INFO
  // --------------------------------------------------------------
  Widget _step3Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Payment Method",
            style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          dropdownColor: Colors.black,
          value: paymentMethod,
          decoration: _ddDecoration(),
          items: const [
            DropdownMenuItem(value: "Credit Card", child: Text("Credit Card")),
            DropdownMenuItem(value: "Debit Card", child: Text("Debit Card")),
          ],
          onChanged: (value) => setState(() => paymentMethod = value!),
        ),

        const SizedBox(height: 20),

        _input(cardholderController, "Cardholder Name"),
        const SizedBox(height: 12),

        _input(cardNumberController, "Card Number"),
        const SizedBox(height: 12),

        _input(expiryController, "MM/YY"),
        const SizedBox(height: 12),

        _input(cvvController, "CVV"),

        const SizedBox(height: 20),
        _input(cvvController, "Discount code (if you have one)"),

        const SizedBox(height: 12),

        Text("Total Payment: \$${totalPrice.toStringAsFixed(0)}",
            style: const TextStyle(
                color: Color(0xFF4A72FF), fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // --------------------------------------------------------------
  // INPUT FIELDS
  // --------------------------------------------------------------
  Widget _input(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF0F0F0F),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  InputDecoration _ddDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF0F0F0F),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
