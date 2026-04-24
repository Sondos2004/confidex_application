import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/theme/app_colors.dart';

class ThemeBackground extends StatelessWidget {
  final Widget child;

  const ThemeBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
      ),
      child: Stack(
        children: [
          // Starry particles
          Positioned.fill(
            child: CustomPaint(
              painter: _StarryPainter(),
            ),
          ),
          // Bottom waves
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            child: CustomPaint(
              painter: _WavesPainter(),
            ),
          ),
          // Content
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _StarryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.4);
    final random = math.Random(42); // fixed seed for static stars

    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5 + 0.5;
      
      // Add a bit of glow to some stars
      if (random.nextDouble() > 0.8) {
        final glowPaint = Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
        canvas.drawCircle(Offset(x, y), radius * 3, glowPaint);
      }
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;
      
    final paint3 = Paint()
      ..color = const Color(0xFF0D0820).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw multiple overlapping waves
    _drawWave(canvas, size, paint1, 0.4, 0.6, 0.1);
    _drawWave(canvas, size, paint2, 0.6, 0.4, 0.2);
    _drawWave(canvas, size, paint3, 0.8, 0.2, 0.0);
  }

  void _drawWave(Canvas canvas, Size size, Paint paint, double heightStart, double heightEnd, double offset) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * heightStart);
    
    path.quadraticBezierTo(
      size.width * 0.25, size.height * (heightStart - offset - 0.2), 
      size.width * 0.5, size.height * ((heightStart + heightEnd) / 2)
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * (heightEnd + offset + 0.2), 
      size.width, size.height * heightEnd
    );
    
    path.lineTo(size.width, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
