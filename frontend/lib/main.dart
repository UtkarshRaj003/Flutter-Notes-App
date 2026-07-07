import 'package:flutter/material.dart';
import 'package:frontend/providers/tag_provider.dart';
import 'package:provider/provider.dart';

import 'constants/app_theme.dart';

import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/notes_provider.dart';

import 'screens/splash/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        ChangeNotifierProvider(create: (_) => NotesProvider()),

        ChangeNotifierProvider(create: (_) => TagProvider()),
      ],

      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,

            debugShowCheckedModeBanner: false,

            title: 'Notes App',

            theme: AppTheme.lightTheme,

            darkTheme: AppTheme.darkTheme,

            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,

            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
