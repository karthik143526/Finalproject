// login_screen.dart
//
// EcoWaste - Login Screen
// Flutter port of login.html — same colors, typography, stripe accents,
// card layout and behavior (password show/hide, split hero panel on wide
// screens, single-column form on mobile).
//
// Dependencies (add to pubspec.yaml):
//   google_fonts: ^6.2.1
//
// Fonts used (loaded via google_fonts, matching the HTML's Google Fonts):
//   - Fraunces  -> headings ("Welcome back", hero title, brand mark)
//   - Inter     -> body text, inputs, buttons, links
//
// Usage:
//   Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
import '../services/api_service.dart';
import 'dashboard_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const ink = Color(0xFF142019);
  static const inkSoft = Color(0xFF1C2A21);
  static const paper = Color(0xFFF3EFE4);
  static const paperCard = Color(0xFFFCFAF3);
  static const line = Color(0xFFE3DDCA);
  static const textDark = Color(0xFF1C241D);
  static const textMuted = Color(0xFF6F7566);
  static const textOnInk = Color(0xFFE9ECE2);
  static const textOnInkMuted = Color(0xFFAAB5A4);
  static const streamBlue = Color(0xFF3E6E8C);
  static const streamYellow = Color(0xFFE8A93F);
  static const streamGreen = Color(0xFF6E8F4E);
  static const streamBrown = Color(0xFF8B5E3C);
}

/// The four-color "sorting stripe" that appears throughout the design
/// (brand mark, card top edge, footnote).
class SortingStripe extends StatelessWidget {
  final double width;
  final double height;
  const SortingStripe({super.key, this.width = 120, this.height = 6});

  @override
  Widget build(BuildContext context) {
    const colors = [
      AppColors.streamBlue,
      AppColors.streamYellow,
      AppColors.streamGreen,
      AppColors.streamBrown,
    ];
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        width: width,
        height: height,
        child: Row(
          children: colors
              .map((c) => Expanded(child: Container(color: c)))
              .toList(),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePassword() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final response = await ApiService.login(email, password);
    if (!mounted) return;

    setState(() => _submitting = false);

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['message'] ?? 'Login successful!'),
        backgroundColor: Colors.green,
      ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['message'] ?? 'Login failed.'),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;
            return Row(
              children: [
                if (isWide) const Expanded(child: _HeroPanel()),
                Expanded(
                  child: _FormPanel(
                    showBackButton: true,
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    obscurePassword: _obscurePassword,
                    onTogglePassword: _togglePassword,
                    onSubmit: _handleSignIn,
                    submitting: _submitting,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Left panel: background photo + gradient overlay + floating stat tags +
/// brand mark + hero headline. Mirrors `.left` in the HTML.
class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background photo
        Image.network(
          'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?fm=jpg&q=80&w=1600&auto=format&fit=crop',
          fit: BoxFit.cover,
          color: Colors.black.withOpacity(0.12), // approximate grayscale/darken
          colorBlendMode: BlendMode.darken,
        ),
        // Gradient overlay (top-to-bottom darkening, like the CSS linear-gradient)
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(14, 20, 15, 0.25),
                Color.fromRGBO(14, 20, 15, 0.55),
                Color.fromRGBO(10, 15, 11, 0.92),
              ],
              stops: [0.0, 0.45, 1.0],
            ),
          ),
        ),
        // Floating stat tags
        const Positioned(top: 90, left: 30, child: _StatTag(color: AppColors.streamBlue, label: 'Recycling', value: '85%')),
        const Positioned(top: 220, right: 34, child: _StatTag(color: AppColors.streamGreen, label: 'Fuel saved', value: '40%')),
        const Positioned(top: 340, left: 46, child: _StatTag(color: AppColors.streamYellow, label: 'Coverage', value: '120+ cities')),
        // Content column: brand at top, hero text at bottom
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 52),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Brand
              Row(
                children: [
                  const SortingStripe(width: 40, height: 6),
                  const SizedBox(width: 12),
                  Text(
                    'EcoWaste',
                    style: GoogleFonts.fraunces(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: AppColors.textOnInk,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              // Hero
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.fraunces(
                        fontWeight: FontWeight.w600,
                        fontSize: 40,
                        height: 1.12,
                        color: AppColors.textOnInk,
                        letterSpacing: -0.5,
                      ),
                      children: [
                        const TextSpan(text: 'Smarter pickups.\nCleaner streets,\n'),
                        TextSpan(
                          text: 'every time.',
                          style: TextStyle(color: AppColors.streamYellow),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 380,
                    child: Text(
                      "EcoWaste routes recycling, compost and waste collection so nothing ends up in the wrong place.",
                      style: GoogleFonts.inter(
                        color: AppColors.textOnInkMuted,
                        fontSize: 15,
                        height: 1.65,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const SortingStripe(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatTag extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  const _StatTag({required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(11, 9, 14, 9),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(20, 32, 25, 0.55),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 9),
          Text(
            label,
            style: GoogleFonts.inter(color: AppColors.textOnInk, fontSize: 13),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// Right panel: the login card with form fields, sign-in button, links and
/// footnote. Mirrors `.right` / `.box` in the HTML.
class _FormPanel extends StatelessWidget {
  final bool showBackButton;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;
  final bool submitting;

  const _FormPanel({
    required this.showBackButton,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onSubmit,
    required this.submitting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.paper,
      child: Stack(
        children: [
          if (showBackButton)
            Positioned(
              top: 20,
              left: 20,
              child: _BackButton(onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              )),
            ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Container(
                width: 380,
                decoration: BoxDecoration(
                  color: AppColors.paperCard,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.line),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textDark.withOpacity(0.04),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                    BoxShadow(
                      color: AppColors.textDark.withOpacity(0.22),
                      blurRadius: 45,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SortingStripe(width: double.infinity, height: 6),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(34, 36, 34, 38),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ECOWASTE',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Welcome back',
                              style: GoogleFonts.fraunces(
                                fontWeight: FontWeight.w600,
                                fontSize: 28,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Sign in to manage today's pickups.",
                              style: GoogleFonts.inter(
                                color: AppColors.textMuted,
                                fontSize: 14.5,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 26),

                            // Email field
                            _FieldLabel('Email address'),
                            const SizedBox(height: 6),
                            _StyledTextField(
                              controller: emailController,
                              hint: 'you@example.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Email is required';
                                if (!v.contains('@')) return 'Enter a valid email';
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),

                            // Password field
                            _FieldLabel('Password'),
                            const SizedBox(height: 6),
                            _StyledTextField(
                              controller: passwordController,
                              hint: '••••••••',
                              obscureText: obscurePassword,
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Password is required';
                                return null;
                              },
                              suffixIcon: GestureDetector(
                                onTap: onTogglePassword,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Icon(
                                    obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                    size: 19,
                                    color: AppColors.textDark.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Sign in button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: submitting ? null : onSubmit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.ink,
                                  foregroundColor: AppColors.paper,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  elevation: 0,
                                ).copyWith(
                                  overlayColor: WidgetStateProperty.all(AppColors.inkSoft),
                                ),
                                child: submitting
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.paper,
                                        ),
                                      )
                                    : Text(
                                        'Sign in',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.5,
                                          letterSpacing: 0.1,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Links row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _LinkText(
                                  text: 'Forgot password?',
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w500,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const ForgotPasswordScreen()),
                                    );
                                  },
                                ),
                                _LinkText(
                                  text: 'Create account',
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w600,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const RegisterScreen()),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 26),

                            // Footnote
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SortingStripe(width: 36, height: 4),
                                const SizedBox(width: 8),
                                Text(
                                  'Protecting streets in 120+ cities',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const _StyledTextField({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 14.5, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: const Color(0xFFB9B4A3)),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: AppColors.line, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: AppColors.line, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: AppColors.streamBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}

class _LinkText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final VoidCallback onTap;

  const _LinkText({
    required this.text,
    required this.color,
    required this.fontWeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 13.5,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.fromLTRB(11, 9, 14, 9),
        decoration: BoxDecoration(
          color: AppColors.paperCard,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.line),
          boxShadow: [
            BoxShadow(
              color: AppColors.textDark.withOpacity(0.18),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_back, size: 14, color: AppColors.textDark),
            const SizedBox(width: 7),
            Text(
              'Back',
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
