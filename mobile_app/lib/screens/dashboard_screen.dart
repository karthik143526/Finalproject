import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'complaint_screen.dart';
import 'feedback_screen.dart';
import 'request_screen.dart';
import 'timings_screen.dart';
import 'tracking_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const neon = Color(0xFF00FFB2);
  static const neon2 = Color(0xFF00E5FF);
  static const neon3 = Color(0xFFB3FF00);
  static const bg = Color(0xFF050D0A);
  static const bgPanel = Color(0x0A00FFB2);
  static const border = Color(0x2600FFB2);
  static const muted = Color(0x66C8FFE8);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth <= 768;
        return Scaffold(
          backgroundColor: bg,
          drawer: isMobile ? _Sidebar(onTap: (route) => _navigate(context, route)) : null,
          appBar: isMobile
              ? AppBar(
                  backgroundColor: bg.withOpacity(0.92),
                  elevation: 0,
                  title: Row(
                    children: const [
                      _LogoIcon(),
                      SizedBox(width: 12),
                      _LogoText(),
                    ],
                  ),
                  actions: [
                    const _LiveChip(),
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: neon),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  ],
                )
              : null,
          body: Stack(
            children: [
              const _BackgroundBlobs(),
              Row(
                children: [
                  if (!isMobile) SizedBox(width: 280, child: _Sidebar(onTap: (route) => _navigate(context, route))),
                  Expanded(child: _MainContent(isMobile: isMobile, onNavigate: (route) => _navigate(context, route))),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigate(BuildContext context, String route) {
    Widget page;
    switch (route) {
      case 'timings':
        page = const TimingsScreen();
        break;
      case 'request':
        page = const RequestScreen();
        break;
      case 'feedback':
        page = const FeedbackScreen();
        break;
      case 'complaint':
        page = const ComplaintScreen();
        break;
      case 'tracking':
      default:
        page = const TrackingScreen();
        break;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _BackgroundBlobs extends StatelessWidget {
  const _BackgroundBlobs();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -120,
          left: -80,
          child: Container(
            width: 460,
            height: 460,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x2200FFB2), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -120,
          right: -60,
          child: Container(
            width: 360,
            height: 360,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x1A00E5FF), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          top: 180,
          left: 220,
          child: Container(
            width: 280,
            height: 280,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x1AB3FF00), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoIcon extends StatelessWidget {
  const _LogoIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [DashboardScreen.neon, DashboardScreen.neon2]),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [BoxShadow(color: Color(0x4000FFB2), blurRadius: 20, spreadRadius: 2)],
      ),
      child: const Center(child: Icon(Icons.eco, color: Colors.white, size: 22)),
    );
  }
}

class _LogoText extends StatelessWidget {
  const _LogoText();

  @override
  Widget build(BuildContext context) {
    return Text(
      'EcoWaste',
      style: GoogleFonts.syne(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        foreground: Paint()
          ..shader = const LinearGradient(colors: [DashboardScreen.neon, DashboardScreen.neon2]).createShader(const Rect.fromLTWH(0, 0, 120, 0)),
      ),
    );
  }
}

class _LiveChip extends StatelessWidget {
  const _LiveChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DashboardScreen.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(color: DashboardScreen.neon3, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final void Function(String route) onTap;
  const _Sidebar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: const BoxDecoration(
        color: Color(0xDD050D0A),
        border: Border(right: BorderSide(color: DashboardScreen.border)),
      ),
      child: Column(
        children: [
          const _LogoIcon(),
          const SizedBox(height: 18),
          const _LogoText(),
          const SizedBox(height: 32),
          const _NavLabel('Navigation'),
          const SizedBox(height: 12),
          _SidebarLink(label: 'Dashboard', iconData: Icons.dashboard_rounded, active: true, onTap: () {}),
          _SidebarLink(label: 'Timings', iconData: Icons.access_time_rounded, onTap: () => onTap('timings')),
          _SidebarLink(label: 'Request Pickup', iconData: Icons.local_shipping_rounded, onTap: () => onTap('request')),
          _SidebarLink(label: 'Live Tracking', iconData: Icons.location_on_rounded, onTap: () => onTap('tracking')),
          _SidebarLink(label: 'Feedback', iconData: Icons.chat_bubble_rounded, onTap: () => onTap('feedback')),
          _SidebarLink(label: 'Complaint', iconData: Icons.warning_rounded, onTap: () => onTap('complaint')),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: DashboardScreen.bgPanel,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: DashboardScreen.border),
            ),
            child: Row(
              children: const [
                CircleAvatar(radius: 18, backgroundColor: DashboardScreen.neon, child: Icon(Icons.person, size: 18, color: Colors.black)),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Resident User', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text('Zone 3 — Active', style: TextStyle(color: DashboardScreen.muted, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.logout, color: Colors.redAccent, size: 18),
                  SizedBox(width: 12),
                  Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarLink extends StatelessWidget {
  final String label;
  final IconData iconData;
  final bool active;
  final VoidCallback onTap;

  const _SidebarLink({required this.label, required this.iconData, required this.onTap, this.active = false});

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.black : DashboardScreen.muted;
    final bgColor = active ? Colors.white : Colors.transparent;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            decoration: active
                ? const BoxDecoration(
                    gradient: LinearGradient(colors: [DashboardScreen.neon, DashboardScreen.neon2]),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  )
                : null,
            child: Row(
              children: [
                Icon(iconData, size: 18, color: active ? Colors.black : DashboardScreen.neon),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(label, style: TextStyle(color: color, fontWeight: active ? FontWeight.w600 : FontWeight.w500)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLabel extends StatelessWidget {
  final String text;
  const _NavLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(color: DashboardScreen.muted, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  final bool isMobile;
  final void Function(String route) onNavigate;
  const _MainContent({required this.isMobile, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: isMobile ? 12 : 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMobile) const _DesktopTopBar(),
              const SizedBox(height: 20),
              const _HeroSection(),
              const SizedBox(height: 28),
              _StatStrip(onNavigate: onNavigate),
              const SizedBox(height: 26),
              _FeatureGrid(onNavigate: onNavigate, isMobile: isMobile),
              const SizedBox(height: 28),
              const _FooterBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopTopBar extends StatelessWidget {
  const _DesktopTopBar();

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final formatted = '${date.weekday == 7 ? 'Sun' : date.weekday == 1 ? 'Mon' : date.weekday == 2 ? 'Tue' : date.weekday == 3 ? 'Wed' : date.weekday == 4 ? 'Thu' : date.weekday == 5 ? 'Fri' : 'Sat'}, ${date.day} ${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][date.month - 1]}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Text('EcoWaste', style: TextStyle(color: DashboardScreen.muted, fontSize: 12, letterSpacing: 1.2)),
            SizedBox(width: 8),
            Text('�', style: TextStyle(color: DashboardScreen.muted, fontSize: 12)),
            SizedBox(width: 8),
            Text('Dashboard', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
        Row(
          children: [
            const _LiveChip(),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: DashboardScreen.border),
              ),
              child: Text(formatted, style: const TextStyle(color: DashboardScreen.muted, fontSize: 12)),
            ),
            const SizedBox(width: 12),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: DashboardScreen.border),
              ),
              child: const Center(child: Icon(Icons.person, color: Colors.white, size: 20)),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hello, Resident', style: TextStyle(color: DashboardScreen.muted, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 10),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Smart Waste\n', style: GoogleFonts.syne(fontSize: 42, fontWeight: FontWeight.w800, color: Colors.white)),
              TextSpan(text: 'Dashboard', style: GoogleFonts.syne(fontSize: 42, fontWeight: FontWeight.w800, foreground: Paint()..shader = const LinearGradient(colors: [DashboardScreen.neon, DashboardScreen.neon2, DashboardScreen.neon3]).createShader(Rect.fromLTWH(0, 0, 260, 0)))),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatStrip extends StatelessWidget {
  final void Function(String route) onNavigate;
  const _StatStrip({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth < 720 ? 2 : 4;
        return GridView.count(
          crossAxisCount: count,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            _StatCard(iconData: Icons.recycling_rounded, value: '94%', label: 'Recycling Rate', badge: 'Up 3% this week', badgeColor: DashboardScreen.neon, glowColor: Color(0x2600FFB2)),
            _StatCard(iconData: Icons.local_shipping_rounded, value: '12', label: 'Pickups This Month', badge: 'On schedule', badgeColor: DashboardScreen.neon2, glowColor: Color(0x2600E5FF)),
            _StatCard(iconData: Icons.eco_rounded, value: '2.4t', label: 'CO2 Saved', badge: 'Great impact!', badgeColor: DashboardScreen.neon3, glowColor: Color(0x18B3FF00)),
            _StatCard(iconData: Icons.warning_rounded, value: '7', label: 'Open Complaints', badge: '3 urgent', badgeColor: Colors.orange, glowColor: Color(0x16FF6B6B)),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData iconData;
  final String value;
  final String label;
  final String badge;
  final Color badgeColor;
  final Color glowColor;

  const _StatCard({required this.iconData, required this.value, required this.label, required this.badge, required this.badgeColor, required this.glowColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: DashboardScreen.bgPanel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: DashboardScreen.border),
        boxShadow: [BoxShadow(color: glowColor, blurRadius: 30, spreadRadius: 1)],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(iconData, size: 24, color: badgeColor),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.syne(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: DashboardScreen.muted, fontWeight: FontWeight.w500)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: badgeColor.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
            child: Text(badge, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: badgeColor)),
          ),
        ],
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  final void Function(String route) onNavigate;
  final bool isMobile;
  const _FeatureGrid({required this.onNavigate, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: isMobile ? 1 : 3,
      childAspectRatio: isMobile ? 1.1 : 1,
      crossAxisSpacing: 18,
      mainAxisSpacing: 18,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _FeatureCard.wide(
          title: 'Today\'s Collection\nTimings',
          tag: 'SCHEDULE',
          iconData: Icons.schedule_rounded,
          iconColor: DashboardScreen.neon,
          description: 'Real-time waste collection schedule for your zone.',
          onTap: () => onNavigate('timings'),
          child: const _SchedulePreview(),
        ),
        _FeatureCard(
          title: 'Request\nPickup',
          tag: 'PICKUP',
          iconData: Icons.local_shipping_rounded,
          iconColor: DashboardScreen.neon2,
          description: 'Schedule an on-demand waste collection instantly.',
          onTap: () => onNavigate('request'),
          footer: const _ProgressBar(label: 'Last request', status: 'Completed', fill: 1.0, color: DashboardScreen.neon2),
        ),
        _FeatureCard(
          title: 'Live\nTracking',
          tag: 'TRACK',
          iconData: Icons.location_on_rounded,
          iconColor: DashboardScreen.neon3,
          description: 'Track your waste truck in real time.',
          onTap: () => onNavigate('tracking'),
          child: const _MapPreview(),
        ),
        _FeatureCard(
          title: 'Share Your\nExperience',
          tag: 'FEEDBACK',
          iconData: Icons.chat_bubble_rounded,
          iconColor: DashboardScreen.neon,
          description: 'Rate pickups and help us improve our service.',
          onTap: () => onNavigate('feedback'),
          footer: const _ProgressBar(label: 'Avg. Rating', status: '4.8/5', fill: 0.96, color: DashboardScreen.neon),
        ),
        _FeatureCard(
          title: 'Your Eco\nScore',
          tag: 'IMPACT',
          iconData: Icons.eco_rounded,
          iconColor: const Color(0xFF7CFC00),
          description: 'Track your environmental footprint and eco rating.',
          onTap: () {},
          child: const _EcoScorePreview(),
        ),
        _FeatureCard(
          title: 'File a\nComplaint',
          tag: 'REPORT',
          iconData: Icons.warning_rounded,
          iconColor: Colors.redAccent,
          description: 'Report missed pickups or waste dumping issues.',
          onTap: () => onNavigate('complaint'),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String tag;
  final IconData iconData;
  final Color iconColor;
  final String description;
  final VoidCallback onTap;
  final Widget? child;
  final Widget? footer;
  final bool wide;

  const _FeatureCard({required this.title, required this.tag, required this.iconData, required this.iconColor, required this.description, required this.onTap, this.child, this.footer}) : wide = false;
  const _FeatureCard.wide({required this.title, required this.tag, required this.iconData, required this.iconColor, required this.description, required this.onTap, this.child, this.footer}) : wide = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: DashboardScreen.bgPanel,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: DashboardScreen.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: DashboardScreen.neon.withOpacity(0.12), borderRadius: BorderRadius.circular(20), border: Border.all(color: DashboardScreen.border)),
                child: Text(tag, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: DashboardScreen.neon)),
              ),
              const SizedBox(height: 18),
              Icon(iconData, size: 36, color: iconColor),
              const SizedBox(height: 14),
              Text(title, style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 10),
              Text(description, style: const TextStyle(color: DashboardScreen.muted, fontSize: 13, height: 1.6)),
              if (child != null) ...[
                const SizedBox(height: 18),
                child!,
              ],
              const Spacer(),
              if (footer != null) ...[
                footer!,
                const SizedBox(height: 12),
              ],
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: DashboardScreen.neon.withOpacity(0.12), borderRadius: BorderRadius.circular(10), border: Border.all(color: DashboardScreen.border)),
                  child: const Center(child: Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SchedulePreview extends StatelessWidget {
  const _SchedulePreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ScheduleItem(time: '06:00 AM', zone: 'Zone A � Organic Waste', status: 'Done', color: DashboardScreen.neon),
        SizedBox(height: 8),
        _ScheduleItem(time: '09:30 AM', zone: 'Zone B � Dry Waste', status: 'Upcoming', color: DashboardScreen.neon2),
        SizedBox(height: 8),
        _ScheduleItem(time: '02:00 PM', zone: 'Zone C � Recyclables', status: 'Scheduled', color: DashboardScreen.neon3),
      ],
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String time;
  final String zone;
  final String status;
  final Color color;
  const _ScheduleItem({required this.time, required this.zone, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10, spreadRadius: 1)])),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 2),
              Text(zone, style: const TextStyle(fontSize: 12, color: DashboardScreen.muted)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), borderRadius: BorderRadius.circular(12)),
          child: Text(status, style: const TextStyle(fontSize: 10, color: Colors.white)),
        ),
      ],
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DashboardScreen.border),
        gradient: const LinearGradient(colors: [Color(0x1100FFB2), Color(0x1100E5FF)]),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: const [
          Icon(Icons.location_on, color: DashboardScreen.neon, size: 42),
          Positioned(
            top: 16,
            child: Icon(Icons.location_on, color: Color(0x2200FFB2), size: 78),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String label;
  final String status;
  final double fill;
  final Color color;
  const _ProgressBar({required this.label, required this.status, required this.fill, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: DashboardScreen.muted)),
            Text(status, style: TextStyle(fontSize: 11, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 5,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.07), borderRadius: BorderRadius.circular(5)),
          child: FractionallySizedBox(
            widthFactor: fill,
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), gradient: LinearGradient(colors: [color, DashboardScreen.neon]))),
          ),
        ),
      ],
    );
  }
}

class _EcoScorePreview extends StatelessWidget {
  const _EcoScorePreview();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: DashboardScreen.neon.withOpacity(0.35), width: 5),
          ),
          child: const Center(child: Text('85', style: TextStyle(color: DashboardScreen.neon, fontSize: 28, fontWeight: FontWeight.w800))),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Excellent rating', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text('Top 10% in zone', style: TextStyle(color: DashboardScreen.muted, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterBar extends StatelessWidget {
  const _FooterBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.25)),
      child: const Text(
        'EcoWaste — Making cities cleaner, greener & smarter · 2026 All Rights Reserved',
        style: TextStyle(color: DashboardScreen.muted, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}

