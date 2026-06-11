import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  // API
  static String get ticketmasterApiKey =>
      dotenv.env['TICKETMASTER_API_KEY'] ?? '';
  static String get ticketmasterBaseUrl =>
      dotenv.env['TICKETMASTER_BASE_URL'] ??
      'https://app.ticketmaster.com/discovery/v2';
  static String get googleMapsApiKey =>
      dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  // API defaults
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
  static const String defaultCountryCode = 'US';
  static const String defaultCity = 'New York';
  static const double defaultLat = 40.7128;
  static const double defaultLng = -74.0060;

  // Hive Box names
  static const String favoritesBox = 'favorites_box';
  static const String ticketsBox = 'tickets_box';
  static const String userPrefsBox = 'user_prefs_box';
  static const String userProfileBox = 'user_profile_box';

  // SharedPreferences keys
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keySelectedCity = 'selected_city';
  static const String keySelectedLat = 'selected_lat';
  static const String keySelectedLng = 'selected_lng';
  static const String keyThemeMode = 'theme_mode';
  static const String keyPreferencesSet = 'preferences_set';

  // Simulated booking
  static const double serviceFee = 5.0;
  static const double gaTicketDefaultPrice = 120.0;
  static const double vipTicketDefaultPrice = 200.0;
  static const double dayPassDefaultPrice = 80.0;
  static const double refundPercentage = 0.80;

  // App info
  static const String appName = 'Tickety';
  static const String appVersion = '1.0.0';
}
