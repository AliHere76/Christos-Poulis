import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/auth/auth_service.dart';

// AuthService provider - singleton
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Current Firebase User stream provider
final firebaseUserProvider = StreamProvider<firebase_auth.User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Current app User provider (with profile data)
final currentUserProvider = FutureProvider<User?>((ref) async {
  final firebaseUser = ref.watch(firebaseUserProvider);

  return firebaseUser.when(
    data: (user) async {
      if (user == null) return null;

      final authService = ref.watch(authServiceProvider);
      return await authService.fetchUserData();
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// Authentication state provider
final authStateProvider = Provider<AuthState>((ref) {
  final firebaseUserAsync = ref.watch(firebaseUserProvider);
  final currentUserAsync = ref.watch(currentUserProvider);

  return firebaseUserAsync.when(
    data: (firebaseUser) {
      if (firebaseUser == null) {
        return const AuthState.unauthenticated();
      }

      return currentUserAsync.when(
        data: (user) {
          if (user == null || user.displayName.isEmpty) {
            return const AuthState.needsProfileSetup();
          }
          return AuthState.authenticated(user);
        },
        loading: () => const AuthState.loading(),
        error: (error, _) => AuthState.error(error.toString()),
      );
    },
    loading: () => const AuthState.loading(),
    error: (error, _) => AuthState.error(error.toString()),
  );
});

// Auth state class
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState._({required this.status, this.user, this.error});

  const AuthState.loading() : this._(status: AuthStatus.loading);
  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);
  const AuthState.needsProfileSetup()
    : this._(status: AuthStatus.needsProfileSetup);
  const AuthState.authenticated(User user)
    : this._(status: AuthStatus.authenticated, user: user);
  const AuthState.error(String error)
    : this._(status: AuthStatus.error, error: error);
}

enum AuthStatus {
  loading,
  authenticated,
  unauthenticated,
  needsProfileSetup,
  error,
}
