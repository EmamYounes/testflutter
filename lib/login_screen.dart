import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_data/login_bloc.dart';
import 'bloc/user_data/login_event.dart';
import 'bloc/user_data/login_state.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacementNamed(context, '/userData');
            }

            if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: state is LoginLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () {
                  context
                      .read<LoginBloc>()
                      .add(LoginWithGoogleEvent());
                },
                child: const Text("Continue with Google"),
              ),
            );
          },
        ),
      ),
    );
  }
}