// eco_theme.dart
//
// Shared palette for the EcoWaste "neon" screens (dashboard, timings,
// request pickup, feedback). Import this instead of redeclaring the same
// color constants in every screen — avoids duplicate top-level identifier
// errors when multiple screens are imported into the same file.

import 'package:flutter/material.dart';

const Color kNeon = Color(0xFF00FFB2);
const Color kNeon2 = Color(0xFF00E5FF);
const Color kNeon3 = Color(0xFFB3FF00);
const Color kDark = Color(0xFF050D0A);
const Color kDark2 = Color(0xFF0A1A12);
final Color kCardBg = kNeon.withOpacity(0.04);
final Color kBorder = kNeon.withOpacity(0.15);
const Color kText = Color(0xFFC8FFE8);
const Color kMuted = Color(0x66C8FFE8);
const Color kRed = Color(0xFFFF6B6B);

/// Reusable "glass" card decoration used throughout the neon screens.
BoxDecoration ecoCardDecoration({Color? accent, double radius = 18}) {
  return BoxDecoration(
    color: kCardBg,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: kBorder),
    boxShadow: accent != null
        ? [BoxShadow(color: accent.withOpacity(0.12), blurRadius: 20)]
        : null,
  );
}

/// Reusable top logo mark (🌱) used on every screen's app bar.
class EcoLogoMark extends StatelessWidget {
  final double size;
  const EcoLogoMark({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kNeon, kNeon2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [BoxShadow(color: kNeon.withOpacity(0.4), blurRadius: 16)],
      ),
      alignment: Alignment.center,
      child: Text('🌱', style: TextStyle(fontSize: size * 0.48)),
    );
  }
}

/// Standard app bar used by the module screens (timings/request/feedback),
/// keeping the same dark translucent bar + brand mark + back arrow as the
/// dashboard.
PreferredSizeWidget ecoAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: kDark.withOpacity(0.9),
    elevation: 0,
    titleSpacing: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: kText),
      onPressed: () => Navigator.maybePop(context),
    ),
    title: Row(
      children: [
        const EcoLogoMark(size: 28),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: kNeon,
          ),
        ),
      ],
    ),
  );
}

/// Ambient background blobs used behind every neon screen's body.
Widget ecoBlob(double size, Color color) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );

/// Shared input decoration for text fields on the neon screens.
InputDecoration ecoInputDecoration({required String label, String? hint, Widget? suffixIcon}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: TextStyle(color: kMuted, fontSize: 13),
    hintStyle: TextStyle(color: kMuted.withOpacity(0.7), fontSize: 13),
    filled: true,
    fillColor: Colors.white.withOpacity(0.03),
    suffixIcon: suffixIcon,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: kBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: kBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kNeon, width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kRed),
    ),
  );
}

/// Shared gradient submit button used on the neon screens.
class EcoPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  const EcoPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          backgroundColor: kNeon,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [kNeon, kNeon2]),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: kDark),
                  )
                : Text(
                    label,
                    style: const TextStyle(
                      color: kDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}