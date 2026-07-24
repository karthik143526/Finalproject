import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';

// ── Color palette (matches complaint.html) ──
const Color kBg = Color(0xFF08050A);
const Color kPanel = Color(0xFF0F0A14);
const Color kOrange = Color(0xFFFF6B2B);
const Color kAmber = Color(0xFFFFAA00);
const Color kRed = Color(0xFFFF3A3A);
const Color kText = Color(0xFFFFF0E8);
const Color kMuted = Color(0xFF6B4A3A);
final Color kBorder = kOrange.withOpacity(0.14);

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  bool _submitting = false;

  final List<String> _issueTypes = [
    'Missed Pickup',
    'Late Service',
    'Bad Behaviour',
    'Other Issue',
  ];
  String _selectedType = 'Missed Pickup';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitComplaint() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final response = await ApiService.submitComplaint(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      type: _selectedType,
      message: _messageController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Complaint submitted successfully'),
          backgroundColor: kOrange,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Failed to submit complaint'),
          backgroundColor: kRed,
        ),
      );
    }
  }

  void _goBack() {
    // Original HTML: onclick="window.location.href='dashboard.html'"
    Navigator.of(context).pop();
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: kMuted.withOpacity(0.85), fontSize: 14),
      filled: true,
      fillColor: Colors.white.withOpacity(0.03),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: kOrange.withOpacity(0.5), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kRed),
      ),
    );
  }

  Widget _label(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 11)),
          const SizedBox(width: 6),
          Text(
            text.toUpperCase(),
            style: const TextStyle(
              color: kMuted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          // ambient glow blobs
          Positioned(
            top: -100,
            right: -80,
            child: _blob(380, kOrange.withOpacity(0.10)),
          ),
          Positioned(
            bottom: -70,
            left: -60,
            child: _blob(280, kRed.withOpacity(0.08)),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: 460,
                constraints: const BoxConstraints(maxWidth: 460),
                padding: const EdgeInsets.fromLTRB(32, 50, 32, 42),
                decoration: BoxDecoration(
                  color: kPanel,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: kBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 60,
                      offset: const Offset(0, 32),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Alert tag ──
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: kBorder),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: kOrange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'ISSUE REPORT',
                              style: TextStyle(
                                color: kOrange,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Title ──
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: kText,
                            height: 1.15,
                          ),
                          children: [
                            TextSpan(text: 'Raise a '),
                            TextSpan(
                              text: 'Complaint',
                              style: TextStyle(color: kOrange),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        "Submit your concern and we'll resolve it fast.",
                        style: TextStyle(color: kMuted, fontSize: 12.5, height: 1.5),
                      ),
                      const SizedBox(height: 30),

                      // ── Name / Phone row ──
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('👤', 'Name'),
                                TextFormField(
                                  controller: _nameController,
                                  style: const TextStyle(color: kText, fontSize: 14),
                                  decoration: _fieldDecoration('Enter Name'),
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('📞', 'Phone'),
                                TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(color: kText, fontSize: 14),
                                  decoration: _fieldDecoration('Phone Number'),
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // ── Issue type dropdown ──
                      _label('⚠️', 'Issue Type'),
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        icon: const Icon(Icons.arrow_drop_down, color: kMuted),
                        dropdownColor: kPanel,
                        style: const TextStyle(color: kText, fontSize: 14),
                        decoration: _fieldDecoration(''),
                        items: _issueTypes
                            .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedType = v!),
                      ),
                      const SizedBox(height: 15),

                      // ── Description ──
                      _label('📝', 'Description'),
                      TextFormField(
                        controller: _messageController,
                        style: const TextStyle(color: kText, fontSize: 14),
                        maxLines: 5,
                        decoration: _fieldDecoration('Describe your issue...'),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),

                      const SizedBox(height: 22),
                      Container(height: 1, color: kBorder),
                      const SizedBox(height: 22),

                      // ── Submit button ──
                      SizedBox(
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [kOrange, kAmber],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: _submitComplaint,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Center(
                                  child: Text(
                                    '⚡  SUBMIT COMPLAINT',
                                    style: TextStyle(
                                      color: Color(0xFF1A0800),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ── Back button ──
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _goBack,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            side: BorderSide(color: Colors.white.withOpacity(0.07)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '←  GO BACK',
                            style: TextStyle(
                              color: kMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}