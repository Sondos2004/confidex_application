import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';

class RateAppDialog extends StatefulWidget {
  const RateAppDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Rate App Dialog',
      barrierColor: Colors.black.withOpacity(0.7),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => const RateAppDialog(),
      transitionBuilder: (_, animation, __, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  @override
  State<RateAppDialog> createState() => _RateAppDialogState();
}

class _RateAppDialogState extends State<RateAppDialog> {
  int _selectedRating = 0;
  int _hoveredRating = 0;
  final _commentController = TextEditingController();
  bool _submitted = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedRating == 0) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() {_submitted = true; _isSubmitting = false;});
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) Navigator.of(context).pop();
  }

  String get _ratingLabel {
    switch (_selectedRating) {
      case 1: return 'Poor';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Great';
      case 5: return 'Excellent!';
      default: return 'Tap to rate';
    }
  }

  Color get _ratingColor {
    switch (_selectedRating) {
      case 1: return AppColors.error;
      case 2: return AppColors.warning;
      case 3: return const Color(0xFFFFDA6A);
      case 4: return AppColors.success;
      case 5: return AppColors.accentBlue;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentPurple.withOpacity(0.15),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: _submitted ? _buildSuccessState() : _buildRatingState(),
        ),
      ),
    );
  }

  Widget _buildRatingState() {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          // Icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentBlue.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.star_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 20),
          Text(
            'Enjoying Confidex?',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your feedback helps us improve your\npresentation coaching experience.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),
          // Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isActive = starIndex <= (_hoveredRating > 0 ? _hoveredRating : _selectedRating);
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedRating = starIndex;
                  _hoveredRating = 0;
                }),
                child: MouseRegion(
                  onEnter: (_) => setState(() => _hoveredRating = starIndex),
                  onExit: (_) => setState(() => _hoveredRating = 0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(6),
                    child: AnimatedScale(
                      scale: isActive ? 1.15 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        isActive ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 40,
                        color: isActive ? AppColors.warning : AppColors.border,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _ratingColor,
            ),
            child: Text(_ratingLabel),
          ),
          const SizedBox(height: 24),
          // Optional comment
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: _commentController,
              maxLines: 3,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Share your thoughts (optional)...',
                hintStyle: GoogleFonts.inter(
                  color: AppColors.textHint,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                fillColor: Colors.transparent,
                filled: true,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Buttons
          AnimatedOpacity(
            opacity: _selectedRating > 0 ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: _selectedRating > 0 ? _submit : null,
              child: Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  gradient: _selectedRating > 0
                      ? AppColors.primaryGradient
                      : const LinearGradient(
                          colors: [AppColors.border, AppColors.border],
                        ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _selectedRating > 0
                      ? [
                          BoxShadow(
                            color: AppColors.accentBlue.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          )
                        ]
                      : [],
                ),
                child: Center(
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Submit Rating',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Maybe Later',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (_, value, child) =>
                Transform.scale(scale: value, child: child),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.success, Color(0xFF2AAFA6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.3),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Thank You! 🎉',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your feedback means the world to us.\nWe\'re always working to make Confidex better.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Icon(
                i < _selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                color: AppColors.warning,
                size: 22,
              ),
            )),
          ),
        ],
      ),
    );
  }
}
