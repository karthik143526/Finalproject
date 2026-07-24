import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // ---- Theme colors (from :root CSS vars in feedback.html) ----
  static const cyan = Color(0xFF00FFCC);
  static const blue = Color(0xFF00AAFF);
  static const bg = Color(0xFF040D0B);
  static const panel = Color(0xFF091512);
  static const borderColor = Color(0x2200FFCC); // rgba(0,255,204,0.13)
  static const text = Color(0xFFDFFFF8);
  static const muted = Color(0xFF2A6B5E);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  String? _rating; // "1".."5"
  String? _drawbackOption; // "Yes" / "No"
  final TextEditingController _drawbackTextController = TextEditingController();
  bool _submitting = false;

  bool get _showDrawbackText => _drawbackOption == 'Yes';

  @override
  void dispose() {
    _nameController.dispose();
    _drawbackTextController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final ratingInt = int.tryParse(_rating ?? '0') ?? 0;

    final response = await ApiService.submitFeedback(
      name: _nameController.text.trim(),
      rating: ratingInt,
      drawbackOption: _drawbackOption ?? '',
      drawbackText: _showDrawbackText ? _drawbackTextController.text.trim() : '',
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? '✨ Feedback submitted!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Failed to submit feedback'), backgroundColor: Colors.redAccent),
      );
    }
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: muted.withOpacity(0.9), fontSize: 14),
      filled: true,
      fillColor: cyan.withOpacity(0.03),
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
        borderSide: BorderSide(color: cyan.withOpacity(0.5), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: muted,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
              decoration: BoxDecoration(
                color: panel,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.8),
                    blurRadius: 90,
                    offset: const Offset(0, 30),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ---- Header ----
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: const BoxDecoration(
                            color: cyan,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Text(
                          'RESPONSE PORTAL',
                          style: TextStyle(
                            color: cyan,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: text,
                        ),
                        children: [
                          const TextSpan(text: 'Share Your '),
                          TextSpan(
                            text: 'Feedback',
                            style: TextStyle(
                              foreground: Paint()
                                ..shader = LinearGradient(
                                  colors: [cyan, blue],
                                ).createShader(
                                  const Rect.fromLTWH(0, 0, 120, 20),
                                ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Help us improve by sharing your honest experience.',
                      style: TextStyle(color: muted, fontSize: 12.5, height: 1.5),
                    ),
                    const SizedBox(height: 30),

                    // ---- Name field ----
                    _label('👤 YOUR NAME'),
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: text, fontSize: 14),
                      decoration: _fieldDecoration('Enter Name'),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 15),

                    // ---- Rating field ----
                    _label('⭐ RATING'),
                    DropdownButtonFormField<String>(
                      value: _rating,
                      dropdownColor: panel,
                      style: const TextStyle(color: text, fontSize: 14),
                      decoration: _fieldDecoration('Select Rating'),
                      icon: const Icon(Icons.arrow_drop_down, color: muted),
                      items: const [
                        DropdownMenuItem(value: '5', child: Text('⭐⭐⭐⭐⭐')),
                        DropdownMenuItem(value: '4', child: Text('⭐⭐⭐⭐')),
                        DropdownMenuItem(value: '3', child: Text('⭐⭐⭐')),
                        DropdownMenuItem(value: '2', child: Text('⭐⭐')),
                        DropdownMenuItem(value: '1', child: Text('⭐')),
                      ],
                      onChanged: (v) => setState(() => _rating = v),
                      validator: (v) => v == null ? 'Please select a rating' : null,
                    ),
                    const SizedBox(height: 15),

                    // ---- Drawback dropdown (mirrors toggleDrawback()) ----
                    _label('💭 ANY DRAWBACK?'),
                    DropdownButtonFormField<String>(
                      value: _drawbackOption,
                      dropdownColor: panel,
                      style: const TextStyle(color: text, fontSize: 14),
                      decoration: _fieldDecoration('Any Drawback?'),
                      icon: const Icon(Icons.arrow_drop_down, color: muted),
                      items: const [
                        DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                        DropdownMenuItem(value: 'No', child: Text('No')),
                      ],
                      onChanged: (v) => setState(() => _drawbackOption = v),
                    ),

                    // ---- Drawback textarea, shown only if Yes ----
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      child: _showDrawbackText
                          ? Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: TextFormField(
                                controller: _drawbackTextController,
                                style: const TextStyle(color: text, fontSize: 14),
                                maxLines: 4,
                                minLines: 3,
                                decoration: _fieldDecoration('Describe the issue...'),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 22),
                    Divider(color: borderColor, thickness: 1),
                    const SizedBox(height: 22),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _submitFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cyan,
                          foregroundColor: const Color(0xFF021A18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ).copyWith(
                          backgroundColor: WidgetStateProperty.all(cyan),
                        ),
                        child: _submitting
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                            : const Text(
                                '✨  SUBMIT FEEDBACK',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  fontSize: 11,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ---- Back button ----
                    SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: muted,
                          side: BorderSide(color: Colors.white.withOpacity(0.07)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '←  GO BACK',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            fontSize: 10,
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
      ),
    );
  }
}