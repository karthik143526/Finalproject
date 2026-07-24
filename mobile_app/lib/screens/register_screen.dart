// register_screen.dart
//
// EcoWaste – Register Screen
// Flutter port of register.html — same dark green glassmorphism design:
// • Animated green orb background
// • Green grid overlay
// • Glassmorphism form card with top green bar
// • Name, Email, Password (with strength bar), Confirm Password
//   → NO phone number field (matching the website)
// • "Create My Account →" button + divider + "Go Back Home" back button
// • "Already have an account? Sign in" link
// • Left panel with brand, headline, stats (hidden on mobile)
// • Right panel with eco image + feature list (hidden on mobile)
//
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';

// ── Colour tokens ──────────────────────────────────────────────────────────────
const _dark        = Color(0xFF060E0A);
const _dark2       = Color(0xFF0D1A12);
const _green       = Color(0xFF00FF99);
const _greenGlow   = Color(0x2E00FF99);
const _glass       = Color(0x0FFFFFFF);
const _glassBorder = Color(0x21FFFFFF);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  // ── controllers ─────────────────────────────────────────────────────────────
  final _nameController            = TextEditingController();
  final _emailController           = TextEditingController();
  final _passwordController        = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hidePassword        = true;
  bool _hideConfirm         = true;
  bool _submitting          = false;
  double _passwordStrength  = 0;

  // orb animation
  late AnimationController _orbCtrl;

  @override
  void initState() {
    super.initState();
    _orbCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
    _passwordController.addListener(_checkStrength);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _orbCtrl.dispose();
    super.dispose();
  }

  void _checkStrength() {
    final v = _passwordController.text;
    double s = 0;
    if (v.length >= 8) s += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(v)) s += 0.25;
    if (RegExp(r'[0-9]').hasMatch(v)) s += 0.25;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(v)) s += 0.25;
    setState(() => _passwordStrength = s);
  }

  Color get _strengthColor {
    if (_passwordStrength <= 0.25) return Colors.red;
    if (_passwordStrength <= 0.50) return Colors.orange;
    if (_passwordStrength <= 0.75) return Colors.yellow;
    return _green;
  }

  String get _strengthLabel {
    if (_passwordStrength <= 0.25) return 'Weak';
    if (_passwordStrength <= 0.50) return 'Medium';
    if (_passwordStrength <= 0.75) return 'Strong';
    return 'Very Strong';
  }

  Future<void> _handleRegister() async {
    final name            = _nameController.text.trim();
    final email           = _emailController.text.trim();
    final password        = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _snack('Please fill in all fields.', Colors.redAccent);
      return;
    }
    if (password != confirmPassword) {
      _snack('Passwords do not match.', Colors.redAccent);
      return;
    }
    if (_passwordStrength < 0.5) {
      _snack(
        'Please choose a stronger password (min 8 chars, uppercase & number).',
        Colors.redAccent,
      );
      return;
    }

    setState(() => _submitting = true);
    final response = await ApiService.register(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    if (response['status'] == 'success') {
      _snack(response['message'] ?? 'Account created! Please log in.', _green,
          textColor: Colors.black);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else {
      _snack(response['message'] ?? 'Registration failed.', Colors.redAccent);
    }
  }

  void _snack(String msg, Color bg, {Color textColor = Colors.white}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: GoogleFonts.dmSans(color: textColor, fontWeight: FontWeight.w500)),
      backgroundColor: bg,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 960;

    return Scaffold(
      backgroundColor: _dark,
      body: Stack(
        children: [
          // animated orbs
          _AnimatedOrbs(controller: _orbCtrl),
          // grid
          _GridOverlay(),
          // content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 40 : 16,
                  vertical: 32,
                ),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: _LeftPanel()),
                          const SizedBox(width: 60),
                          SizedBox(width: 420, child: _FormCard(
                            nameController: _nameController,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            confirmPasswordController: _confirmPasswordController,
                            hidePassword: _hidePassword,
                            hideConfirm: _hideConfirm,
                            submitting: _submitting,
                            passwordStrength: _passwordStrength,
                            strengthColor: _strengthColor,
                            strengthLabel: _strengthLabel,
                            onRegister: _handleRegister,
                            onTogglePassword: () => setState(() => _hidePassword = !_hidePassword),
                            onToggleConfirm: () => setState(() => _hideConfirm = !_hideConfirm),
                          )),
                          const SizedBox(width: 60),
                          Expanded(child: _RightPanel()),
                        ],
                      )
                    : _FormCard(
                        nameController: _nameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        hidePassword: _hidePassword,
                        hideConfirm: _hideConfirm,
                        submitting: _submitting,
                        passwordStrength: _passwordStrength,
                        strengthColor: _strengthColor,
                        strengthLabel: _strengthLabel,
                        onRegister: _handleRegister,
                        onTogglePassword: () => setState(() => _hidePassword = !_hidePassword),
                        onToggleConfirm: () => setState(() => _hideConfirm = !_hideConfirm),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animated orbs ─────────────────────────────────────────────────────────────
class _AnimatedOrbs extends StatelessWidget {
  final AnimationController controller;
  const _AnimatedOrbs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;
        return Stack(
          children: [
            Positioned(
              top: -100 + t * 40,
              left: -120 + t * 20,
              child: _orb(420, _green.withOpacity(0.07)),
            ),
            Positioned(
              bottom: -80 + t * 30,
              right: -80 + (1 - t) * 40,
              child: _orb(300, const Color(0xFF00C864).withOpacity(0.08)),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4 + t * 20,
              left: MediaQuery.of(context).size.width * 0.6 + (1 - t) * 20,
              child: _orb(200, _green.withOpacity(0.06)),
            ),
          ],
        );
      },
    );
  }

  Widget _orb(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      );
}

// ── Grid overlay ──────────────────────────────────────────────────────────────
class _GridOverlay extends StatelessWidget {
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
      ..color = const Color(0xFF00FF99).withOpacity(0.04)
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
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ── Left panel ────────────────────────────────────────────────────────────────
class _LeftPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _greenGlow,
                border: Border.all(color: _green.withOpacity(0.35), width: 1.5),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: _green.withOpacity(0.15), blurRadius: 20)
                ],
              ),
              child: const Center(child: Text('🌿', style: TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),
            Text(
              'EcoWaste',
              style: GoogleFonts.syne(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: _green,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        RichText(
          text: TextSpan(
            style: GoogleFonts.syne(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -1.5,
              height: 1.08,
            ),
            children: [
              const TextSpan(text: 'Waste Less.\n'),
              TextSpan(
                text: 'Live ',
                style: GoogleFonts.syne(color: _green),
              ),
              const TextSpan(text: 'More.'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Join thousands building a cleaner world\nthrough smart, real-time waste management.',
          style: GoogleFonts.dmSans(
            fontSize: 15,
            color: const Color(0xA6DCF0E6),
            height: 1.75,
          ),
        ),
        const SizedBox(height: 36),
        _statItem('🏙️', '120+ Cities', 'Active network'),
        const SizedBox(height: 14),
        _statItem('♻️', '2.4M Tonnes', 'Waste diverted'),
        const SizedBox(height: 14),
        _statItem('📡', 'Real-time Tracking', 'Always up to date'),
      ],
    );
  }

  Widget _statItem(String emoji, String strong, String sub) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _greenGlow,
            border: Border.all(color: _green.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 16))),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strong,
                style: GoogleFonts.syne(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                )),
            Text(sub,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: const Color(0x80B4DCC8),
                  letterSpacing: 0.8,
                )),
          ],
        ),
      ],
    );
  }
}

// ── Right panel ───────────────────────────────────────────────────────────────
class _RightPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // image card
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1509395176047-4a66953fd231?w=600&q=80',
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.multiply,
                color: Colors.black.withOpacity(0.15),
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: _dark2,
                  child: const Center(
                    child: Text('🌍', style: TextStyle(fontSize: 60)),
                  ),
                ),
              ),
              Positioned(
                bottom: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xBF060E0A),
                    border: Border.all(color: _green.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('🌍 Live Impact',
                          style: GoogleFonts.dmSans(
                              fontSize: 12, color: _green, fontWeight: FontWeight.w500)),
                      Text('Updated in real-time',
                          style: GoogleFonts.dmSans(
                              fontSize: 11, color: const Color(0x8CB4DCC8))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // feature list
        _featureItem('📍', 'GPS-powered bin tracking across your city'),
        const SizedBox(height: 10),
        _featureItem('📊', 'Personal eco-score & monthly reports'),
        const SizedBox(height: 10),
        _featureItem('🤝', 'Community challenges & green rewards'),
      ],
    );
  }

  Widget _featureItem(String icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _glass,
        border: Border.all(color: _glassBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: GoogleFonts.dmSans(
                    fontSize: 13.5,
                    color: const Color(0xBFC8EBD7))),
          ),
        ],
      ),
    );
  }
}

// ── Form card ─────────────────────────────────────────────────────────────────
class _FormCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool hidePassword;
  final bool hideConfirm;
  final bool submitting;
  final double passwordStrength;
  final Color strengthColor;
  final String strengthLabel;
  final VoidCallback onRegister;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirm;

  const _FormCard({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.hidePassword,
    required this.hideConfirm,
    required this.submitting,
    required this.passwordStrength,
    required this.strengthColor,
    required this.strengthLabel,
    required this.onRegister,
    required this.onTogglePassword,
    required this.onToggleConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.055),
        border: Border.all(color: _glassBorder),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: _green.withOpacity(0.08),
              blurRadius: 0,
              spreadRadius: 0.5),
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 40,
              offset: const Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // top green glow bar
            Positioned(
              top: 0,
              left: 60,
              right: 60,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, _green, Colors.transparent],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 44, 36, 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // header
                  Text('Create Account',
                      style: GoogleFonts.syne(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: Colors.white)),
                  const SizedBox(height: 6),
                  Text('Start your eco journey today',
                      style: GoogleFonts.dmSans(
                          fontSize: 13, color: const Color(0x80B4DCC8))),
                  const SizedBox(height: 30),

                  // Full Name
                  _RegisterField(
                    controller: nameController,
                    hint: 'Full Name',
                    icon: '👤',
                  ),
                  const SizedBox(height: 14),

                  // Email
                  _RegisterField(
                    controller: emailController,
                    hint: 'Email Address',
                    icon: '✉️',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),

                  // Password
                  _RegisterField(
                    controller: passwordController,
                    hint: 'Password',
                    icon: '🔒',
                    obscure: hidePassword,
                    showEye: true,
                    onToggleEye: onTogglePassword,
                  ),
                  // strength bar
                  if (passwordController.text.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: passwordStrength,
                        minHeight: 3,
                        backgroundColor: Colors.white.withOpacity(0.08),
                        valueColor: AlwaysStoppedAnimation(strengthColor),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(strengthLabel,
                          style: GoogleFonts.dmSans(
                              fontSize: 11,
                              color: const Color(0x73B4DCC8))),
                    ),
                  ],
                  const SizedBox(height: 14),

                  // Confirm Password
                  _RegisterField(
                    controller: confirmPasswordController,
                    hint: 'Confirm Password',
                    icon: '🔑',
                    obscure: hideConfirm,
                    showEye: true,
                    onToggleEye: onToggleConfirm,
                  ),
                  const SizedBox(height: 6),

                  // Create Account button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: submitting ? null : onRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _green,
                        foregroundColor: _dark,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ).copyWith(
                        overlayColor: WidgetStateProperty.all(
                            Colors.white.withOpacity(0.15)),
                      ),
                      child: submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: _dark))
                          : Text('Create My Account →',
                              style: GoogleFonts.syne(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                                color: _dark,
                              )),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // divider
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              height: 1,
                              color: Colors.white.withOpacity(0.07))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('or',
                            style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: const Color(0x40B4DCC8))),
                      ),
                      Expanded(
                          child: Container(
                              height: 1,
                              color: Colors.white.withOpacity(0.07))),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Go back button
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0x17FFFFFF), width: 1),
                        foregroundColor: const Color(0x8CB4DCC8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('← Go Back Home',
                          style: GoogleFonts.dmSans(fontSize: 14)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // already have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? ',
                          style: GoogleFonts.dmSans(
                              fontSize: 13.5,
                              color: const Color(0x73B4DCC8))),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        ),
                        child: Text('Sign in',
                            style: GoogleFonts.dmSans(
                                fontSize: 13.5,
                                color: _green,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable input field ───────────────────────────────────────────────────────
class _RegisterField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String icon;
  final bool obscure;
  final bool showEye;
  final VoidCallback? onToggleEye;
  final TextInputType? keyboardType;

  const _RegisterField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.showEye = false,
    this.onToggleEye,
    this.keyboardType,
  });

  @override
  State<_RegisterField> createState() => _RegisterFieldState();
}

class _RegisterFieldState extends State<_RegisterField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscure,
        keyboardType: widget.keyboardType,
        style: GoogleFonts.dmSans(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: GoogleFonts.dmSans(
              color: const Color(0x59B4DCC8), fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Text(widget.icon,
                style: TextStyle(
                    fontSize: 16, color: _focused ? Colors.white : null)),
          ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: widget.showEye
              ? GestureDetector(
                  onTap: widget.onToggleEye,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      widget.obscure ? '👁️' : '🙈',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
              : null,
          filled: true,
          fillColor: _focused
              ? _green.withOpacity(0.06)
              : Colors.white.withOpacity(0.06),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0x1AFFFFFF), width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0x1AFFFFFF), width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Color(0x73009966), width: 1)),
        ),
      ),
    );
  }
}