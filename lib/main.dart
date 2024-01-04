import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:raffle/constant/variable.dart';
import 'package:raffle/page/notifications.dart';
import 'package:raffle/page/tickets.dart';
import 'package:raffle/screen/home.dart';

void main() {
  // Set the system UI overlay style globally
  SystemChrome.setSystemUIOverlayStyle(system);
  runApp(const MyApp());
}

const MaterialColor primaryColor = MaterialColor(
  0xFF25D366,
  <int, Color>{
    50: Color(0xFFE5F9ED),
    100: Color(0xFFB9F0C7),
    200: Color(0xFF8CEA9F),
    300: Color(0xFF5CE47B),
    400: Color(0xFF39DC5F),
    500: Color(0xFF25D366),
    600: Color(0xFF1EB95F),
    700: Color(0xFF188F52),
    800: Color(0xFF126647),
    900: Color(0xFF0A362E),
  },
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Check if the app is running on the web
    const bool isWeb = kIsWeb;

    // Set the maximum width for the web app
    const double maxWidth = 500.0;

    // Wrap the MaterialApp with the Center and LayoutBuilder widgets
    Widget app = isWeb
        ? Container(
            color: Colors.black,
            child: Center(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double appWidth = constraints.maxWidth < maxWidth
                      ? constraints.maxWidth
                      : maxWidth;

                  return SizedBox(
                    width: appWidth,
                    child: buildMaterialApp(),
                  );
                },
              ),
            ),
          )
        : buildMaterialApp();
    final RaffleProvider raffleProvider = RaffleProvider();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RaffleProvider>(
          create: (_) => raffleProvider,
        ),
      ],
      child: app,
    );
  }

  MaterialApp buildMaterialApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        focusColor: const Color(0xFF188F52),
        unselectedWidgetColor: Colors.white,
        cardColor: const Color(0xFF188F52),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: primaryColor,
        ),
        appBarTheme: AppBarTheme(
            color: primaryColor.shade700, foregroundColor: Colors.white),
      ),
      home: const HomeScreen(),
      routes: {
        '/myticket': (context) => const MyTicket(),
        '/notifications': (context) => const NotificationsPage(),
      },
    );
  }
}
