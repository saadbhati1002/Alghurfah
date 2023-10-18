import 'dart:io';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Provider/CartProvider.dart';
import 'package:eshop_multivendor/Provider/CategoryProvider.dart';
import 'package:eshop_multivendor/Provider/Favourite/UpdateFavProvider.dart';
import 'package:eshop_multivendor/Provider/NotificationProvider.dart';
import 'package:eshop_multivendor/Provider/ProductProvider.dart';
import 'package:eshop_multivendor/Provider/Search/SearchProvider.dart';
import 'package:eshop_multivendor/Provider/UserProvider.dart';
import 'package:eshop_multivendor/Provider/explore_provider.dart';
import 'package:eshop_multivendor/Provider/authenticationProvider.dart';
import 'package:eshop_multivendor/Provider/myWalletProvider.dart';
import 'package:eshop_multivendor/Provider/paymentProvider.dart';
import 'package:eshop_multivendor/Screen/SplashScreen/splash.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/ServiceApp/model/booking_data_model.dart';
import 'package:eshop_multivendor/ServiceApp/model/booking_status_model.dart';
import 'package:eshop_multivendor/ServiceApp/model/category_model.dart';
import 'package:eshop_multivendor/ServiceApp/model/dashboard_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'Helper/String.dart' as helper;
import 'Screen/Language/Demo_Localization.dart';
import 'Screen/PushNotification/PushNotificationService.dart';
import 'Provider/FaqsProvider.dart';
import 'Provider/Favourite/FavoriteProvider.dart';
import 'Provider/ManageAddressProvider.dart';
import 'Provider/Order/OrderProvider.dart';
import 'Provider/Order/UpdateOrderProvider.dart';
import 'Provider/addressProvider.dart';
import 'Provider/chatProvider.dart';
import 'Provider/customerSupportProvider.dart';
import 'Provider/homePageProvider.dart';
import 'Provider/productDetailProvider.dart';
import 'Provider/ReviewGallleryProvider.dart';
import 'Provider/ReviewPreviewProvider.dart';
import 'Provider/Theme.dart';
import 'Provider/SettingProvider.dart';
import 'Provider/faqProvider.dart';
import 'Provider/productListProvider.dart';
import 'Provider/productPrevciewProvider.dart';
import 'Provider/promoCodeProvider.dart';
import 'Provider/pushNotificationProvider.dart';
import 'Provider/sellerDetailProvider.dart';
import 'Provider/systemProvider.dart';
import 'Provider/userWalletProvider.dart';
import 'Provider/writeReviewProvider.dart';
import 'Screen/Dashboard/Dashboard.dart';
import 'firebase_options.dart';
import 'package:eshop_multivendor/ServiceApp/store/app_store.dart';
import 'package:eshop_multivendor/ServiceApp/locale/language_en.dart';
import 'package:eshop_multivendor/ServiceApp/locale/languages.dart';
import 'package:eshop_multivendor/ServiceApp/model/remote_config_data_model.dart';
import 'package:eshop_multivendor/ServiceApp/services/auth_services.dart';
import 'package:eshop_multivendor/ServiceApp/services/chat_services.dart';
import 'package:eshop_multivendor/ServiceApp/services/user_services.dart';
import 'package:eshop_multivendor/ServiceApp/store/filter_store.dart';
import 'package:eshop_multivendor/ServiceApp/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//region Mobx Stores
AppStore appStore = AppStore();
FilterStore filterStore = FilterStore();
//endregion

//region Global Variables
//endregion

//region Global Variables
BaseLanguage language = LanguageEn();
//endregion

//region Services
UserService userService = UserService();
AuthService authService = AuthService();
ChatServices chatServices = ChatServices();
RemoteConfigDataModel remoteConfigDataModel = RemoteConfigDataModel();
//endregion

//region Cached Response Variables for Dashboard Tabs
DashboardResponse? cachedDashboardResponse;
List<BookingData>? cachedBookingList;
List<CategoryData>? cachedCategoryList;
List<BookingStatusResponse>? cachedBookingStatusDropdown;
//endregion

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  if (Firebase.apps.isNotEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  FirebaseMessaging.instance.getInitialMessage();
  initializedDownload();

  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SharedPreferences prefs = await SharedPreferences.getInstance();

  HttpOverrides.global = MyHttpOverrides();
  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN), isInitializing: true);

  int themeModeIndex =
      getIntAsync(THEME_MODE_INDEX, defaultValue: THEME_MODE_SYSTEM);
  if (themeModeIndex == THEME_MODE_LIGHT) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == THEME_MODE_DARK) {
    appStore.setDarkMode(true);
  }

  await appStore.setUseMaterialYouTheme(getBoolAsync(USE_MATERIAL_YOU_THEME),
      isInitializing: true);

  if (appStore.isLoggedIn) {
    await appStore.setUserId(getIntAsync(USER_ID), isInitializing: true);
    await appStore.setFirstName(getStringAsync(FIRST_NAME),
        isInitializing: true);
    await appStore.setLastName(getStringAsync(LAST_NAME), isInitializing: true);
    await appStore.setUserEmail(getStringAsync(USER_EMAIL),
        isInitializing: true);
    await appStore.setUserName(getStringAsync(USERNAME), isInitializing: true);
    await appStore.setContactNumber(getStringAsync(CONTACT_NUMBER),
        isInitializing: true);
    await appStore.setUserProfile(getStringAsync(PROFILE_IMAGE),
        isInitializing: true);
    await appStore.setCountryId(getIntAsync(COUNTRY_ID), isInitializing: true);
    await appStore.setStateId(getIntAsync(STATE_ID), isInitializing: true);
    await appStore.setCityId(getIntAsync(COUNTRY_ID), isInitializing: true);
    await appStore.setUId(getStringAsync(UID), isInitializing: true);
    await appStore.setToken(getStringAsync(TOKEN), isInitializing: true);
    await appStore.setAddress(getStringAsync(ADDRESS), isInitializing: true);
    await appStore.setCurrencyCode(getStringAsync(CURRENCY_COUNTRY_CODE),
        isInitializing: true);
    await appStore.setCurrencyCountryId(getStringAsync(CURRENCY_COUNTRY_ID),
        isInitializing: true);
    await appStore.setCurrencySymbol(getStringAsync(CURRENCY_COUNTRY_SYMBOL),
        isInitializing: true);
    await appStore.setPrivacyPolicy(getStringAsync(PRIVACY_POLICY),
        isInitializing: true);
    await appStore.setLoginType(getStringAsync(LOGIN_TYPE),
        isInitializing: true);
    await appStore.setPlayerId(getStringAsync(PLAYERID), isInitializing: true);
    await appStore.setTermConditions(getStringAsync(TERM_CONDITIONS),
        isInitializing: true);
    await appStore.setInquiryEmail(getStringAsync(INQUIRY_EMAIL),
        isInitializing: true);
    await appStore.setHelplineNumber(getStringAsync(HELPLINE_NUMBER),
        isInitializing: true);
    await appStore.setEnableUserWallet(getBoolAsync(ENABLE_USER_WALLET),
        isInitializing: true);
  }
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (BuildContext context) {
        String? theme = prefs.getString(helper.APP_THEME);

        if (theme == helper.DARK) {
          helper.ISDARK = 'true';
        } else if (theme == helper.LIGHT) {
          helper.ISDARK = 'false';
        }

        if (theme == null || theme == '' || theme == helper.DEFAULT_SYSTEM) {
          prefs.setString(helper.APP_THEME, helper.DEFAULT_SYSTEM);
          var brightness = SchedulerBinding.instance.window.platformBrightness;
          helper.ISDARK = (brightness == Brightness.dark).toString();

          return ThemeNotifier(ThemeMode.system);
        }

        return ThemeNotifier(
            theme == helper.LIGHT ? ThemeMode.light : ThemeMode.dark);
      },
      child: MyApp(sharedPreferences: prefs),
    ),
  );
}

Future<void> initializedDownload() async {
  await FlutterDownloader.initialize(debug: false);
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  late SharedPreferences sharedPreferences;

  MyApp({Key? key, required this.sharedPreferences}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    if (mounted) {
      setState(
        () {
          _locale = locale;
        },
      );
    }
  }

  @override
  void didChangeDependencies() {
    getLocale().then(
      (locale) {
        if (mounted) {
          setState(
            () {
              _locale = locale;
            },
          );
        }
      },
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    if (_locale == null) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color?>(
            colors.primary,
          ),
        ),
      );
    } else {
      return MultiProvider(
        providers: [
          Provider<SettingProvider>(
            create: (context) => SettingProvider(widget.sharedPreferences),
          ),
          ChangeNotifierProvider<UserProvider>(
              create: (context) => UserProvider()),
          ChangeNotifierProvider<HomePageProvider>(
              create: (context) => HomePageProvider()),
          ChangeNotifierProvider<CategoryProvider>(
              create: (context) => CategoryProvider()),
          ChangeNotifierProvider<ProductDetailProvider>(
              create: (context) => ProductDetailProvider()),
          ChangeNotifierProvider<FavoriteProvider>(
              create: (context) => FavoriteProvider()),
          ChangeNotifierProvider<OrderProvider>(
              create: (context) => OrderProvider()),
          ChangeNotifierProvider<CartProvider>(
              create: (context) => CartProvider()),
          ChangeNotifierProvider<ExploreProvider>(
              create: (context) => ExploreProvider()),
          ChangeNotifierProvider<ProductProvider>(
              create: (context) => ProductProvider()),
          ChangeNotifierProvider<FaqsProvider>(
              create: (context) => FaqsProvider()),
          ChangeNotifierProvider<PromoCodeProvider>(
              create: (context) => PromoCodeProvider()),
          ChangeNotifierProvider<SystemProvider>(
              create: (context) => SystemProvider()),
          ChangeNotifierProvider<ThemeProvider>(
              create: (context) => ThemeProvider()),
          ChangeNotifierProvider<ProductListProvider>(
              create: (context) => ProductListProvider()),
          ChangeNotifierProvider<AuthenticationProvider>(
              create: (context) => AuthenticationProvider()),
          ChangeNotifierProvider<FaQProvider>(
              create: (context) => FaQProvider()),
          ChangeNotifierProvider<ReviewGallaryProvider>(
              create: (context) => ReviewGallaryProvider()),
          ChangeNotifierProvider<ReviewPreviewProvider>(
              create: (context) => ReviewPreviewProvider()),
          ChangeNotifierProvider<UpdateFavProvider>(
              create: (context) => UpdateFavProvider()),
          ChangeNotifierProvider<UserTransactionProvider>(
              create: (context) => UserTransactionProvider()),
          ChangeNotifierProvider<MyWalletProvider>(
              create: (context) => MyWalletProvider()),
          ChangeNotifierProvider<PaymentProvider>(
              create: (context) => PaymentProvider()),
          ChangeNotifierProvider<SellerDetailProvider>(
              create: (context) => SellerDetailProvider()),
          ChangeNotifierProvider<SearchProvider>(
              create: (context) => SearchProvider()),
          ChangeNotifierProvider<PushNotificationProvider>(
              create: (context) => PushNotificationProvider()),
          ChangeNotifierProvider<NotificationProvider>(
              create: (context) => NotificationProvider()),
          ChangeNotifierProvider<ManageAddrProvider>(
              create: (context) => ManageAddrProvider()),
          ChangeNotifierProvider<UpdateOrdProvider>(
              create: (context) => UpdateOrdProvider()),
          ChangeNotifierProvider<WriteReviewProvider>(
              create: (context) => WriteReviewProvider()),
          ChangeNotifierProvider<AddressProvider>(
              create: (context) => AddressProvider()),
          ChangeNotifierProvider<CustomerSupportProvider>(
              create: (context) => CustomerSupportProvider()),
          ChangeNotifierProvider<ProductPreviewProvider>(
              create: (context) => ProductPreviewProvider()),
          ChangeNotifierProvider<ChatProvider>(
              create: (context) => ChatProvider()),
        ],
        child: MaterialApp(
          locale: Locale(appStore.selectedLanguageCode),
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('zh', 'CN'),
            Locale('es', 'ES'),
            Locale('hi', 'IN'),
            Locale('fr', 'FR'),
            Locale('ar', 'DZ'),
            Locale('ru', 'RU'),
            Locale('ja', 'JP'),
            Locale('de', 'DE'),
          ],
          localizationsDelegates: const [
            DemoLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale!.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          title: appName,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: colors.primary_app,
            ).copyWith(
              secondary: colors.darkIcon,
              brightness: Brightness.light,
            ),
            canvasColor: Theme.of(context).colorScheme.lightWhite,
            cardColor: Theme.of(context).colorScheme.white,
            dialogBackgroundColor: Theme.of(context).colorScheme.white,
            iconTheme: Theme.of(context).iconTheme.copyWith(
                  color: colors.primary,
                ),
            primarySwatch: colors.primary_app,
            primaryColor: Theme.of(context).colorScheme.lightWhite,
            fontFamily: 'ubuntu',
            brightness: Brightness.light,
            textTheme: TextTheme(
              titleLarge: TextStyle(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.w600,
              ),
              titleMedium: TextStyle(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.bold,
              ),
            ).apply(
              bodyColor: Theme.of(context).colorScheme.fontColor,
            ),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => const Splash(),
            '/home': (context) => const Dashboard(),
          },
          darkTheme: ThemeData(
            canvasColor: colors.darkColor,
            cardColor: colors.darkColor2,
            dialogBackgroundColor: colors.darkColor2,
            primaryColor: colors.darkColor,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: colors.darkIcon,
              selectionColor: colors.darkIcon,
              selectionHandleColor: colors.darkIcon,
            ),
            fontFamily: 'ubuntu',
            brightness: Brightness.dark,
            hintColor: colors.white10,
            iconTheme: Theme.of(context).iconTheme.copyWith(
                  color: colors.secondary,
                ),
            textTheme: TextTheme(
              titleLarge: TextStyle(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.w600,
              ),
              titleMedium: TextStyle(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.bold,
              ),
            ).apply(
              bodyColor: Theme.of(context).colorScheme.fontColor,
            ),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: colors.primary_app,
            ).copyWith(
              secondary: colors.darkIcon,
              brightness: Brightness.dark,
            ),
            checkboxTheme: CheckboxThemeData(
              fillColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return null;
                }
                if (states.contains(MaterialState.selected)) {
                  return colors.primary;
                }
                return null;
              }),
            ),
            radioTheme: RadioThemeData(
              fillColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return null;
                }
                if (states.contains(MaterialState.selected)) {
                  return colors.primary;
                }
                return null;
              }),
            ),
            switchTheme: SwitchThemeData(
              thumbColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return null;
                }
                if (states.contains(MaterialState.selected)) {
                  return colors.primary;
                }
                return null;
              }),
              trackColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return null;
                }
                if (states.contains(MaterialState.selected)) {
                  return colors.primary;
                }
                return null;
              }),
            ),
          ),
          themeMode: themeNotifier.getThemeMode(),
        ),
      );
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
