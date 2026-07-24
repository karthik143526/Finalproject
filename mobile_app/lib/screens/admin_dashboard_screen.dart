import 'package:flutter/material.dart';

import 'admin_login_screen.dart';
import 'admin_complaint_list_screen.dart';
import 'admin_feedback_list_screen.dart';
import 'admin_request_list_screen.dart';
import 'complaint_screen.dart'; // ComplaintScreen — admin list of submitted complaints
import 'feedback_screen.dart';  // FeedbackScreen — admin list of submitted feedback
import 'request_screen.dart';  // RequestScreen — admin list of submitted pickup requests

/// Admin Dashboard Screen — converted from admin_dashboard.html
///
/// Layout:
///   - Desktop (width > 768): fixed sidebar on the right + scrollable main content
///   - Mobile  (width <= 768): sidebar becomes an end Drawer, top AppBar shown
///
/// Tapping "View Status" / "Complaints" / "Feedback" (or their matching
/// stat cards) navigates straight to the admin list screens showing
/// data users have ALREADY submitted — not to the public submission forms.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  // ---- Theme colors (from :root CSS vars in admin_dashboard.html) ----
  static const bg = Color(0xFF040C08);
  static const neon = Color(0xFF00FFB2);
  static const orange = Color(0xFFFF7C2A);
  static const green = Color(0xFF5CFF8A);
  static const blue = Color(0xFF00D4FF);
  static const card = Color(0x0AFFFFFF); // rgba(255,255,255,0.03)
  static const borderColor = Color(0x1F00FFB2); // rgba(0,255,178,0.12)
  static const text = Color(0xFFD4F5E5);
  static const muted = Color(0x66D4F5E5); // rgba(212,245,229,0.4)

  static const double sidebarWidth = 290;
  static const double mobileBreakpoint = 768;

  void _navigate(BuildContext context, String key) {
    switch (key) {
      case 'status':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminRequestListScreen()));
        break;
      case 'complaints':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminComplaintListScreen()));
        break;
      case 'feedback':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminFeedbackListScreen()));
        break;
    }
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth <= mobileBreakpoint;

        return Scaffold(
          backgroundColor: bg,
          appBar: isMobile
              ? AppBar(
                  backgroundColor: bg.withOpacity(0.92),
                  elevation: 0,
                  title: Row(
                    children: [
                      _AdminAvatar(),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Administrator',
                              style: TextStyle(fontSize: 13, color: Colors.white)),
                          Text('● Super Admin',
                              style: TextStyle(fontSize: 10, color: neon)),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    const _LiveChip(),
                    IconButton(
                      icon: const Icon(Icons.logout, color: orange),
                      tooltip: 'Logout',
                      onPressed: () => _logout(context),
                    ),
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: neon),
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                      ),
                    ),
                  ],
                )
              : null,
          endDrawer: isMobile
              ? Drawer(
                  backgroundColor: const Color(0xF2040C08),
                  width: MediaQuery.of(context).size.width * 0.82,
                  child: _Sidebar(onTap: (k) => _navigate(context, k)),
                )
              : null,
          body: Stack(
            children: [
              const _AmbientBackground(),
              Row(
                children: [
                  Expanded(
                    child: _MainContent(
                      isMobile: isMobile,
                      onNavigate: (k) => _navigate(context, k),
                      onLogout: () => _logout(context),
                    ),
                  ),
                  if (!isMobile)
                    SizedBox(
                      width: sidebarWidth,
                      child: _Sidebar(onTap: (k) => _navigate(context, k)),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────── Ambient background ───────────────────────────

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -80,
            child: _blob(480, const Color(0x2100FFB2)),
          ),
          Positioned(
            bottom: -80,
            left: 200,
            child: _blob(380, const Color(0x1AFF7C2A)),
          ),
          Positioned(
            top: 200,
            right: 320,
            child: _blob(300, const Color(0x1A00D4FF)),
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
        boxShadow: [BoxShadow(color: color, blurRadius: 90, spreadRadius: 30)],
      ),
    );
  }
}

// ─────────────────────────── Live chip ───────────────────────────

class _LiveChip extends StatelessWidget {
  const _LiveChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AdminDashboardScreen.orange.withOpacity(0.1),
        border: Border.all(color: AdminDashboardScreen.orange.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AdminDashboardScreen.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'LIVE',
            style: TextStyle(
              color: AdminDashboardScreen.orange,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Admin avatar ───────────────────────────

class _AdminAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AdminDashboardScreen.neon, AdminDashboardScreen.blue],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AdminDashboardScreen.neon.withOpacity(0.3),
            blurRadius: 20,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Text('👨‍💼', style: TextStyle(fontSize: 18)),
    );
  }
}

// ─────────────────────────── Sidebar ───────────────────────────

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.onTap});

  final void Function(String routeKey) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 32),
      decoration: const BoxDecoration(
        color: Color(0xE6040C08),
        border: Border(
          left: BorderSide(color: AdminDashboardScreen.borderColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Admin badge
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AdminDashboardScreen.neon.withOpacity(0.06),
              border: Border.all(color: AdminDashboardScreen.borderColor),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _AdminAvatar(),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Administrator',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '● Super Admin Access',
                        style: TextStyle(
                          fontSize: 11,
                          color: AdminDashboardScreen.neon,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'MANAGEMENT',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.5,
                color: AdminDashboardScreen.muted,
              ),
            ),
          ),
          const SizedBox(height: 10),

          _SidebarButton(
            icon: '📊',
            label: 'View Status',
            sub: 'Live system overview',
            count: '148',
            accent: AdminDashboardScreen.neon,
            onTap: () => onTap('status'),
          ),
          _SidebarButton(
            icon: '⚠️',
            label: 'Complaints',
            sub: 'Pending resolutions',
            count: '7',
            accent: AdminDashboardScreen.orange,
            onTap: () => onTap('complaints'),
          ),
          _SidebarButton(
            icon: '💬',
            label: 'Feedback',
            sub: 'User reviews',
            count: '93%',
            accent: AdminDashboardScreen.green,
            onTap: () => onTap('feedback'),
          ),

          const SizedBox(height: 8),

          // Today's summary card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AdminDashboardScreen.neon.withOpacity(0.04),
              border: Border.all(color: AdminDashboardScreen.borderColor),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "TODAY'S SUMMARY",
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1,
                    color: AdminDashboardScreen.muted,
                  ),
                ),
                const SizedBox(height: 10),
                _progressRow('Pickups', '148 / 160', 0.92, AdminDashboardScreen.neon),
                const SizedBox(height: 10),
                _progressRow(
                  'Complaints Resolved',
                  '14 / 21',
                  0.66,
                  AdminDashboardScreen.orange,
                ),
              ],
            ),
          ),

          const Spacer(),

          // Back button
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('←  ',
                      style: TextStyle(color: AdminDashboardScreen.muted, fontSize: 13)),
                  Text(
                    'Back to Main Site',
                    style: TextStyle(color: AdminDashboardScreen.muted, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressRow(String label, String value, double fraction, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: AdminDashboardScreen.muted)),
            Text(value,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 4,
            backgroundColor: Colors.white.withOpacity(0.06),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

class _SidebarButton extends StatelessWidget {
  const _SidebarButton({
    required this.icon,
    required this.label,
    required this.sub,
    required this.count,
    required this.accent,
    required this.onTap,
  });

  final String icon;
  final String label;
  final String sub;
  final String count;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AdminDashboardScreen.card,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  alignment: Alignment.center,
                  child: Text(icon, style: const TextStyle(fontSize: 15)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AdminDashboardScreen.text,
                        ),
                      ),
                      Text(
                        sub,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AdminDashboardScreen.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    count,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── Main content ───────────────────────────

class _MainContent extends StatelessWidget {
  const _MainContent({
    required this.isMobile,
    required this.onNavigate,
    required this.onLogout,
  });

  final bool isMobile;
  final void Function(String routeKey) onNavigate;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Desktop topbar
        if (!isMobile)
          Padding(
            padding: const EdgeInsets.fromLTRB(44, 28, 44, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Text('EcoWaste', style: TextStyle(fontSize: 12, color: AdminDashboardScreen.muted)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('›', style: TextStyle(color: AdminDashboardScreen.muted)),
                    ),
                    Text('Admin Panel',
                        style: TextStyle(fontSize: 12, color: AdminDashboardScreen.neon, fontWeight: FontWeight.w500)),
                  ],
                ),
                Row(
                  children: [
                    const _LiveChip(),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.logout, color: AdminDashboardScreen.orange, size: 20),
                      tooltip: 'Logout',
                      onPressed: onLogout,
                    ),
                  ],
                ),
              ],
            ),
          ),

        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 16 : 44,
              isMobile ? 18 : 30,
              isMobile ? 16 : 44,
              30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- Hero ----
                Row(
                  children: [
                    Container(width: 20, height: 1, color: AdminDashboardScreen.orange),
                    const SizedBox(width: 8),
                    const Text(
                      'ADMIN CONTROL CENTER',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3,
                        color: AdminDashboardScreen.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage & Monitor',
                  style: TextStyle(
                    fontSize: isMobile ? 28 : 42,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.05,
                    letterSpacing: -1,
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      AdminDashboardScreen.neon,
                      AdminDashboardScreen.blue,
                      AdminDashboardScreen.green,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'All Operations',
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 42,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.05,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: const Text(
                    'Oversee every aspect of EcoWaste — monitor pickup requests, resolve '
                    'complaints in real time, and analyze user feedback to drive a cleaner, '
                    'greener city.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AdminDashboardScreen.muted,
                      height: 1.7,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ---- Stat cards ----
                _StatGrid(isMobile: isMobile, onNavigate: onNavigate),
                const SizedBox(height: 28),

                // ---- Operations overview ----
                const _SectionHeader(
                  title: 'Operations Overview',
                  subtitle: 'Live monitoring from field stations',
                ),
                const SizedBox(height: 16),
                _ImageGrid(isMobile: isMobile),
                const SizedBox(height: 28),

                // ---- Activity feed ----
                const _SectionHeader(
                  title: 'Recent Activity',
                  subtitle: 'Last 2 hours across all zones',
                ),
                const SizedBox(height: 16),
                _ActivityFeed(isMobile: isMobile),
                const SizedBox(height: 20),

                // ---- Footer ----
                Center(
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 12, color: AdminDashboardScreen.muted),
                      children: const [
                        TextSpan(text: '🌱 '),
                        TextSpan(
                          text: 'EcoWaste',
                          style: TextStyle(
                            color: AdminDashboardScreen.neon,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' Admin Panel · © 2026 All Rights Reserved'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: AdminDashboardScreen.muted),
        ),
      ],
    );
  }
}

// ─────────────────────────── Stat cards ───────────────────────────

class _StatData {
  final String icon;
  final String value;
  final String suffix;
  final String label;
  final String badge;
  final Color accent;
  final String? routeKey; // null = not tappable
  const _StatData(this.icon, this.value, this.suffix, this.label, this.badge, this.accent,
      [this.routeKey]);
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.isMobile, required this.onNavigate});

  final bool isMobile;
  final void Function(String routeKey) onNavigate;

  static const stats = [
    _StatData('🚛', '148', '', 'Total Pickups Today', '↑ 12% vs yesterday', AdminDashboardScreen.neon, 'status'),
    _StatData('⚠️', '7', '', 'Open Complaints', '3 urgent', AdminDashboardScreen.orange, 'complaints'),
    _StatData('💬', '93', '%', 'Positive Feedback', '↑ Excellent', AdminDashboardScreen.green, 'feedback'),
    _StatData('♻️', '5.2', 't', 'Waste Processed', "Today's total", AdminDashboardScreen.blue),
  ];

  @override
  Widget build(BuildContext context) {
    final cols = isMobile ? 2 : 4;
    return GridView.count(
      crossAxisCount: cols,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: isMobile ? 1.3 : 1.5,
      children: stats
          .map((s) => _StatCard(
                data: s,
                onTap: s.routeKey == null ? null : () => onNavigate(s.routeKey!),
              ))
          .toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data, this.onTap});

  final _StatData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AdminDashboardScreen.card,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AdminDashboardScreen.borderColor),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(height: 2, width: 18, color: data.accent),
            ],
          ),
          const SizedBox(height: 6),
          Text(data.icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: data.value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                if (data.suffix.isNotEmpty)
                  TextSpan(
                    text: data.suffix,
                    style: const TextStyle(fontSize: 14, color: AdminDashboardScreen.muted),
                  ),
              ],
            ),
          ),
          Text(
            data.label,
            style: const TextStyle(fontSize: 11, color: AdminDashboardScreen.muted),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: data.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data.badge,
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: data.accent),
            ),
          ),
        ],
      ),
      ),
      ),
    );
  }
}

// ─────────────────────────── Image grid ───────────────────────────

class _ImageCardData {
  final String url;
  final String tag;
  final String title;
  final Color accent;
  const _ImageCardData(this.url, this.tag, this.title, this.accent);
}

class _ImageGrid extends StatelessWidget {
  const _ImageGrid({required this.isMobile});

  final bool isMobile;

  static const items = [
    _ImageCardData(
      'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=600&q=80',
      '🟢 Active',
      'Smart Waste Monitoring',
      AdminDashboardScreen.neon,
    ),
    _ImageCardData(
      'https://images.unsplash.com/photo-1509395176047-4a66953fd231?w=600&q=80',
      '🚛 Fleet',
      'Efficient Pickup System',
      AdminDashboardScreen.orange,
    ),
    _ImageCardData(
      'https://images.unsplash.com/photo-1497436072909-60f360e1d4b1?w=600&q=80',
      '🌍 Eco',
      'Eco-Friendly Solutions',
      AdminDashboardScreen.green,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cols = isMobile ? 1 : 3;
    return GridView.count(
      crossAxisCount: cols,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isMobile ? 1.6 : 1.1,
      children: items.map((d) => _ImageCard(data: d)).toList(),
    );
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({required this.data});

  final _ImageCardData data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AdminDashboardScreen.borderColor),
            ),
            child: Image.network(
              data.url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                color: AdminDashboardScreen.card,
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported, color: AdminDashboardScreen.muted),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: data.accent.withOpacity(0.2),
                    border: Border.all(color: data.accent.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data.tag,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: data.accent,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Activity feed ───────────────────────────

class _FeedItemData {
  final String icon;
  final String label;
  final String meta;
  final String status;
  final Color accent;
  const _FeedItemData(this.icon, this.label, this.meta, this.status, this.accent);
}

class _ActivityFeed extends StatelessWidget {
  const _ActivityFeed({required this.isMobile});

  final bool isMobile;

  static const items = [
    _FeedItemData('🚛', 'Zone A — Pickup Completed', '08:42 AM · Driver: Ravi Kumar', 'Done', AdminDashboardScreen.neon),
    _FeedItemData('⚠️', 'New Complaint — Zone C', '09:05 AM · Missed pickup reported', 'Urgent', AdminDashboardScreen.orange),
    _FeedItemData('💬', 'Feedback — 5 Star Rating', '09:18 AM · Resident, Zone B', '★ 5.0', AdminDashboardScreen.green),
    _FeedItemData('♻️', 'Recyclables Processed — 1.2t', '09:30 AM · Facility: Central Plant', 'Logged', AdminDashboardScreen.blue),
  ];

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        children: items
            .map((d) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _FeedItem(data: d),
                ))
            .toList(),
      );
    }
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 4.2,
      children: items.map((d) => _FeedItem(data: d)).toList(),
    );
  }
}

class _FeedItem extends StatelessWidget {
  const _FeedItem({required this.data});

  final _FeedItemData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AdminDashboardScreen.card,
        border: Border.all(color: AdminDashboardScreen.borderColor),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: data.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(data.icon, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AdminDashboardScreen.text,
                  ),
                ),
                Text(
                  data.meta,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, color: AdminDashboardScreen.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: data.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data.status,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: data.accent),
            ),
          ),
        ],
      ),
    );
  }
}