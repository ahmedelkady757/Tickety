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
      'title': 'Discover Amazing Events',
      'subtitle': 'Find the best concerts, sports, and theatre events happening near you right now.',
      'image': 'assets/images/onboarding_1.png', // Placeholder
    },
    {
      'title': 'Easy & Fast Booking',
      'subtitle': 'Book your tickets in just a few taps and get them instantly on your phone.',
      'image': 'assets/images/onboarding_2.png', // Placeholder
    },
    {
      'title': 'Enjoy the Experience',
      'subtitle': 'Scan your digital ticket at the gate and enjoy the unforgettable experience.',
      'image': 'assets/images/onboarding_3.png', // Placeholder
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go(AppRoutes.signIn),
                child: Text(
                  'Skip',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildPage(
                    title: _onboardingData[index]['title']!,
                    subtitle: _onboardingData[index]['subtitle']!,
                    imagePath: _onboardingData[index]['image']!,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _onboardingData.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.border,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppButton.primary(
                    text: _currentPage == _onboardingData.length - 1 ? 'Get Started' : 'Next',
                    onPressed: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        context.go(AppRoutes.signIn);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({required String title, required String subtitle, required String imagePath}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Icon(Icons.image_outlined, size: 100, color: AppColors.border),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: AppTextStyles.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
