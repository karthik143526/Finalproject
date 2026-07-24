// forgot_password_screen.dart
//
// EcoWaste – Forgot Password Screen
// Two-step flow matching forgot_password.html + forgot_password.php:
//   Step 1 → enter email, verify it exists in the database
//   Step 2 → enter new password + confirm, then reset via API
//
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

// ─── colour tokens (same as LoginScreen) ───────────────────────────────────
const _ink        = Color(0xFF142019);
const _paper      = Color(0xFFF3EFE4);
const _paperCard  = Color(0xFFFCFAF3);
const _line       = Color(0xFFE3DDCA);
const _textDark   = Color(0xFF1C241D);
const _textMuted  = Color(0xFF6F7566);
const _streamBlue = Color(0xFF3E6E8C);
const _streamYellow = Color(0xFFE8A93F);
const _streamGreen  = Color(0xFF6E8F4E);
const _streamBrown  = Color(0xFF8B5E3C);

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  // step 1 – verify email
  final _emailController = TextEditingController();
  // step 2 – reset password
  final _newPasswordController    = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  bool _loading        = false;
  bool _step2          = false;   // true once email is verified
  bool _hideNew        = true;
  bool _hideConfirm    = true;
  bool _done           = false;   // true once password reset succeeds
  String _verifiedEmail = '';

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── Step 1: verify email ─────────────────────────────────────────────────
  Future<void> _verifyEmail() async {
    if (!_step1Key.currentState!.validate()) return;
    setState(() => _loading = true);

    final result = await ApiService.forgotPasswordVerify(
        _emailController.text.trim());

    if (!mounted) return;
    setState(() => _loading = false);

    if (result['status'] == 'success') {
      setState(() {
        _verifiedEmail = _emailController.text.trim();
        _step2 = true;
      });
    } else {
      _showError(result['message'] ?? 'Email not found.');
    }
  }

  // ── Step 2: reset password ───────────────────────────────────────────────
  Future<void> _resetPassword() async {
    if (!_step2Key.currentState!.validate()) return;
    setState(() => _loading = true);

    final result = await ApiService.forgotPasswordReset(
      email: _verifiedEmail,
      newPassword: _newPasswordController.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (result['status'] == 'success') {
      setState(() => _done = true);
    } else {
      _showError(result['message'] ?? 'Could not reset password.');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.inter()),
      backgroundColor: Colors.redAccent,
    ));
  }

  // ── UI ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _paper,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                // ── card ───────────────────────────────────────────────────
                Container(
                  width: 380,
                  decoration: BoxDecoration(
                    color: _paperCard,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _line),
                    boxShadow: [
                      BoxShadow(
                        color: _textDark.withOpacity(0.04),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                      BoxShadow(
                        color: _textDark.withOpacity(0.22),
                        blurRadius: 45,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // sorting stripe
                      SizedBox(
                        height: 6,
                        child: Row(
                          children: [
                            _stripe(_streamBlue),
                            _stripe(_streamYellow),
                            _stripe(_streamGreen),
                            _stripe(_streamBrown),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(34, 36, 34, 38),
                        child: _done
                            ? _SuccessView(
                                onLogin: () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const LoginScreen()),
                                  (r) => false,
                                ),
                              )
                            : _step2
                                ? _ResetPasswordForm(
                                    formKey: _step2Key,
                                    newPasswordController: _newPasswordController,
                                    confirmPasswordController:
                                        _confirmPasswordController,
                                    hideNew: _hideNew,
                                    hideConfirm: _hideConfirm,
                                    loading: _loading,
                                    email: _verifiedEmail,
                                    onToggleNew: () =>
                                        setState(() => _hideNew = !_hideNew),
                                    onToggleConfirm: () => setState(
                                        () => _hideConfirm = !_hideConfirm),
                                    onSubmit: _resetPassword,
                                    onBack: () =>
                                        setState(() => _step2 = false),
                                  )
                                : _VerifyEmailForm(
                                    formKey: _step1Key,
                                    emailController: _emailController,
                                    loading: _loading,
                                    onSubmit: _verifyEmail,
                                    onBack: () => Navigator.maybePop(context),
                                  ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stripe(Color c) =>
      Expanded(child: Container(color: c));
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 1 widget – verify email
// ─────────────────────────────────────────────────────────────────────────────
class _VerifyEmailForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final bool loading;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  const _VerifyEmailForm({
    required this.formKey,
    required this.emailController,
    required this.loading,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // eyebrow
          Text(
            'ECOWASTE',
            style: GoogleFonts.inter(
              fontSize: 12,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
              color: _textMuted,
            ),
          ),
          const SizedBox(height: 6),
          // heading
          Text(
            'Forgot password?',
            style: GoogleFonts.fraunces(
              fontWeight: FontWeight.w600,
              fontSize: 26,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your account email address and we\'ll verify it so you can reset your password.',
            style: GoogleFonts.inter(
              color: _textMuted,
              fontSize: 14,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 26),

          // email label
          Text(
            'Email address',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 6),

          // email field
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.inter(fontSize: 14.5, color: _textDark),
            decoration: InputDecoration(
              hintText: 'you@example.com',
              hintStyle: GoogleFonts.inter(color: const Color(0xFFB9B4A3)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: _line, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: _line, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: _streamBlue, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide:
                    const BorderSide(color: Colors.redAccent, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide:
                    const BorderSide(color: Colors.redAccent, width: 1.5),
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Continue button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _ink,
                foregroundColor: _paper,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)),
                elevation: 0,
              ),
              child: loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: _paper),
                    )
                  : Text(
                      'Continue →',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 14),

          // Back to login
          Center(
            child: GestureDetector(
              onTap: onBack,
              child: Text(
                '← Back to Login',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: _textMuted,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 2 widget – reset password
// ─────────────────────────────────────────────────────────────────────────────
class _ResetPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool hideNew;
  final bool hideConfirm;
  final bool loading;
  final String email;
  final VoidCallback onToggleNew;
  final VoidCallback onToggleConfirm;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  const _ResetPasswordForm({
    required this.formKey,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.hideNew,
    required this.hideConfirm,
    required this.loading,
    required this.email,
    required this.onToggleNew,
    required this.onToggleConfirm,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
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
              color: _textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Reset password',
            style: GoogleFonts.fraunces(
              fontWeight: FontWeight.w600,
              fontSize: 26,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set a new password for $email',
            style: GoogleFonts.inter(
              color: _textMuted,
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 26),

          // New password
          _label('New password'),
          const SizedBox(height: 6),
          _passwordField(
            controller: newPasswordController,
            hint: '••••••••',
            obscure: hideNew,
            onToggle: onToggleNew,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 8) {
                return 'Must be at least 8 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),

          // Confirm password
          _label('Confirm password'),
          const SizedBox(height: 6),
          _passwordField(
            controller: confirmPasswordController,
            hint: '••••••••',
            obscure: hideConfirm,
            onToggle: onToggleConfirm,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please confirm your password';
              if (v != newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),

          // Password rules hint
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _streamBlue.withOpacity(0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _streamBlue.withOpacity(0.18)),
            ),
            child: Text(
              'Password must contain:\n'
              '✔ At least 8 characters\n'
              '✔ Upper and lowercase letters\n'
              '✔ At least one number',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: _textMuted,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Update Password button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _ink,
                foregroundColor: _paper,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)),
                elevation: 0,
              ),
              child: loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: _paper),
                    )
                  : Text(
                      'Update Password',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: GestureDetector(
              onTap: onBack,
              child: Text(
                '← Back',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: _textMuted,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: _textDark,
        ),
      );

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.inter(fontSize: 14.5, color: _textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: const Color(0xFFB9B4A3)),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        suffixIcon: GestureDetector(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 19,
              color: _textDark.withOpacity(0.7),
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: _line, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: _line, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: _streamBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Success view – shown after password is reset
// ─────────────────────────────────────────────────────────────────────────────
class _SuccessView extends StatelessWidget {
  final VoidCallback onLogin;
  const _SuccessView({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        const Icon(Icons.check_circle_rounded,
            size: 64, color: _streamGreen),
        const SizedBox(height: 20),
        Text(
          'Password Updated!',
          style: GoogleFonts.fraunces(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: _textDark,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Your password has been updated successfully.\nYou can now sign in with your new password.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: _textMuted,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: _ink,
              foregroundColor: _paper,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
              elevation: 0,
            ),
            child: Text(
              'Login Now 🔐',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
