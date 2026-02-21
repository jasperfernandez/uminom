import 'package:firebase_auth/firebase_auth.dart';
import 'package:uminom/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:uminom/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Stream<User?> authStateChanges() => remote.authStateChanges();

  @override
  Future<User?> signInWithGoogle() {
    return remote.signInWithGoogle();
  }

  @override
  Future<void> signOut() => remote.signOut();
}
