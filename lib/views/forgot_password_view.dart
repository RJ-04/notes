import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/services/auth/bloc/auth_bloc.dart';
import 'package:project/services/auth/bloc/auth_event.dart';
import 'package:project/services/auth/bloc/auth_state.dart';
import 'package:project/utilities/dialogs/error_dialog.dart';
import '../utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            // ignore: use_build_context_synchronously
            await showErrorDialog(context,
                "We could not reset your password , your email is not verified.");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Center(child: Text("Forgot password"))),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Flexible(flex: 10, child: Container()),
              Center(
                child: SizedBox(
                  width: 350,
                  height: 500,
                  child: Column(children: [
                    const Center(
                      child: Text(
                          "Please enter your registered email to get Password reset link."),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      autofocus: true,
                      controller: _controller,
                      decoration: const InputDecoration(
                          hintText: "Your email adress....!"),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        final email = _controller.text;
                        context
                            .read<AuthBloc>()
                            .add(AuthEventForgotPassword(email));
                      },
                      child: const Center(
                        child: Text("Send password reset link"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(const AuthEventSignOut());
                        },
                        child: const Center(child: Text("Back to login page")))
                  ]),
                ),
              ),
              Flexible(flex: 10, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
