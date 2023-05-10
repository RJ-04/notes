import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/services/auth/auth_provider.dart';
import 'package:project/services/auth/bloc/auth_event.dart';
import 'package:project/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventShouldSignUp>(
      (event, emit) {
        emit(const AuthStateSigningUp(exception: null, isLoading: false));
      },
    );

    /* forgot password */

    on<AuthEventForgotPassword>(
      (event, emit) async {
        emit(const AuthStateForgotPassword(
            exception: null, hasSentEmail: false, isLoading: false));
        final email = event.email;
        if (email == null) {
          return;
        }

        emit(const AuthStateForgotPassword(
            exception: null, hasSentEmail: false, isLoading: true));

        bool didSendEmail;
        Exception? exception;
        try {
          await provider.sendPasswordReset(toEmail: email);
          didSendEmail = true;
          exception = null;
        } on Exception catch (e) {
          didSendEmail = false;
          exception = e;
        }
        emit(AuthStateForgotPassword(
            exception: exception,
            hasSentEmail: didSendEmail,
            isLoading: false));
      },
    );

    /* email verification */

    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    on<AuthEventSignUp>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          await provider.createUser(email: email, password: password);
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification(
              isLoading: false, loadingText: 'Verifing Email'));
        } on Exception catch (e) {
          emit(AuthStateSigningUp(exception: e, isLoading: false));
        }
      },
    );

    /* initialize */

    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateSignedOut(
              exception: null, isLoading: false, loadingText: 'Loading...'));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification(
              isLoading: false, loadingText: 'Verifing Email'));
        } else {
          emit(AuthStateSignedIn(
              user: user, isLoading: false, loadingText: 'Signing In'));
        }
      },
    );

    /* sign in */

    on<AuthEventSignIn>(
      (event, emit) async {
        emit(const AuthStateSignedOut(
            exception: null, isLoading: true, loadingText: 'Signing In'));
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.signIn(email: email, password: password);
          if (!user.isEmailVerified) {
            emit(const AuthStateSignedOut(exception: null, isLoading: false));
            emit(const AuthStateNeedsVerification(
                isLoading: false, loadingText: 'Verifing Email'));
          } else {
            emit(const AuthStateSignedOut(exception: null, isLoading: false));
            emit(AuthStateSignedIn(
                user: user, isLoading: false, loadingText: 'Signing In'));
          }
        } on Exception catch (e) {
          emit(AuthStateSignedOut(exception: e, isLoading: false));
        }
      },
    );

    /* sign out */
    on<AuthEventSignOut>(
      (event, emit) async {
        try {
          await provider.signOut();
          emit(const AuthStateSignedOut(
              exception: null, isLoading: false, loadingText: "Signing Out"));
        } on Exception catch (e) {
          emit(AuthStateSignedOut(exception: e, isLoading: false));
        }
      },
    );
  }
}
