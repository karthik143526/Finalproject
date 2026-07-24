// tracking_screen.dart
// Flutter port of tracking.html — same glassmorphism dark teal design:
// • Animated gradient background (dark blue/teal)
// • Glass container with glowing green border
// • Phone number input field
// • Track button + Go Back button
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  bool _loading = false;
  Map<String, dynamic>? _result;
  String? _error;

  late AnimationController _bgCtrl;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _bgCtrl.dispose();
    super.dispose();
  }

  Future<void> _track() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() => _error = 'Please enter your phone number.');
      return;
    }
    setState(() {
      _loading = true;
      _result = null;
      _error = null;
    });

    try {
      final res = await ApiService.trackRequest(phone);
      if (!mounted) return;
      if (res['status'] == 'success') {
        final latest = res['latest'] as Map<String, dynamic>? ?? res;
        setState(() {
          _result = latest;
          _loading = false;
        });
      } else {
        setState(() {
          _error = res['message'] ?? 'No tracking data found.';
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Connection error. Please try again.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgCtrl,
        builder: (_, __) {
          final t = _bgCtrl.value;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(const Color(0xFF0F2027), const Color(0xFF2C5364), t)!,
                  Color.lerp(const Color(0xFF203A43), const Color(0xFF0F2027), t)!,
                  Color.lerp(const Color(0xFF2C5364), const Color(0xFF203A43), t)!,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Glow circles
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: MediaQuery.of(context).size.width * 0.1,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF00FFCC).withOpacity(0.12 + t * 0.08),
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF00CCFF).withOpacity(0.10 + t * 0.06),
                    ),
                  ),
                ),

                // Main content
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Container(
                        width: 360,
                        padding: const EdgeInsets.all(36),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF00FFCC).withOpacity(0.35),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.7),
                              blurRadius: 50,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icon + Title
                            const Icon(
                              Icons.location_searching_rounded,
                              color: Color(0xFF00FFCC),
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Track Your Request',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF00FFCC),
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  const Shadow(
                                    color: Color(0xFF00FFCC),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 28),

                            // Phone input
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Enter Phone Number',
                                hintStyle: GoogleFonts.poppins(
                                    color: Colors.white54, fontSize: 14),
                                prefixIcon: const Icon(Icons.phone_rounded,
                                    color: Color(0xFF00FFCC), size: 20),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.6),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF00FFCC), width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Error
                            if (_error != null)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.redAccent.withOpacity(0.4)),
                                ),
                                child: Text(_error!,
                                    style: GoogleFonts.poppins(
                                        color: Colors.redAccent, fontSize: 13),
                                    textAlign: TextAlign.center),
                              ),

                            // Track result
                            if (_result != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00FFCC).withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color:
                                          const Color(0xFF00FFCC).withOpacity(0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _resultRow('Name', _result!['name'] ?? '-'),
                                    _resultRow('Phone', _result!['phone'] ?? '-'),
                                    _resultRow('Address', _result!['address'] ?? '-'),
                                    _resultRow('Status', _result!['status'] ?? '-',
                                        highlight: true),
                                    if (_result!['scheduled_date'] != null)
                                      _resultRow('Scheduled',
                                          _result!['scheduled_date']),
                                  ],
                                ),
                              ),
                            ],

                            const SizedBox(height: 16),

                            // Track button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: _loading ? null : _track,
                                icon: _loading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.black))
                                    : const Icon(Icons.search_rounded,
                                        size: 20),
                                label: Text(
                                  _loading ? 'Tracking...' : 'Track',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00FFCC),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Go Back button
                            SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back_rounded,
                                    size: 18),
                                label: Text('Go Back',
                                    style: GoogleFonts.poppins(fontSize: 14)),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: const Color(0xFF333333),
                                  foregroundColor: Colors.white,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
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
        },
      ),
    );
  }

  Widget _resultRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ',
              style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(value,
                style: GoogleFonts.poppins(
                  color: highlight
                      ? const Color(0xFF00FFCC)
                      : Colors.white,
                  fontSize: 12,
                  fontWeight:
                      highlight ? FontWeight.w700 : FontWeight.w400,
                )),
          ),
        ],
      ),
    );
  }
}
