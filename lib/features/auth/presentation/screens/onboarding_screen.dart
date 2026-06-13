import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/core.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Explore Upcoming and\nNearby Events',
      'subtitle': 'In publishing and graphic design, Lorem is a placeholder text commonly',
      'image': 'assets/images/onboarding_1.png',
    },
    {
      'title': 'Easy & Fast\nTicket Booking',
      'subtitle': 'Book your tickets in just a few taps and get them instantly on your phone.',
      'image': 'assets/images/onboarding_2.png',
    },
    {
      'title': 'Enjoy the\nExperience',
      'subtitle': 'Scan your digital ticket at the gate and enjoy the unforgettable experience.',
      'image': 'assets/images/onboarding_3.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage == _onboardingData.length - 1) {
      context.go(AppRoutes.signIn);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                return _OnboardingImagePage(
                  imagePath: _onboardingData[index]['image']!,
                );
              },
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: _OnboardingBottomCard(
              title: _onboardingData[_currentPage]['title']!,
              subtitle: _onboardingData[_currentPage]['subtitle']!,
              currentPage: _currentPage,
              totalPages: _onboardingData.length,
              pageController: _pageController,
              onSkip: () => context.go(AppRoutes.signIn),
              onNext: _next,
              isLast: _currentPage == _onboardingData.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}


class _OnboardingImagePage extends StatelessWidget {
  final String imagePath;

  const _OnboardingImagePage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Align(
        alignment: Alignment.topCenter,
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.surface,
              child: const Center(
                child: Icon(Icons.image_outlined, size: 100, color: AppColors.border),
              ),
            );
          },
        ),
      ),
    );
  }
}


class _OnboardingBottomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int currentPage;
  final int totalPages;
  final PageController pageController;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final bool isLast;

  const _OnboardingBottomCard({
    required this.title,
    required this.subtitle,
    required this.currentPage,
    required this.totalPages,
    required this.pageController,
    required this.onSkip,
    required this.onNext,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 40, 32, 48),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          SmoothPageIndicator(
            controller: pageController,
            count: totalPages,
            effect: ExpandingDotsEffect(
              activeDotColor: Colors.white,
              dotColor: Colors.white.withOpacity(0.35),
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 4,
            ),
          ),
          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onSkip,
                child: Text(
                  'Skip',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: onNext,
                child: Text(
                  isLast ? 'Get Started' : 'Next',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}