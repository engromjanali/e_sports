

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    usePathUrlStrategy();
  }

  if(GetPlatform.isWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(
        apiKey: "AIzaSyD0Z911mOoWCVkeGdjhIKwWFPRgvd6ZyAw",
        authDomain: "stackmart-500c7.firebaseapp.com",
        projectId: "stackmart-500c7",
        storageBucket: "stackmart-500c7.appspot.com",
        messagingSenderId: "491987943015",
        appId: "1:491987943015:web:d8bc7ab8dbc9991c8f1ec2"
    ));
  } else if(GetPlatform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCc3OCd5I2xSlnftZ4bFAbuCzMhgQHLivA",
        appId: "1:491987943015:android:a6fb4303cc4bf3d18f1ec2",
        messagingSenderId: "491987943015",
        projectId: "stackmart-500c7",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  Map<String, Map<String, String>> languages = await di.init();

  NotificationBodyModel? body;
  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        body = NotificationHelper.convertNotification(remoteMessage.data);
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  }catch(_) {}

  if (ResponsiveHelper.isWeb()) {
    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: "380903914182154",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }

  runApp(MyApp(languages: languages, body: body));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBodyModel? body;
  const MyApp({super.key, required this.languages, required this.body});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  String? deeplinkRoute;
  String? _initialRoute;

  @override
  void initState() {
    super.initState();

    if(!GetPlatform.isWeb) {
      _initAppLinks();
    }

    _route();
    
    _initialRoute = GetPlatform.isWeb ? RouteHelper.getInitialRoute() : RouteHelper.getSplashRoute(widget.body, deeplinkRoute);

  }

  void _initAppLinks() async {
    _appLinks = AppLinks();

    // Listen for any subsequent incoming links
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        if (kDebugMode) {
          printer('=======Received URI: $uri and previous deeplinkRoute: ${Get.find<SplashController>().deeplinkRoute}');
        }
        LinkConverter.convertDeepLink(uri);
      }
    }, onError: (err) {
      if (kDebugMode) {
        printer('catch Error in initAppLinksStream: $err');
      }
    });
  }

  void _route() async {
    if(GetPlatform.isWeb) {
       Get.find<SplashController>().initSharedData();
      if(AddressHelper.getUserAddressFromSharedPref() != null && AddressHelper.getUserAddressFromSharedPref()!.zoneIds == null) {
        Get.find<AuthController>().clearSharedAddress();
      }

      if(!AuthHelper.isLoggedIn() && !AuthHelper.isGuestLoggedIn()) {
        await Get.find<AuthController>().guestLogin();
      }

      if((AuthHelper.isLoggedIn() || AuthHelper.isGuestLoggedIn()) && Get.find<SplashController>().cacheModule != null) {
        Get.find<CartController>().getCartDataOnline();
      }

      Get.find<SplashController>().getConfigData(loadLandingData: (GetPlatform.isWeb && AddressHelper.getUserAddressFromSharedPref() == null), fromMainFunction: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          return (GetPlatform.isWeb && splashController.configModel == null) ? const SizedBox() : GetMaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            navigatorKey: Get.key,
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
            ),
            theme: themeController.darkTheme ? dark() : light(),
            locale: localizeController.locale,
            translations: Messages(languages: widget.languages),
            fallbackLocale: Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode),
            initialRoute: _initialRoute,
            getPages: RouteHelper.routes,
            defaultTransition: GetPlatform.isWeb ? Transition.fadeIn : Transition.topLevel,
            transitionDuration: const Duration(milliseconds: 700),
            builder: (BuildContext context, widget) {
              return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)), child: Material(
                child: SafeArea(
                  top: false, bottom: GetPlatform.isAndroid,
                  child: Stack(children: [
                    widget!,

                    GetBuilder<SplashController>(builder: (splashController){
                      if(!splashController.savedCookiesData && !splashController.getAcceptCookiesStatus(splashController.configModel != null ? splashController.configModel!.cookiesText! : '')){
                        return ResponsiveHelper.isWeb() ? const Align(alignment: Alignment.bottomCenter, child: CookiesView()) : const SizedBox();
                      }else{
                        return const SizedBox();
                      }
                    })
                  ]),
                ),
              ));
            },
          );
        });
      });
    });
  }
}

