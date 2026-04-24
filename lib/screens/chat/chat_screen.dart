import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_ext.dart';
import '../../core/routes/app_routes.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/glass_container.dart';

enum PracticeState { upload, analyzing, report }

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  PracticeState _currentState = PracticeState.upload;
  double _videoProgress = 0.0;
  double _docProgress = 0.0;
  XFile? _pickedVideo;
  final _picker = ImagePicker();

  Future<void> _showVideoOptions() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: context.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: context.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.accentPurple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library_rounded,
                      color: AppColors.accentPurple),
                ),
                title: Text('Upload from Photos',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary)),
                subtitle: Text('Choose a video from your gallery',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: context.textSecondary)),
                onTap: () async {
                  Navigator.pop(context);
                  final video =
                      await _picker.pickVideo(source: ImageSource.gallery);
                  if (video != null) setState(() => _pickedVideo = video);
                },
              ),
              const SizedBox(height: 4),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.accentPink.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.videocam_rounded,
                      color: AppColors.accentPink),
                ),
                title: Text('Record Now',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary)),
                subtitle: Text('Record a new video with your camera',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: context.textSecondary)),
                onTap: () async {
                  Navigator.pop(context);
                  final video =
                      await _picker.pickVideo(source: ImageSource.camera);
                  if (video != null) setState(() => _pickedVideo = video);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _startAnalysis() {
    setState(() {
      _currentState = PracticeState.analyzing;
      _videoProgress = 0.0;
      _docProgress = 0.0;
    });

    _simulateProgress();
  }

  void _simulateProgress() async {
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (!mounted) return;
      setState(() {
        _videoProgress = i / 100.0;
        _docProgress = (i * 0.8) / 100.0;
      });
    }

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _currentState = PracticeState.report;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _buildTopHeader(context),
              const SizedBox(height: 24),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _buildCurrentState(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Column(
      children: [
        // Logo and Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 36,
                    width: 36,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: AppColors.accentPurple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'C',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Confidex',
                  style: GoogleFonts.inter(
                    color: context.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Profile Icon
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.surface,
                    ),
                    child: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) =>
                          AppColors.primaryGradient.createShader(bounds),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentState() {
    switch (_currentState) {
      case PracticeState.upload:
        return _buildUploadScreen();
      case PracticeState.analyzing:
        return _buildAnalyzingScreen();
      case PracticeState.report:
        return _buildReportScreen();
    }
  }

  // ---------------------------------------------------------
  // UPLOAD SCREEN
  // ---------------------------------------------------------
  Widget _buildUploadScreen() {
    return Column(
      key: const ValueKey('upload'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
          child: Text(
            'Upload Your Practice Material',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Submit your recorded video for AI evaluation',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: context.textSecondary,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 28),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: _buildVideoUploadCard(),
          ),
        ),
        _buildMainGradientButton(
          text: 'Submit for Analysis',
          onPressed: _startAnalysis,
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 24),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildVideoUploadCard() {
    final picked = _pickedVideo != null;
    return GestureDetector(
      onTap: _showVideoOptions,
      child: GlassContainer(
        borderRadius: 24,
        padding: const EdgeInsets.all(28),
        borderColor: picked ? AppColors.accentPurple : const Color(0x1AFFFFFF),
        boxShadow: picked
            ? [
                BoxShadow(
                  color: AppColors.accentPurple.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 2,
                )
              ]
            : null,
        child: Column(
          children: [
            // Icon zone
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: picked
                    ? AppColors.primaryGradient
                    : LinearGradient(
                        colors: [
                          AppColors.accentPurple.withValues(alpha: 0.15),
                          AppColors.accentPink.withValues(alpha: 0.15),
                        ],
                      ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(
                picked ? Icons.check_circle_rounded : Icons.videocam_rounded,
                color: picked ? Colors.white : AppColors.accentPurple,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            // Title
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
              child: Text(
                picked ? 'Video Ready' : 'Upload Video',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              picked
                  ? _pickedVideo!.name
                  : 'Tap to choose from your gallery\nor record a new video',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: context.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 24),
            // Format badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accentPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.accentPurple.withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                'MP4 • MOV • AVI',
                style: GoogleFonts.inter(
                  color: AppColors.accentPurple,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // ANALYZING SCREEN
  // ---------------------------------------------------------
  Widget _buildAnalyzingScreen() {
    return Column(
      key: const ValueKey('analyzing'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        context.applyTextGradient(
          Text(
            'Analyzing Your Submissions',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: context.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 6),
        context.applyTextGradient(
          Text(
            "We're processing your uploaded video and document.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: context.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 32),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildAnalyzingCard(
                  title: 'Processing Video...',
                  subtitle: 'Analyzing body language & tone',
                  icon: Icons.movie_creation_rounded,
                  progress: _videoProgress,
                ),
              ],
            ),
          ),
        ),

        // Animated Checkmark / Loader
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glowing ripple
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentPurple.withValues(alpha: 0.05),
                  border: Border.all(
                      color: AppColors.accentPurple.withValues(alpha: 0.1),
                      width: 1),
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentPurple.withValues(alpha: 0.1),
                  border: Border.all(
                      color: AppColors.accentPurple.withValues(alpha: 0.2),
                      width: 1.5),
                ),
              ),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentPurple.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: _videoProgress >= 1.0
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 32)
                    : const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2.5,
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        context.applyTextGradient(
          Text(
            'This might take a moment...',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: context.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 8),
        context.applyTextGradient(
          Text(
            'AI is evaluating your confidence,\naccuracy & delivery style',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: context.textHint,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildAnalyzingCard(
      {required String title,
      required String subtitle,
      required IconData icon,
      required double progress}) {
    return GlassContainer(
      borderRadius: 16,
      borderColor: const Color(0x1AFFFFFF),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentPurple.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      context.applyTextGradient(
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            color: context.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          color: context.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Thin progress bar at bottom
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: context.border,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.accentPurple),
                minHeight: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // REPORT SCREEN
  // ---------------------------------------------------------
  Widget _buildReportScreen() {
    return Column(
      key: const ValueKey('report'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: Text(
                "Here's Your Report",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('🎯', style: TextStyle(fontSize: 22)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Your practice material has been evaluated. Below are\nyour scores based on our analysis.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: context.textSecondary,
            fontSize: 12,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildScoreCard(
                  title: 'Confidence Score',
                  score: '85/100',
                  icon: '👍',
                  color: AppColors.accentPurple,
                  progress: 0.85,
                ),
                const SizedBox(height: 16),
                _buildScoreCard(
                  title: 'Nervousness Score',
                  score: '34/100',
                  icon: '💜',
                  color: AppColors.accentPurple,
                  progress: 0.34,
                ),
                const SizedBox(height: 16),
                _buildScoreCard(
                  title: 'Accuracy Score',
                  score: '92/100',
                  icon: '🎯',
                  color: AppColors.accentPurple,
                  progress: 0.92,
                ),
                const SizedBox(height: 16),
                _buildScoreCard(
                  title: 'Overall Performance',
                  score: 'Excellent',
                  icon: '⭐',
                  color: AppColors.accentPurple,
                  progress: 0.9,
                  isTextScore: true,
                ),
              ].animate(interval: 100.ms).fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
            ),
          ),
        ).animate().fadeIn(duration: 500.ms),

        // Bottom Success Alert
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.border),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.accentBlue, AppColors.success],
                  ),
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analysis Complete!',
                    style: GoogleFonts.inter(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'This might take a moment...',
                    style: GoogleFonts.inter(
                      color: context.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildOutlinedButton(
          text: '📊 View Detailed Report',
          onPressed: () {
            // TODO: Navigate to detailed report screen
          },
        ),
        const SizedBox(height: 12),

        _buildMainGradientButton(
          text: '🔄 Start New Session',
          onPressed: () {
            setState(() {
              _pickedVideo = null;
              _currentState = PracticeState.upload;
            });
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildScoreCard({
    required String title,
    required String score,
    required String icon,
    required Color color,
    required double progress,
    bool isTextScore = false,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      borderRadius: 16,
      borderColor: const Color(0x1AFFFFFF),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Center(child: Text(icon, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 3,
                  width: double.infinity,
                  color: context.border,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(color: color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: Text(
                score,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // SHARED WIDGETS
  // ---------------------------------------------------------
  Widget _buildMainGradientButton(
      {required String text, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: AppColors.primaryGradient,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton(
      {required String text, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentPurple, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.inter(
                  color: AppColors.accentPurple,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
