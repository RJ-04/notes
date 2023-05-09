import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/services/auth/auth_exceptions.dart';
import 'package:project/services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class EmailSignUp extends StatefulWidget {
  const EmailSignUp({super.key});

  @override
  State<EmailSignUp> createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateSigningUp) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, "Weak password");
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, "Email already in use");
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, "Invalid Email");
          } else if (state.exception is GeneralAuthException) {
            await showErrorDialog(context, "Failed to register");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Sign Up")),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _email,
                autocorrect: false,
                enableSuggestions: false,
                autofillHints: null,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                decoration: const InputDecoration(
                    hintText: " Email (Jane1975@gmail.com)"),
              ),
              TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autofillHints: null,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      hintText: " Password (doe_001#JD)")),
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        context
                            .read<AuthBloc>()
                            .add(AuthEventSignUp(email, password));
                      },
                      child: const Text("\n\nSign Up"),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const AuthEventSignOut());
                      },
                      child:
                          const Text("\n\n(Already have a account? ) Sign In"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
