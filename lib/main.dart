import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rajniti_sathi/screens/home_screen.dart';
import 'package:rajniti_sathi/screens/language_screen.dart';
import 'package:rajniti_sathi/screens/splash_screen.dart';
import 'package:rajniti_sathi/utils/app_colors.dart';
import 'package:rajniti_sathi/utils/localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _configureSystemUi();
  final controller = await AppController.create();
  runApp(RajnitiSathiApp(controller: controller));
  _secureScreen();
}

void _configureSystemUi() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

Future<void> _secureScreen() async {
  if (!Platform.isAndroid) {
    return;
  }

  try {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  } on PlatformException {
    // Continue boot even if the secure flag cannot be set on a device.
  }
}

class RajnitiSathiApp extends StatelessWidget {
  const RajnitiSathiApp({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Rajniti Sathi',
          locale: Locale(controller.languageCode),
          supportedLocales: const [Locale('en'), Locale('hi')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.textPrimary,
              centerTitle: false,
              elevation: 0,
              scrolledUnderElevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
                systemNavigationBarColor: AppColors.background,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
            ),
            cardTheme: CardThemeData(
              elevation: 8,
              color: Colors.white,
              shadowColor: Color(0x1FFF4D00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            chipTheme: ChipThemeData(
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              secondaryLabelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              side: const BorderSide(color: AppColors.border),
            ),
          ),
          home: SplashScreen(controller: controller),
          routes: {
            HomeScreen.routeName: (_) => HomeScreen(controller: controller),
            LanguageScreen.routeName: (_) => LanguageScreen(controller: controller),
          },
        );
      },
    );
  }
}

class AppController extends ChangeNotifier {
  AppController._(this._appVersion)
      : _posters = const [
          PosterItem(
            id: 'poster-1',
            assetPath: 'assets/posters/p1.jpg',
            userName: 'Suraj',
            userImagePath: 'assets/user.png',
            imageOffset: Offset(99999, 99999),
            textColor: Colors.white,
            showNameBackground: true,
            imageAspectRatio: 1282 / 1600,
          ),
          PosterItem(
            id: 'poster-2',
            assetPath: 'assets/posters/p2.jpg',
            userName: 'Suraj',
            userImagePath: 'assets/user.png',
            imageOffset: Offset(99999, 99999),
            textColor: AppColors.textPrimary,
            showNameBackground: true,
            imageAspectRatio: 1282 / 1600,
          ),
          PosterItem(
            id: 'poster-3',
            assetPath: 'assets/posters/p3.jpg',
            userName: 'Suraj',
            userImagePath: 'assets/user.png',
            imageOffset: Offset(99999, 99999),
            textColor: Colors.white,
            showNameBackground: true,
            imageAspectRatio: 1282 / 1600,
          ),
          PosterItem(
            id: 'poster-4',
            assetPath: 'assets/posters/p4.jpg',
            userName: 'Suraj',
            userImagePath: 'assets/user.png',
            imageOffset: Offset(99999, 99999),
            textColor: Colors.white,
            showNameBackground: true,
            imageAspectRatio: 1282 / 1600,
          ),
          PosterItem(
            id: 'poster-5',
            assetPath: 'assets/posters/p5.jpg',
            userName: 'Suraj',
            userImagePath: 'assets/user.png',
            imageOffset: Offset(99999, 99999),
            textColor: Colors.white,
            showNameBackground: true,
            imageAspectRatio: 1282 / 1600,
          ),
          PosterItem(
            id: 'poster-6',
            assetPath: 'assets/posters/p6.jpg',
            userName: 'Suraj',
            userImagePath: 'assets/user.png',
            imageOffset: Offset(99999, 99999),
            textColor: Colors.white,
            showNameBackground: true,
            imageAspectRatio: 2052 / 2560,
          ),
        ];

  static Future<AppController> create() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version.trim().isEmpty
          ? '1.0.0'
          : packageInfo.version.trim();
      final buildNumber = packageInfo.buildNumber.trim();
      final displayVersion = buildNumber.isEmpty
          ? version
          : '$version+$buildNumber';
      return AppController._(displayVersion);
    } catch (_) {
      return AppController._('1.0.0');
    }
  }

  final List<PosterItem> _posters;
  final String _appVersion;
  String _languageCode = 'en';
  int _selectedDateIndex = 0;

  String get languageCode => _languageCode;
  int get selectedDateIndex => _selectedDateIndex;
  String get appVersion => _appVersion;
  AppLocalizations get localizations => AppLocalizations(_languageCode);
  List<PosterItem> get posters => List.unmodifiable(_posters);

  void updateLanguage(String languageCode) {
    if (_languageCode == languageCode) {
      return;
    }
    _languageCode = languageCode;
    notifyListeners();
  }

  void selectDateIndex(int index) {
    if (_selectedDateIndex == index) {
      return;
    }
    _selectedDateIndex = index;
    notifyListeners();
  }

  void updatePoster({
    required String posterId,
    String? userName,
    Color? textColor,
    bool? showNameBackground,
    Offset? imageOffset,
  }) {
    final index = _posters.indexWhere((poster) => poster.id == posterId);
    if (index == -1) {
      return;
    }

    final currentPoster = _posters[index];
    _posters[index] = currentPoster.copyWith(
      userName: userName,
      textColor: textColor,
      showNameBackground: showNameBackground,
      imageOffset: imageOffset,
    );
    notifyListeners();
  }
}

@immutable
class PosterItem {
  const PosterItem({
    required this.id,
    required this.assetPath,
    required this.userName,
    required this.userImagePath,
    required this.imageOffset,
    required this.textColor,
    required this.showNameBackground,
    required this.imageAspectRatio,
  });

  final String id;
  final String assetPath;
  final String userName;
  final String userImagePath;
  final Offset imageOffset;
  final Color textColor;
  final bool showNameBackground;
  final double imageAspectRatio;

  PosterItem copyWith({
    String? userName,
    Color? textColor,
    bool? showNameBackground,
    Offset? imageOffset,
  }) {
    return PosterItem(
      id: id,
      assetPath: assetPath,
      userName: userName ?? this.userName,
      userImagePath: userImagePath,
      imageOffset: imageOffset ?? this.imageOffset,
      textColor: textColor ?? this.textColor,
      showNameBackground: showNameBackground ?? this.showNameBackground,
      imageAspectRatio: imageAspectRatio,
    );
  }
}
