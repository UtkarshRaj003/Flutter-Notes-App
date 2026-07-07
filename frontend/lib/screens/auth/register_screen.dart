import 'package:flutter/material.dart';
import 'package:frontend/screens/auth/login_screen.dart';

import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

import '../../utils/validators.dart';

import '../../widgets/custom_textfield.dart';

import '../home/home_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final nameController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              CustomTextField(
                controller: nameController,
                hint: 'Name',
                validator: Validators.validateName,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: emailController,
                hint: 'Email',
                validator: Validators.validateEmail,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: passwordController,
                hint: 'Password',
                obscureText: true,
                validator: Validators.validatePassword,
              ),

              const SizedBox(height: 20),

              authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final success = await authProvider.register(
                            name: nameController.text.trim(),

                            email: emailController.text.trim(),

                            password: passwordController.text.trim(),
                          );

                          if (success && context.mounted) {
                            Navigator.pushReplacement(
                              context,

                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          }
                        }
                      },

                      child: const Text('Register'),
                    ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },

                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
