import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_ext.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/providers/user_provider.dart';
import '../../core/routes/app_routes.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/glass_container.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _fadeAnim = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeIn,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;

    return Scaffold(
      backgroundColor: context.bg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                backgroundColor: context.surface,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: context.textPrimary,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeader(context.surface, context.textPrimary, context.textSecondary),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsRow(context.cardBackground, context.textPrimary, context.textSecondary, context.border),
                      const SizedBox(height: 28),
                      _buildSectionLabel('Appearance', context.textHint),
                      const SizedBox(height: 10),
                      _buildSettingsCard(context.surface, context.border, [
                        _buildThemeToggle(context.textPrimary, context.textSecondary),
                      ]),
                      const SizedBox(height: 20),
                      _buildSectionLabel('Preferences', context.textHint),
                      const SizedBox(height: 10),
                      _buildSettingsCard(context.surface, context.border, [
                        _buildSwitchRow(
                          icon: Icons.notifications_outlined,
                          label: 'Push Notifications',
                          subtitle: 'Coaching tips & reminders',
                          value: _notificationsEnabled,
                          onChanged: (v) {
                            setState(() => _notificationsEnabled = v);
                          },
                          textPrimary: context.textPrimary,
                          textSecondary: context.textSecondary,
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildSectionLabel('Account', context.textHint),
                      const SizedBox(height: 10),
                      _buildSettingsCard(context.surface, context.border, [
                        _buildTapRow(
                          icon: Icons.lock_outline_rounded,
                          label: 'Privacy & Security',
                          textPrimary: context.textPrimary,
                          textSecondary: context.textSecondary,
                          onTap: () => _showInfoDialog(
                            'Privacy & Security',
                            'Your data is securely stored. You can manage your privacy settings and permissions from the system settings.',
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: context.border,
                          indent: 52,
                        ),
                        _buildTapRow(
                          icon: Icons.help_outline_rounded,
                          label: 'Help & Support',
                          textPrimary: context.textPrimary,
                          textSecondary: context.textSecondary,
                          onTap: () => _showInfoDialog(
                            'Help & Support',
                            'Need help? Contact our support team at support@confidex.app or visit our knowledge base online.',
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: context.border,
                          indent: 52,
                        ),
                        _buildTapRow(
                          icon: Icons.info_outline_rounded,
                          label: 'About Confidex',
                          subtitle: 'Version 1.0.0',
                          textPrimary: context.textPrimary,
                          textSecondary: context.textSecondary,
                          onTap: () => _showInfoDialog(
                            'About Confidex',
                            'Confidex is an AI-powered communication coach designed to help you present with confidence.',
                          ),
                        ),
                      ]),
                      const SizedBox(height: 32),
                      _buildSignOutButton(context.surface),
                    ].animate(interval: 50.ms).fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0, curve: Curves.easeOutQuad),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color surface, Color textPrimary, Color textSecondary) {
    final user = context.watch<UserProvider>();

    return Container(
      decoration: BoxDecoration(
        color: surface,
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentBlue.withOpacity(0.35),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      user.initials,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surface,
                        width: 2.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              user.name.isNotEmpty ? user.name : 'Your Name',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.email.isNotEmpty ? user.email : 'your@email.com',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '⚡ Pro Member',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(
      Color card,
      Color textPrimary,
      Color textSecondary,
      Color border,
      ) {
    final stats = [
      ('12', 'Videos\nAnalyzed', Icons.video_library_rounded),
      ('84', 'Tips\nReceived', Icons.lightbulb_outline_rounded),
      ('7', 'Day\nStreak 🔥', Icons.local_fire_department_rounded),
    ];

    return Row(
      children: stats.asMap().entries.map((e) {
        final s = e.value;
        return Expanded(
          child: GlassContainer(
            margin: EdgeInsets.only(left: e.key == 0 ? 0 : 8),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            borderRadius: 18,
            borderColor: const Color(0x1AFFFFFF),
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    s.$1,
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.$2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionLabel(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
      Color surface,
      Color border,
      List<Widget> children,
      ) {
    return GlassContainer(
      borderRadius: 18,
      borderColor: const Color(0x1AFFFFFF),
      child: Column(children: children),
    );
  }

  Widget _buildThemeToggle(Color textPrimary, Color textSecondary) {
    final themeProvider = context.watch<ThemeProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              themeProvider.isDark
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                Text(
                  themeProvider.isDark ? 'Dark Mode' : 'Light Mode',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _themeChip(
                  icon: Icons.dark_mode_rounded,
                  label: 'Dark',
                  selected: themeProvider.isDark,
                  onTap: () {
                    if (!themeProvider.isDark) {
                      themeProvider.toggleTheme();
                    }
                  },
                ),
                const SizedBox(width: 4),
                _themeChip(
                  icon: Icons.light_mode_rounded,
                  label: 'Light',
                  selected: !themeProvider.isDark,
                  onTap: () {
                    if (themeProvider.isDark) {
                      themeProvider.toggleTheme();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _themeChip({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.primaryGradient : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String label,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: AppColors.accentBlue, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accentBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildTapRow({
    required IconData icon,
    required String label,
    String? subtitle,
    required Color textPrimary,
    required Color textSecondary,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(icon, color: AppColors.accentBlue, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignOutButton(Color surface) {
    return GestureDetector(
      onTap: () async {
        await context.read<UserProvider>().clearUser();
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      },
      child: GlassContainer(
        width: double.infinity,
        height: 54,
        borderRadius: 16,
        borderColor: AppColors.error.withOpacity(0.4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout_rounded,
              color: AppColors.error,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              'Sign Out',
              style: GoogleFonts.inter(
                color: AppColors.error,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          content,
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.inter(color: AppColors.accentBlue),
            ),
          ),
        ],
      ),
    );
  }
}