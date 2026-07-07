import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

import '../auth/login_screen.dart';

import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  @override
  void initState() {

    super.initState();

    initializeApp();
  }

  Future<void> initializeApp() async {

    final authProvider =
        context.read<AuthProvider>();

    await Future.delayed(
      const Duration(seconds: 2),
    );

    await authProvider.autoLogin();

    if (!mounted) return;

    navigateUser(
      authProvider.isAuthenticated,
    );
  }

  void navigateUser(
    bool isAuthenticated,
  ) {

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) =>
            isAuthenticated
                ? const HomeScreen()
                : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        padding:
            const EdgeInsets.symmetric(
          horizontal: 24,
        ),

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            // APP ICON
            Container(

              padding:
                  const EdgeInsets.all(24),

              decoration: BoxDecoration(

                color:
                    Theme.of(context)
                        .primaryColor
                        .withOpacity(0.1),

                shape: BoxShape.circle,
              ),

              child: Icon(

                Icons.note_alt_rounded,

                size: 70,

                color:
                    Theme.of(context)
                        .primaryColor,
              ),
            ),

            const SizedBox(height: 32),

            // APP TITLE
            Text(

              'Notes App',

              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(

                    fontWeight:
                        FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 10),

            Text(

              'Organize your thoughts beautifully',

              textAlign: TextAlign.center,

              style: TextStyle(

                fontSize: 16,

                color:
                    Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 50),

            // LOADER
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}