import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uminom/core/router/routes.dart';
import 'package:uminom/features/auth/presentation/providers/auth_provider.dart';
import 'package:uminom/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:uminom/features/home/presentation/screens/home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/sign-in',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/sign-in';

      if (!isLoggedIn && !isLoggingIn) {
        return '/sign-in';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/sign-in',
        name: signInRoute,
        builder: (context, state) => SignInScreen(),
      ),

      GoRoute(
        path: '/home',
        name: homeRoute,
        builder: (context, state) => HomeScreen(),
      ),
    ],
  );
});
