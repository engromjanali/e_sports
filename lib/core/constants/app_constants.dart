
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

  static const String baseUrl = 'https://e-sports-backend-2ex9.vercel.app';

  // Supabase
  static const String supabaseUrl = 'https://ttietyuwaamuiziwzmst.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR0aWV0eXV3YWFtdWl6aXd6bXN0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODEzNjYyNzIsImV4cCI6MjA5Njk0MjI3Mn0.9fDKu8rn7edXyPu1LpGuP2M7ocM6gkD1KiHTTZHKWYs';

  /// auth endpoints
  static const String registationUri = "/api/user/registation";
  static const String loginUri = "/api/user/signin";
  static const String forgetPaasswordUri = "/api/user/forget-password";
  static const String profileUri = "/api/user/profile";
  static const String verifyForgetPasswordOtpUri = "/api/user/forget-password-verify";
  static const String forgetPasswordUri = "/api/user/forget-password";

  // config
  static const String configUri = "/api/user/config";

  // player
  static const String players = "/api/user/players";
  static const String playerStats = "/api/user/player-stats";
  static const String matchEntries = "/api/user/match-entries";
  static const String myRank = "/api/user/my-rank";
  
  // matchs
  static const String homeMatch = "/api/user/home-match";
  static const String matches = "/api/user/matches";

  // news
  static const String news = "/api/user/news";


  // rank (legacy — home spotlight)
  static const String scorerOfTheWeekAndMonth = "/api/user/scorer-of-the-week-and-month";
  static const String playerOfTheWeekAndMonth = "/api/user/player-of-the-week-and-month";
  static const String overAllTopThreePlayer = "/api/user/overall-top-three-player";
  static const String seasonalTopThreePlayer = "/api/user/seasonal-top-three-player";
  static const String overAllTopThreeScorer = "/api/user/overall-top-three-scorer";
  static const String seasonalTopThreeScorer = "/api/user/seasonal-top-three-scorer";

  // rank — server-driven, filtered (type + date range + season/overall)
  static const String rankMvp = "/api/user/rank/mvp";
  static const String rankList = "/api/user/rank/list";

  // rank — legacy server-driven MVP cards (period × player/scorer)
  static const String weekMvpPlayer    = "/api/user/rank/week-mvp-player";
  static const String weekMvpScorer    = "/api/user/rank/week-mvp-scorer";
  static const String monthMvpPlayer   = "/api/user/rank/month-mvp-player";
  static const String monthMvpScorer   = "/api/user/rank/month-mvp-scorer";
  static const String seasonMvpPlayer  = "/api/user/rank/season-mvp-player";
  static const String seasonMvpScorer  = "/api/user/rank/season-mvp-scorer";

  // rank — server-driven list sections (type param: player|scorer)
  static const String weeklyRanks     = "/api/user/rank/weekly-ranks";
  static const String monthlyRanks    = "/api/user/rank/monthly-ranks";
  static const String seasonStandings = "/api/user/rank/season-standings";

  // rank — player detail
  static const String playerRankDetail = "/api/user/rank/player-detail";

  // faq
  static const String faqs = "/api/user/faqs";

  // hall of fame
  static const String hallOfFame = "/api/user/hall-of-fame";

  // current active season
  static const int currentSeason = 4;

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
  static const seasonId = 'x_season_id';

  ///Rental Type
  static const String hourly = 'hourly';
  static const String distanceWise = 'distance_wise';
  static const String dayWise = 'day_wise';

  // 
  static const int offsetSize = 10;
}

