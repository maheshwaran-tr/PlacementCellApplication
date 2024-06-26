import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:placementapp/notification_service.dart';
import 'package:placementapp/push_notifi/home_page.dart';
import 'package:placementapp/splashscreen/splash_screen.dart';
import 'firebase_analytics_service.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().initialize();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      navigatorKey: navigatorKey,
      navigatorObservers: [
        FirebaseAnalyticsObserver(
            analytics: FirebaseAnalyticsService.analytics),
      ],
      routes: {
        '/push-page': (context) => PushHomePage(),
      },
    );
  }
}