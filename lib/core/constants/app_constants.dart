
class AppConstants {
  static const String appName = '6amMart';
  static const String appVersion = '1.0.0'; ///Flutter sdk 3.41.7

  static const String fontFamily = 'Roboto';
  static const bool payInWevView = false;
  static const int balanceInputLen = 10;
  static const String webHostedUrl = 'https://6ammart-test-web.6amdev.xyz';
  // static const String webHostedUrl = 'https://6ammart-web.6amtech.com';
  static const bool useReactWebsite = false;
  static const bool stopPolylineAnimation = false;
  static const String googleServerClientId = '491987943015-agln6biv84krpnngdphj87jkko7r9lb8.apps.googleusercontent.com';
  static const String pusherBroadcustUrl = '/api/v1/broadcasting/user-auth';

  // static const String baseUrl = 'https://6ammart-dev-testing.6amdev.xyz';
  static const String baseUrl = 'https://6ammart-dev.6amdev.xyz';

  /// end points
  static const String reelListUri = '/api/v1/customer/reels/list';


  /// Shared Key
  static const String theme = '6ammart_theme';

  ///taxi
  static const String taxiSearchHistory = '6ammart_taxi_search_history';
  static const String taxiSearchAddressHistory = '6ammart_taxi_search_address_history';

  static const String prescriptionMediaLibrary = 'prescription_media_library';

  static const String topic = 'all_zone_customer';
  static const String zoneId = 'zoneId';
  static const String operationAreaId = 'operationAreaId';
  static const String moduleId = 'moduleId';
  static const String cacheModuleId = 'cacheModuleId';
  static const String localizationKey = 'X-localization';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String cookiesManagement = 'cookies_management';

  // static List<ChooseUsModel> whyChooseUsList = [
  //   ChooseUsModel(icon: Images.landingTrusted, title: 'trusted_by_customers_and_store_owners'),
  //   ChooseUsModel(icon: Images.landingStores, title: 'thousands_of_stores'),
  //   ChooseUsModel(icon: Images.landingExcellent, title: 'excellent_shopping_experience'),
  //   ChooseUsModel(icon: Images.landingCheckout, title: 'easy_checkout_and_payment_system'),
  // ];

  /// order status..
  static const String pending = 'pending';
  static const String accepted = 'accepted';
  static const String processing = 'processing';
  static const String confirmed = 'confirmed';
  static const String handover = 'handover';
  static const String pickedUp = 'picked_up';
  static const String delivered = 'delivered';
  static const String canceled = 'canceled';
  static const String failed = 'failed';
  static const String refunded = 'refunded';
  static const String returned = 'returned';

  /// Rider_module.
  static const String ongoing = 'ongoing';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';

  ///modules..
  static const String pharmacy = 'pharmacy';
  static const String food = 'food';
  static const String parcel = 'parcel';
  static const String ecommerce = 'ecommerce';
  static const String grocery = 'grocery';
  static const String taxi = 'rental';
  static const String ride = 'ride-share';
  static const String service = 'service';

  ///ride share map zoom
  static const double mapZoom = 20;

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

  ///Rental Type
  static const String hourly = 'hourly';
  static const String distanceWise = 'distance_wise';
  static const String dayWise = 'day_wise';
}
