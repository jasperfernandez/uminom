import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uminom/features/auth/domain/repositories/auth_repository.dart';
import 'package:uminom/features/auth/presentation/providers/auth_provider.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<void> {
  late final AuthRepository _repository;

  @override
  Future<void> build() async {
    _repository = ref.read(authRepositoryProvider);
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return _repository.signInWithGoogle();
    });
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AsyncData(null);
  }
}
