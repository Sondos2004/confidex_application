import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/theme_ext.dart';
import 'gradient_button.dart';
import 'glass_container.dart';

class RecordingInstructionsDialog extends StatefulWidget {
  final VoidCallback onAgree;

  const RecordingInstructionsDialog({super.key, required this.onAgree});

  static Future<void> show(
      {required BuildContext context, required VoidCallback onAgree}) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Recording Instructions',
      barrierColor: Colors.black.withOpacity(0.7),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) =>
          RecordingInstructionsDialog(onAgree: onAgree),
      transitionBuilder: (_, animation, __, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  @override
  State<RecordingInstructionsDialog> createState() =>
      _RecordingInstructionsDialogState();
}

class _RecordingInstructionsDialogState
    extends State<RecordingInstructionsDialog> {
  bool _isAgreed = false;

  final List<String> _instructions = [
    'Record in a quiet place with minimal background noise',
    'Ensure good lighting so your face is clearly visible',
    'Keep the camera at eye level',
    'Make sure your face and upper body are visible',
    'Stay centered in the frame (no cutting your head/hands)',
    'Speak clearly and at a natural pace',
    'Avoid background noise (TV, music, people talking)',
    'Keep video length between 30 seconds – 5 minutes',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GlassContainer(
            borderRadius: 24,
            borderColor: const Color(0x1AFFFFFF),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon and Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accentPurple.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.videocam_rounded,
                          color: AppColors.accentPurple, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Recording\nInstructions',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: context.textPrimary,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Instructions List
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.bg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(_instructions.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: index == _instructions.length - 1 ? 0 : 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${index + 1}.',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accentPurple,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _instructions[index],
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: context.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),

                // Checkbox
                GestureDetector(
                  onTap: () => setState(() => _isAgreed = !_isAgreed),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _isAgreed
                              ? AppColors.accentPurple
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _isAgreed
                                ? AppColors.accentPurple
                                : context.border,
                            width: 2,
                          ),
                        ),
                        child: _isAgreed
                            ? const Icon(Icons.check_rounded,
                                color: Colors.white, size: 16)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'I agree to follow these instructions',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: context.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Continue Button
                AnimatedOpacity(
                  opacity: _isAgreed ? 1.0 : 0.5,
                  duration: const Duration(milliseconds: 200),
                  child: GradientButton(
                    text: 'Continue to Upload',
                    gradientColors: const [
                      AppColors.accentPurple,
                      AppColors.accentPink
                    ],
                    onTap: _isAgreed
                        ? () {
                            Navigator.of(context).pop();
                            widget.onAgree();
                          }
                        : null,
                  ),
                ),
                const SizedBox(height: 12),

                // Cancel Button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.textSecondary,
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
