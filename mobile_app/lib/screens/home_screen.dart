// home_screen.dart
// Flutter port of index.html — EcoWaste landing page
// Dark theme with #c8f53a lime-green accent color
// Sections: Nav, Hero, Stats, Features, How It Works, Footer
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'admin_login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _bg = Color(0xFF0D110A);
  static const _cardBg = Color(0xFF1A2115);
  static const _lime = Color(0xFFC8F53A);
  static const _gold = Color(0xFFF5C842);
  static const _navBg = Color(0xFF111111);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          // ── Sticky Nav ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            color: _navBg,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 20,
              runSpacing: 10,
              children: [
                Text(
                  'EcoWaste',
                  style: GoogleFonts.syne(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: _lime,
                  ),
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _NavButton(
                      label: 'Login',
                      bgColor: _gold,
                      textColor: Colors.black,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _NavButton(
                      label: 'Register',
                      bgColor: _lime,
                      textColor: Colors.black,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _NavButton(
                      label: 'Admin',
                      bgColor: Colors.transparent,
                      textColor: _gold,
                      borderColor: _gold,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AdminLoginScreen()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Scrollable content ──────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ── Hero Section ──────────────────────────────────────
                  const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Smarter Waste,',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.syne(
                        color: Colors.white,
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Greener City.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.syne(
                        color: _lime,
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Transforming urban waste management through real-time tracking, smart scheduling and sustainability.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        color: Colors.grey,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _lime,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RegisterScreen()),
                    ),
                    child: Text('Get Started',
                        style: GoogleFonts.dmSans(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 60),

                  // ── Stats ─────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LayoutBuilder(
                      builder: (_, c) {
                        final cols = c.maxWidth > 600 ? 4 : 2;
                        return GridView.count(
                          crossAxisCount: cols,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: cols == 2 ? 1.4 : 1.8,
                          children: const [
                            _StatCard(value: '85%', label: 'Recycling Rate'),
                            _StatCard(value: '120+', label: 'Cities'),
                            _StatCard(value: '2.4M', label: 'Tons Diverted'),
                            _StatCard(value: '40%', label: 'Fuel Saved'),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50),

                  // ── Features Header ────────────────────────────────────
                  Text('Our Features',
                      style: GoogleFonts.syne(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LayoutBuilder(
                      builder: (_, c) {
                        final cols = c.maxWidth > 600 ? 3 : 2;
                        return GridView.count(
                          crossAxisCount: cols,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.15,
                          children: const [
                            _FeatureCard(
                                icon: Icons.route_rounded,
                                title: 'Smart Routing',
                                subtitle: 'Optimized collection routes'),
                            _FeatureCard(
                                icon: Icons.location_on_rounded,
                                title: 'Live Tracking',
                                subtitle: 'Track pickups in real time'),
                            _FeatureCard(
                                icon: Icons.eco_rounded,
                                title: 'Eco Dashboard',
                                subtitle: 'Monitor sustainability'),
                            _FeatureCard(
                                icon: Icons.analytics_rounded,
                                title: 'Analytics',
                                subtitle: 'Predict waste generation'),
                            _FeatureCard(
                                icon: Icons.notifications_rounded,
                                title: 'Smart Alerts',
                                subtitle: 'Automatic notifications'),
                            _FeatureCard(
                                icon: Icons.location_city_rounded,
                                title: 'Multi City',
                                subtitle: 'Manage multiple municipalities'),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50),

                  // ── How It Works ──────────────────────────────────────
                  Text('How It Works',
                      style: GoogleFonts.syne(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LayoutBuilder(
                      builder: (_, c) {
                        final cols = c.maxWidth > 600 ? 3 : 1;
                        return GridView.count(
                          crossAxisCount: cols,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: cols == 1 ? 2.5 : 1.4,
                          children: const [
                            _StepCard(
                              number: '1',
                              title: 'Register',
                              desc:
                                  'Create your account and add your area.',
                            ),
                            _StepCard(
                              number: '2',
                              title: 'Schedule',
                              desc:
                                  'AI generates optimized collection routes.',
                            ),
                            _StepCard(
                              number: '3',
                              title: 'Track',
                              desc: 'Monitor pickups and reports.',
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50),

                  // ── Footer ────────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    color: _navBg,
                    child: Column(
                      children: [
                        Text('EcoWaste Systems',
                            style: GoogleFonts.syne(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text(
                          '© 2026 EcoWaste Smart Systems',
                          style: GoogleFonts.dmSans(
                              color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Nav button ────────────────────────────────────────────────────────────────
class _NavButton extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1)
              : null,
        ),
        child: Text(label,
            style: GoogleFonts.dmSans(
                color: textColor, fontWeight: FontWeight.w600, fontSize: 14)),
      ),
    );
  }
}

// ── Stat card ─────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: HomeScreen._cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: Text(value,
                style: GoogleFonts.syne(
                    color: HomeScreen._lime,
                    fontSize: 32,
                    fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: GoogleFonts.dmSans(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }
}

// ── Feature card ──────────────────────────────────────────────────────────────
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _FeatureCard(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HomeScreen._cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: HomeScreen._lime, size: 40),
          const SizedBox(height: 14),
          Text(title,
              textAlign: TextAlign.center,
              style: GoogleFonts.syne(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }
}

// ── Step card ─────────────────────────────────────────────────────────────────
class _StepCard extends StatelessWidget {
  final String number;
  final String title;
  final String desc;
  const _StepCard(
      {required this.number, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: HomeScreen._cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: HomeScreen._lime.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(number,
                  style: GoogleFonts.syne(
                      color: HomeScreen._lime,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
            ),
          ),
          const SizedBox(height: 12),
          Text('$number. $title',
              style: GoogleFonts.syne(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(desc,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }
}