import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

import '../../utils/validators.dart';

import '../../widgets/custom_textfield.dart';

import '../home/home_screen.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();

}

class _LoginScreenState
    extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authProvider =
        Provider.of<AuthProvider>(context);

    return Scaffold(

      appBar: AppBar(
        title: const Text('Login'),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(16),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              CustomTextField(
                controller:
                    emailController,
                hint: 'Email',
                validator:
                    Validators
                        .validateEmail,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller:
                    passwordController,
                hint: 'Password',
                obscureText: true,
                validator:
                    Validators
                        .validatePassword,
              ),

              const SizedBox(height: 20),

              authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(

                      onPressed: () async {

                        if (_formKey
                            .currentState!
                            .validate()) {

                          final success =
                              await authProvider
                                  .login(
                            email:
                                emailController
                                    .text
                                    .trim(),

                            password:
                                passwordController
                                    .text
                                    .trim(),
                          );

                          if (success &&
                              context.mounted) {

                            Navigator.pushReplacement(

                              context,

                              MaterialPageRoute(
                                builder: (_) =>
                                    const HomeScreen(),
                              ),

                            );
                          }
                        }
                      },

                      child:
                          const Text('Login'),
                    ),

              TextButton(

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          const RegisterScreen(),
                    ),

                  );
                },

                child: const Text(
                  'Create Account',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}