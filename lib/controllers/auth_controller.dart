import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth/auth_service.dart';
import '../providers/auth_providers.dart';

// Auth controller for handling authentication actions
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthControllerState>((ref) {
      final authService = ref.watch(authServiceProvider);
      return AuthController(authService, ref);
    });

class AuthController extends StateNotifier<AuthControllerState> {
  final AuthService _authService;
  final Ref _ref;

  AuthController(this._authService, this._ref)
    : super(const AuthControllerState.idle());

  Future<bool> signInWithEmail({
    required String email,
    required String password,
    required context,
    bool rememberMe = false,
  }) async {
    state = const AuthControllerState.loading();

    try {
      final success = await _authService.login(
        email: email,
        password: password,
        context: context,
        rememberMe: rememberMe,
      );

      if (success) {
        state = const AuthControllerState.success();
        // Refresh auth state to trigger UI update
        _ref.refresh(firebaseUserProvider);
        return true;
      } else {
        state = const AuthControllerState.error('Login failed');
        return false;
      }
    } catch (e) {
      state = AuthControllerState.error(e.toString());
      return false;
    }
  }

  Future<bool> signInWithGoogle({required context}) async {
    state = const AuthControllerState.loading();

    try {
      final success = await _authService.signInWithGoogle(context: context);

      if (success) {
        state = const AuthControllerState.success();
        _ref.refresh(firebaseUserProvider);
        return true;
      } else {
        state = const AuthControllerState.error('Google sign-in failed');
        return false;
      }
    } catch (e) {
      state = AuthControllerState.error(e.toString());
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String role,
    required context,
  }) async {
    state = const AuthControllerState.loading();

    try {
      final success = await _authService.signUp(
        email: email,
        password: password,
        // role: role,
        context: context,
      );

      if (success) {
        state = const AuthControllerState.success();
        _ref.refresh(firebaseUserProvider);
        return true;
      } else {
        state = const AuthControllerState.error('Sign up failed');
        return false;
      }
    } catch (e) {
      state = AuthControllerState.error(e.toString());
      return false;
    }
  }

  Future<void> signOut({required context}) async {
    state = const AuthControllerState.loading();

    try {
      await _authService.signOut(context);
      state = const AuthControllerState.success();
      _ref.refresh(firebaseUserProvider);
    } catch (e) {
      state = AuthControllerState.error(e.toString());
    }
  }

  Future<bool> saveProfileData({
    required String name,
    required String role,
    String? photoURL,
    required double weight,
    required double height,
    required String gender,
    required String dateOfBirth,
    required BuildContext context,
  }) async {
    state = const AuthControllerState.loading();

    try {
      final success = await _authService.saveProfileData(
        name: name,
        role: role,
        photoURL: photoURL,
        weight: weight,
        height: height,
        gender: gender,
        dateOfBirth: dateOfBirth,
        context: context,
      );

      if (success) {
        state = const AuthControllerState.success();
        // Refresh both providers to update UI
        _ref.refresh(firebaseUserProvider);
        _ref.refresh(currentUserProvider);
        return true;
      } else {
        state = const AuthControllerState.error('Failed to save profile data');
        return false;
      }
    } catch (e) {
      state = AuthControllerState.error(e.toString());
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    state = const AuthControllerState.loading();

    try {
      final success = await _authService.resetPassword(
        email: email,
        context: context,
      );

      if (success) {
        state = const AuthControllerState.success();
        return true;
      } else {
        state = const AuthControllerState.error('Password reset failed');
        return false;
      }
    } catch (e) {
      state = AuthControllerState.error(e.toString());
      return false;
    }
  }

  void clearError() {
    state = const AuthControllerState.idle();
  }
}

// Auth controller state
class AuthControllerState {
  final AuthControllerStatus status;
  final String? error;

  const AuthControllerState._({required this.status, this.error});

  const AuthControllerState.idle() : this._(status: AuthControllerStatus.idle);
  const AuthControllerState.loading()
    : this._(status: AuthControllerStatus.loading);
  const AuthControllerState.success()
    : this._(status: AuthControllerStatus.success);
  const AuthControllerState.error(String error)
    : this._(status: AuthControllerStatus.error, error: error);

  bool get isLoading => status == AuthControllerStatus.loading;
  bool get isSuccess => status == AuthControllerStatus.success;
  bool get isError => status == AuthControllerStatus.error;
  bool get isIdle => status == AuthControllerStatus.idle;
}

enum AuthControllerStatus { idle, loading, success, error }
