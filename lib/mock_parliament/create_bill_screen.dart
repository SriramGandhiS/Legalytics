import 'dart:ui';
import 'package:flutter/material.dart';
import 'debate_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateBillScreen extends StatefulWidget {
  final String role;

  const CreateBillScreen({super.key, required this.role});

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _proposeBill(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) =>
              const Center(child: CircularProgressIndicator(color: Colors.white)),
        );

        final docRef =
            await FirebaseFirestore.instance.collection('bills').add({
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'category': _selectedCategory,
          'proposedBy':
              FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
          'role': widget.role,
          'timestamp': Timestamp.now(),
          'votesFor': 0,
          'votesAgainst': 0,
        });

        Navigator.of(context).pop(); // Close loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("✅ Bill proposed successfully!",
                  style: TextStyle(fontWeight: FontWeight.bold))),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => DebateScreen(billId: docRef.id)),
        );
      } catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1B2D33);
    const Color accentColor = Color(0xFF3E7B87);
    const Color lightAccent = Color(0xFFB4D6CD);

    return Scaffold(
      appBar: AppBar(
        title: Text("Create a Bill - ${widget.role}",
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 3,
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset("assets/images/hbg.jpg", fit: BoxFit.cover)),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          FadeTransition(
            opacity: _fadeController,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(color: Colors.white30),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10)
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            "Propose a New Bill",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Title Field
                          _glassTextField(
                            controller: _titleController,
                            label: "Bill Title",
                            hint: "Enter the title of your bill",
                          ),
                          const SizedBox(height: 20),

                          // Description Field
                          _glassTextField(
                            controller: _descriptionController,
                            label: "Bill Description",
                            hint: "Describe the content of your bill",
                            maxLines: 4,
                          ),
                          const SizedBox(height: 20),

                          // Category Dropdown
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            dropdownColor: primaryColor,
                            decoration: InputDecoration(
                              labelText: "Bill Category",
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Education',
                                child: Text('Education'),
                              ),
                              DropdownMenuItem(
                                value: 'Health',
                                child: Text('Health'),
                              ),
                              DropdownMenuItem(
                                value: 'Environment',
                                child: Text('Environment'),
                              ),
                              DropdownMenuItem(
                                value: 'Technology',
                                child: Text('Technology'),
                              ),
                            ],
                            onChanged: (value) =>
                                setState(() => _selectedCategory = value),
                            validator: (value) => value == null
                                ? 'Please select a category'
                                : null,
                          ),
                          const SizedBox(height: 30),

                          // Submit Button
                          _animatedButton(
                            "Propose Bill",
                            () => _proposeBill(context),
                            accentColor,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Previously Proposed Bills",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('bills')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator(
                                color: Colors.white));
                      }

                      final bills = snapshot.data!.docs;

                      if (bills.isEmpty) {
                        return const Text(
                          "No previously proposed bills.",
                          style:
                              TextStyle(fontSize: 18, color: Colors.white70),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: bills.length,
                        itemBuilder: (context, index) {
                          final billData = bills[index].data()
                              as Map<String, dynamic>;
                          return _glassBillCard(billData, lightAccent);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFFB4D6CD), width: 1.5),
        ),
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? "Field cannot be empty" : null,
    );
  }

  Widget _animatedButton(String text, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "Propose Bill",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _glassBillCard(Map<String, dynamic> billData, Color borderColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: borderColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        title: Text(billData['title'],
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(
          billData['description'],
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Text(
          'Votes: ${billData['votesFor']}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
