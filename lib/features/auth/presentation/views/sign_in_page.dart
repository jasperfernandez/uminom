import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/social_login_button.dart';
import '../../../../core/providers/auth_provider.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    final authService = ref.read(authServiceProvider);
    final userCredential = await authService.signInWithGoogle();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (userCredential == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to sign in. Please try again.',
              style: TextStyle(fontFamily: 'PT Sans'),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5F4FC), // Very light blue
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 3),
              // App logo / graphic
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF46A5EA).withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.water_drop_rounded,
                      size: 72,
                      color: Color(0xFF46A5EA), // Sky blue
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              const Text(
                'Welcome to Uminom',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF46A5EA),
                  fontFamily: 'PT Sans',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Log your daily water intake and stay hydrated for better health.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                  fontFamily: 'PT Sans',
                ),
              ),
              const Spacer(flex: 3),
              SocialLoginButton(
                text: 'Continue with Google',
                iconPath: 'assets/google.png',
                isLoading: _isLoading,
                onPressed: _handleGoogleSignIn,
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
