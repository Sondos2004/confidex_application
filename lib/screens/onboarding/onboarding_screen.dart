import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';

class _OnboardingPage {
  final String imagePath;
  final String title;
  final String description;
  final List<Color> colors;
  final IconData fallbackIcon;

  const _OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.colors,
    required this.fallbackIcon,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _entryController;
  late Animation<double> _entryOpacity;
  late Animation<Offset> _entrySlide;

  static const List<_OnboardingPage> _pages = [
    _OnboardingPage(
      imagePath: 'assets/images/onboarding_1.png',
      title: 'Upload Your\nPresentation',
      description:
          'Record or upload any presentation video — pitch decks, board meetings, or TED-style talks. Confidex handles every format.',
      colors: [Color(0xFF5B8DEF), Color(0xFF3A6ED8)],
      fallbackIcon: Icons.upload_file_rounded,
    ),
    _OnboardingPage(
      imagePath: 'assets/images/onboarding_2.png',
      title: 'AI-Powered\nAnalysis',
      description:
          'Our AI studies your body language, eye contact, vocal pacing, and filler words to give you deep, actionable insights.',
      colors: [Color(0xFF9B5DE5), Color(0xFF7B3DC5)],
      fallbackIcon: Icons.psychology_rounded,
    ),
    _OnboardingPage(
      imagePath: 'assets/images/onboarding_3.png',
      title: 'Master Your\nPresence',
      description:
          'Receive expert coaching tips, track improvement over time, and become the most compelling presenter in any room.',
      colors: [Color(0xFFE040A0), Color(0xFFC020A0)],
      fallbackIcon: Icons.trending_up_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _entryOpacity = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeIn,
    );
    _entrySlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _skip() => Navigator.pushReplacementNamed(context, AppRoutes.login);

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _entryOpacity,
        child: SlideTransition(
          position: _entrySlide,
          child: Stack(
            children: [
              // Animated background tint
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      page.colors[0].withOpacity(0.07),
                      AppColors.background,
                    ],
                  ),
                ),
              ),
              // Pages
              PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _buildPage(_pages[i]),
              ),
              // Skip button
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                right: 20,
                child: AnimatedOpacity(
                  opacity: _currentPage < _pages.length - 1 ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: TextButton(
                    onPressed: _skip,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    child: Text(
                      'Skip',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              // Bottom controls
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomControls(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        // Illustration
        SizedBox(
          height: size.height * 0.54,
          width: double.infinity,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
              child: Image.asset(
                page.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _buildFallback(page),
              ),
            ),
          ),
        ),
        // Text
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 12, 32, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (b) =>
                      LinearGradient(colors: page.colors).createShader(b),
                  child: Text(
                    page.title,
                    style: GoogleFonts.inter(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.15,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  page.description,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
      ],
    );
  }

  Widget _buildFallback(_OnboardingPage page) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              page.colors[0].withOpacity(0.15),
              page.colors[1].withOpacity(0.05),
            ],
          ),
        ),
        child: Icon(
          page.fallbackIcon,
          size: 80,
          color: page.colors[0].withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    final page = _pages[_currentPage];
    return Container(
      padding: EdgeInsets.fromLTRB(
        28,
        20,
        28,
        MediaQuery.of(context).padding.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmoothPageIndicator(
            controller: _pageController,
            count: _pages.length,
            effect: ExpandingDotsEffect(
              activeDotColor: page.colors[0],
              dotColor: AppColors.surfaceLight,
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 4,
              spacing: 6,
            ),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: _next,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              width: double.infinity,
              height: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: page.colors),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: page.colors[0].withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Continue',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
