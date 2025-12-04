import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saathpay/providers/auth_provider.dart';
import 'package:saathpay/theme/app_theme.dart';
import 'package:saathpay/widgets/glass_card.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: GlassCard(
              opacity: 0.15,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.fitness_center, size: 80, color: Colors.white),
                    const SizedBox(height: 24),
                    Text(
                      'Gym Manager',
                      style: AppTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your gym with ease',
                      style: AppTheme.bodyMedium,
                    ),
                    const SizedBox(height: 48),
                    if (authProvider.isLoading)
                      const CircularProgressIndicator(color: Colors.white)
                    else
                      ElevatedButton.icon(
                        icon: const Icon(Icons.login),
                        label: const Text('Sign in with Google'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          try {
                            await authProvider.signInWithGoogle();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Login failed: $e')),
                            );
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
