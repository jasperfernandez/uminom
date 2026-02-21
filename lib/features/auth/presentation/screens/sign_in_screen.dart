import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uminom/features/auth/presentation/controllers/auth_controller.dart';
import 'package:uminom/features/auth/presentation/widgets/social_login_button.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInScreen> {
  Future<void> _handleGoogleSignIn() async {
    await ref.read(authControllerProvider.notifier).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for errors
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });

    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

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
                isLoading: isLoading,
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
