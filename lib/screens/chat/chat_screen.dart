import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/dashed_card.dart';

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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _buildTopHeader(),
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

  Widget _buildTopHeader() {
    String stepText = '';
    switch (_currentState) {
      case PracticeState.upload:
        stepText = '02 • UPLOAD';
        break;
      case PracticeState.analyzing:
        stepText = '03 • ANALYZING';
        break;
      case PracticeState.report:
        stepText = '04 • REPORT';
        break;
    }

    return Column(
      children: [
        // Step Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accentPurple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            stepText,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 16),
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
                    'assets/images/logo_confidex.png',
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
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Profile Icon
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surfaceLight,
              child: Icon(Icons.person, color: Colors.white, size: 20),
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
        Text(
          'Upload Your Practice Material',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Submit your recorded video and document for\nevaluation',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 32),
        
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildUploadSection(
                  title: 'Upload Video',
                  icon: Icons.videocam_rounded,
                  buttonText: 'Browse Files',
                  formats: 'Supported: MP4, MOV, AVI',
                ),
                const SizedBox(height: 24),
                _buildUploadSection(
                  title: 'Upload Document',
                  icon: Icons.attach_file_rounded,
                  buttonText: 'Upload Document',
                  formats: 'Accepted: PDF, DOCX, PPT',
                ),
              ],
            ),
          ),
        ),
        
        _buildMainGradientButton(
          text: '✨ Submit for Analysis',
          onPressed: _startAnalysis,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildUploadSection({
    required String title, 
    required IconData icon, 
    required String buttonText,
    required String formats
  }) {
    return DashedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.accentPurple,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 16),
          Text(
            'Drag & Drop $title Here\nor',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.accentPurple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              buttonText,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            formats,
            style: GoogleFonts.inter(
              color: AppColors.textHint,
              fontSize: 11,
            ),
          ),
        ],
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
        Text(
          'Analyzing Your Submissions',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "We're processing your uploaded video and document.",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 13,
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
                const SizedBox(height: 16),
                _buildAnalyzingCard(
                  title: 'Processing Document...',
                  subtitle: 'Extracting key content',
                  icon: Icons.description_rounded,
                  progress: _docProgress,
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
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surfaceLight, width: 2),
                ),
              ),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 2),
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentPurple,
                ),
                child: _videoProgress >= 1.0 
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 30)
                    : const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'This might take a moment...',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'AI is evaluating your confidence,\naccuracy & delivery style',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: AppColors.textHint,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildAnalyzingCard({
    required String title, 
    required String subtitle, 
    required IconData icon, 
    required double progress
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accentPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: GoogleFonts.inter(
                    color: AppColors.accentPurple,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          // Thin progress bar at bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.lerp(AppColors.accentPurple, Colors.white, 0.3)!,
                ),
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
            Text(
              "Here's Your Report",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
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
            color: AppColors.textSecondary,
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
                  color: AppColors.scoreConfidence,
                  progress: 0.85,
                ),
                const SizedBox(height: 16),
                _buildScoreCard(
                  title: 'Nervousness Score',
                  score: '34/100',
                  icon: '💜',
                  color: AppColors.scoreNervousness,
                  progress: 0.34,
                ),
                const SizedBox(height: 16),
                _buildScoreCard(
                  title: 'Accuracy Score',
                  score: '92/100',
                  icon: '🎯',
                  color: AppColors.scoreAccuracy,
                  progress: 0.92,
                ),
                const SizedBox(height: 16),
                _buildScoreCard(
                  title: 'Overall Performance',
                  score: 'Excellent',
                  icon: '⭐',
                  color: AppColors.scoreOverall,
                  progress: 0.9,
                  isTextScore: true,
                ),
              ],
            ),
          ),
        ),
        
        // Bottom Success Alert
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
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
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        _buildMainGradientButton(
          text: '📊 View Detailed Report',
          onPressed: () {
            setState(() {
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 3,
                  width: double.infinity,
                  color: AppColors.border,
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
            child: Text(
              score,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w800,
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
  Widget _buildMainGradientButton({required String text, required VoidCallback onPressed}) {
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
}
