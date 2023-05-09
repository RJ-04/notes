import 'package:flutter/material.dart' show immutable;
import 'package:project/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState(
      {required this.isLoading, this.loadingText = " Please wait a moment"});
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({super.loadingText, required super.isLoading});
}

class AuthStateSigningUp extends AuthState {
  final Exception? exception;
  const AuthStateSigningUp(
      {super.loadingText, required super.isLoading, required this.exception});
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPassword(
      {required this.exception,
      required this.hasSentEmail,
      required super.isLoading});
}

class AuthStateSignedIn extends AuthState {
  final AuthUser user;
  const AuthStateSignedIn(
      {super.loadingText, required super.isLoading, required this.user});
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification(
      {super.loadingText, required super.isLoading});
}

class AuthStateSignedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateSignedOut(
      {required this.exception, super.loadingText, required super.isLoading});

  @override
  List<Object?> get props => [exception, isLoading];
}
