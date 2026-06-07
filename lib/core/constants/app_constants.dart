
class AppConstants {
  static const String appName = 'e-sports';
  static const String appVersion = '1.0.0'; ///Flutter sdk 3.41.7

  static const String fontFamily = 'Roboto';
  static const bool payInWevView = false;
  static const int balanceInputLen = 10;
  static const String webHostedUrl = 'https://6ammart-test-web.6amdev.xyz';

  static const bool useReactWebsite = false;
  static const bool stopPolylineAnimation = false;
  static const String googleServerClientId = '491987943015-agln6biv84krpnngdphj87jkko7r9lb8.apps.googleusercontent.com';
  static const String pusherBroadcustUrl = '/api/v1/broadcasting/user-auth';

  static const String baseUrl = 'https://foatball.vercel.app';

  // Supabase
  static const String supabaseUrl = 'https://wrfsbsxigcaapvjityjv.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndyZnNic3hpZ2NhYXB2aml0eWp2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA0NTkzMDcsImV4cCI6MjA5NjAzNTMwN30.Otfr-3Kho9SKl0MjNL0NNAQFJwISPSJtz7az4tV-HCA';

  /// auth endpoints
  static const String registationUri = "/api/user/registation";
  static const String loginUri = "/api/user/signin";
  static const String forgetPaasswordUri = "/api/user/forget-password";
  static const String profileUri = "/api/user/profile";
  static const String verifyForgetPasswordOtpUri = "/api/user/forget-password-verify";
  static const String forgetPasswordUri = "/api/user/forget-password";

  // config
  static const String configUri = "/api/user/config";

  // matchs
  static const String homeMatch = "/api/user/home-match";
  static const String matches = "/api/user/matches";

  // news
  static const String news = "/api/user/news";

  // player
  static const String players = "/api/user/players";
  static const String matchEntries = "/api/user/match-entries";

  // current active season
  static const int currentSeason = 1;


  // static List<ChooseUsModel> whyChooseUsList = [
  //   ChooseUsModel(icon: Images.landingTrusted, title: 'trusted_by_customers_and_store_owners'),
  //   ChooseUsModel(icon: Images.landingStores, title: 'thousands_of_stores'),
  //   ChooseUsModel(icon: Images.landingExcellent, title: 'excellent_shopping_experience'),
  //   ChooseUsModel(icon: Images.landingCheckout, title: 'easy_checkout_and_payment_system'),
  // ];


  // static List<LanguageModel> languages = [
  //   LanguageModel(imageUrl: Images.english, languageName: 'English', countryCode: 'US', languageCode: 'en'),
  //   LanguageModel(imageUrl: Images.arabic, languageName: 'عربى', countryCode: 'SA', languageCode: 'ar'),
  //   LanguageModel(imageUrl: Images.spanish, languageName: 'Spanish', countryCode: 'ES', languageCode: 'es'),
  //   LanguageModel(imageUrl: Images.bengali, languageName: 'Bengali', countryCode: 'BN', languageCode: 'bn'),
  // ];

  static List<String> joinDropdown = [
    'join_us',
    'become_a_seller',
    'become_a_delivery_man',
    'join_as_a_rider',
  ];

  // keys
  static const token = 'token';

  ///Rental Type
  static const String hourly = 'hourly';
  static const String distanceWise = 'distance_wise';
  static const String dayWise = 'day_wise';
}

