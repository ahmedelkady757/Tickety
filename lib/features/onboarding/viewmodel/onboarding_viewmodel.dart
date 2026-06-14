import 'package:shared_preferences/shared_preferences.dart';

class OnboardingViewModel {
  static const String _onboardingKey = 'has_seen_onboarding';

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }
}
