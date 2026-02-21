import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uminom/features/auth/presentation/controllers/auth_controller.dart';
import 'package:uminom/features/auth/presentation/widgets/social_login_button.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _cardFade;
  late final Animation<Offset> _cardSlide;
  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _logoSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
          ),
        );
    _cardFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.75, curve: Curves.easeOut),
    );
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.25, 0.75, curve: Curves.easeOut),
          ),
        );
    _buttonFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
    );
    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
          ),
        );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    await ref.read(authControllerProvider.notifier).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for errors
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.error.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'PT Sans',
              ),
            ),
            backgroundColor: const Color(0xFFFF5252),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(20),
          ),
        );
      }
    });

    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F5F9),
      body: Stack(
        children: [
          // Background Gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.55,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                ),
              ),
            ),
          ),
          // Decorative circles
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.25,
            left: -120,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  SlideTransition(
                    position: _logoSlide,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: Center(
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF0072FF,
                                ).withValues(alpha: 0.3),
                                blurRadius: 40,
                                offset: const Offset(0, 20),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.water_drop_rounded,
                              size: 70,
                              color: Color(0xFF0072FF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  SlideTransition(
                    position: _cardSlide,
                    child: FadeTransition(
                      opacity: _cardFade,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 32,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(36),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 40,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Column(
                          children: const [
                            Text(
                              'Uminom',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E293B),
                                letterSpacing: -0.5,
                                fontFamily: 'PT Sans',
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Build a steady hydration routine with smart reminders and quick logging.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF64748B),
                                height: 1.6,
                                fontFamily: 'PT Sans',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                  SlideTransition(
                    position: _buttonSlide,
                    child: FadeTransition(
                      opacity: _buttonFade,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF0072FF,
                              ).withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: SocialLoginButton(
                          text: 'Continue with Google',
                          iconPath: 'assets/google.png',
                          isLoading: isLoading,
                          onPressed: _handleGoogleSignIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
