import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uminom/core/providers/firebase_providers.dart';
import 'package:uminom/core/providers/google_sign_in_provider.dart';
import 'package:uminom/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:uminom/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:uminom/features/auth/domain/repositories/auth_repository.dart';

final authRemoteDataSourceProvider = Provider((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final googleSignIn = ref.watch(googleSignInProvider);
  return AuthRemoteDataSource(firebaseAuth, googleSignIn);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remote);
});

final authStateProvider = StreamProvider<User?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges();
});
