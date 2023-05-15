import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/services/auth/bloc/auth_bloc.dart';
import 'package:project/services/auth/bloc/auth_event.dart';

class EmailVerification extends StatelessWidget {
  const EmailVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Email Verification")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Center(
              child: Text("\n\nWe have sent you a Verification Email")),
          const Center(child: Text("\n\n\nIn case you didn't recieve Email ")),
          Center(
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventSendEmailVerification());
                  },
                  child:
                      const Center(child: Text("\n\nSend Email Verification")),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              children: [
                TextButton(
                    onPressed: () async {
                      context.read<AuthBloc>().add(const AuthEventSignOut());
                    },
                    child: const Text("\n\nRestart")),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
