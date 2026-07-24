// admin_login_screen.dart
//
// EcoWaste – Admin Login Screen
// Flutter port of admin.html — same dark/gold cyberpunk theme:
// • Deep black background with gold grid overlay
// • Corner bracket card decoration
// • Orbitron-style heading (approximated via google_fonts)
// • Gold particle effect via AnimatedBuilder
// • Secure Access badge with blinking dot
// • Email + Admin ID fields with gold focus glow
// • Shimmer-sweep Login button
//
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'admin_dashboard_screen.dart';
import 'home_screen.dart';

// ── Colour tokens matching admin.html ────────────────────────────────────────
const _bgDeep   = Color(0xFF040608);
const _bgPanel  = Color(0xEB0A0D12);
const _gold     = Color(0xFFF5C518);
const _goldDim  = Color(0xFFC9A012);
const _border   = Color(0x2DF5C518);
const _textCol  = Color(0xFFE8E0CC);
const _textDim  = Color(0xFF7A7060);

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen>
    with TickerProviderStateMixin {
  final _emailController   = TextEditingController();
  final _adminIdController = TextEditingController();
  bool _submitting = false;

  // blinking dot animation
  late AnimationController _blinkCtrl;
  late Animation<double>   _blinkAnim;

  // particle animation
  late AnimationController _particleCtrl;

  @override
  void initState() {
    super.initState();
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _blinkAnim = Tween<double>(begin: 1.0, end: 0.2).animate(_blinkCtrl);

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _adminIdController.dispose();
    _blinkCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  Future<void> _adminLogin() async {
    final email   = _emailController.text.trim();
    final adminId = _adminIdController.text.trim();

    if (email.isEmpty || adminId.isEmpty) {
      _snack('Please fill all fields', Colors.redAccent);
      return;
    }

    setState(() => _submitting = true);
    final response = await ApiService.adminLogin(email, adminId);
    if (!mounted) return;
    setState(() => _submitting = false);

    if (response['status'] == 'success') {
      _snack(response['message'] ?? 'Admin login successful!', _gold,
          textColor: Colors.black);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
    } else {
      _snack(response['message'] ?? 'Invalid Email or Admin ID',
          Colors.redAccent);
    }
  }

  void _snack(String msg, Color bg, {Color textColor = Colors.white}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: GoogleFonts.rajdhani(color: textColor, fontWeight: FontWeight.w600)),
      backgroundColor: bg,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDeep,
      body: Stack(
        children: [
          // ── Grid background ────────────────────────────────────────────────
          _GridBackground(),
          // ── Radial spotlight ──────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.9,
                colors: [
                  const Color(0xFFF5C518).withOpacity(0.07),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // ── Scanlines ─────────────────────────────────────────────────────
          _Scanlines(),
          // ── Floating particles ────────────────────────────────────────────
          _Particles(controller: _particleCtrl),
          // ── Card ──────────────────────────────────────────────────────────
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _Card(
                blinkAnim: _blinkAnim,
                emailController: _emailController,
                adminIdController: _adminIdController,
                submitting: _submitting,
                onLogin: _adminLogin,
                onBack: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen())),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Grid background ───────────────────────────────────────────────────────────
class _GridBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF5C518).withOpacity(0.04)
      ..strokeWidth = 1;
    const step = 48.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Scanlines overlay ─────────────────────────────────────────────────────────
class _Scanlines extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScanlinePainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.12)
      ..strokeWidth = 2;
    for (double y = 2; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Floating particles ────────────────────────────────────────────────────────
class _Particle {
  final double x;
  final double speed;
  final double delay;
  final double dx;
  final double size;

  _Particle({
    required this.x,
    required this.speed,
    required this.delay,
    required this.dx,
    required this.size,
  });
}

class _Particles extends StatelessWidget {
  final AnimationController controller;

  static final _rng = Random(42);
  static final _particles = List.generate(
    28,
    (_) => _Particle(
      x: _rng.nextDouble(),
      speed: 6 + _rng.nextDouble() * 10,
      delay: _rng.nextDouble() * 8,
      dx: (_rng.nextDouble() - 0.5) * 120,
      size: _rng.nextDouble() > 0.7 ? 3 : 2,
    ),
  );

  const _Particles({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = DateTime.now().millisecondsSinceEpoch / 1000.0;
        return CustomPaint(
          painter: _ParticlePainter(particles: _particles, time: t),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double time;

  const _ParticlePainter({required this.particles, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = _gold;
    for (final p in particles) {
      final cycle = (time / p.speed + p.delay) % 1.0;
      // 0→1: bottom to top
      final opacity = cycle < 0.1
          ? cycle / 0.1 * 0.6
          : cycle > 0.9
              ? (1 - cycle) / 0.1 * 0.3
              : 0.3 + (1 - cycle) * 0.3;
      final y = size.height * (1 - cycle) - 20;
      final x = p.x * size.width + p.dx * cycle;
      paint.color = _gold.withOpacity(opacity.clamp(0, 1));
      canvas.drawCircle(Offset(x, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.time != time;
}

// ── The main card ──────────────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final Animation<double> blinkAnim;
  final TextEditingController emailController;
  final TextEditingController adminIdController;
  final bool submitting;
  final VoidCallback onLogin;
  final VoidCallback onBack;

  const _Card({
    required this.blinkAnim,
    required this.emailController,
    required this.adminIdController,
    required this.submitting,
    required this.onLogin,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 420,
      padding: const EdgeInsets.fromLTRB(44, 52, 44, 44),
      decoration: BoxDecoration(
        color: _bgPanel,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF5C518).withOpacity(0.06),
            blurRadius: 0,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: const Color(0xFFF5C518).withOpacity(0.08),
            blurRadius: 60,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius: 80,
            offset: const Offset(0, 40),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // corner brackets
          _corner(top: -1, left: -1, topBorder: true, leftBorder: true),
          _corner(top: -1, right: -1, topBorder: true, rightBorder: true),
          _corner(bottom: -1, right: -1, bottomBorder: true, rightBorder: true),
          _corner(bottom: -1, left: -1, bottomBorder: true, leftBorder: true),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ────────────────────────────────────────────────────
              Column(
                children: [
                  // badge with blinking dot
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: _border),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeTransition(
                          opacity: blinkAnim,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _gold,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: _gold, blurRadius: 6, spreadRadius: 1)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SECURE ACCESS',
                          style: GoogleFonts.orbitron(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 4,
                            color: _gold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.orbitron(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: Colors.white,
                        height: 1.1,
                      ),
                      children: [
                        const TextSpan(text: 'ADMIN '),
                        TextSpan(
                          text: 'PORTAL',
                          style: GoogleFonts.orbitron(color: _gold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AUTHORIZED PERSONNEL ONLY',
                    style: GoogleFonts.rajdhani(
                      fontSize: 12,
                      letterSpacing: 3,
                      color: _textDim,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // ── Email field ────────────────────────────────────────────────
              _AdminField(
                label: 'EMAIL ADDRESS',
                icon: Icons.email_outlined,
                controller: emailController,
                hint: 'admin@domain.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // ── Admin ID field ─────────────────────────────────────────────
              _AdminField(
                label: 'ADMIN ID',
                icon: Icons.lock_outlined,
                controller: adminIdController,
                hint: 'ADM-XXXXXXXX',
              ),
              const SizedBox(height: 28),

              // ── Divider ────────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, _border],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'AUTHENTICATE',
                      style: GoogleFonts.orbitron(
                        fontSize: 9,
                        letterSpacing: 3,
                        color: _textDim,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_border, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Login button ───────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: submitting ? null : onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: const Color(0xFF0A0800),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2)),
                    elevation: 0,
                  ),
                  child: submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Color(0xFF0A0800)),
                        )
                      : Text(
                          '⚡  LOGIN TO DASHBOARD',
                          style: GoogleFonts.orbitron(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 4,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),

              // ── Back button ────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _border),
                    foregroundColor: _textDim,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2)),
                  ),
                  child: Text(
                    '← RETURN TO HOME',
                    style: GoogleFonts.orbitron(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ── Footer ────────────────────────────────────────────────────
              Text(
                '256-BIT ENCRYPTED  ·  SESSION MONITORED',
                style: GoogleFonts.orbitron(
                  fontSize: 9,
                  letterSpacing: 2,
                  color: _textDim.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // helper: corner bracket
  Widget _corner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    bool topBorder = false,
    bool bottomBorder = false,
    bool leftBorder = false,
    bool rightBorder = false,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          border: Border(
            top:    topBorder    ? const BorderSide(color: _gold, width: 2) : BorderSide.none,
            bottom: bottomBorder ? const BorderSide(color: _gold, width: 2) : BorderSide.none,
            left:   leftBorder   ? const BorderSide(color: _gold, width: 2) : BorderSide.none,
            right:  rightBorder  ? const BorderSide(color: _gold, width: 2) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// ── Reusable admin field ───────────────────────────────────────────────────────
class _AdminField extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  const _AdminField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.hint,
    this.keyboardType,
  });

  @override
  State<_AdminField> createState() => _AdminFieldState();
}

class _AdminFieldState extends State<_AdminField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.orbitron(
            fontSize: 10,
            letterSpacing: 3,
            color: _textDim,
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (f) => setState(() => _focused = f),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            style: GoogleFonts.rajdhani(
              color: _textCol,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: GoogleFonts.rajdhani(color: _textDim, fontWeight: FontWeight.w400),
              prefixIcon: Icon(
                widget.icon,
                color: _focused ? _gold : _textDim,
                size: 18,
              ),
              filled: true,
              fillColor: _focused
                  ? const Color(0xFFF5C518).withOpacity(0.04)
                  : Colors.white.withOpacity(0.03),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: const BorderSide(
                    color: Color(0x26F5C518), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: const BorderSide(
                    color: Color(0x26F5C518), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: const BorderSide(color: _gold, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}