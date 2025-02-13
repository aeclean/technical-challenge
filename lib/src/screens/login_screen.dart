import "package:faithwave_app/src/features/auth/cubits/auth_cubit.dart";
import "package:faithwave_app/src/features/inputs/cubits/email_input_state.dart";
import "package:faithwave_app/src/features/inputs/cubits/toggle_cubit.dart";
import "package:faithwave_app/src/router/router.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ToggleCubit>(create: (_) => ToggleCubit(),),
            BlocProvider<EmailInputCubit>(create: (_) => EmailInputCubit(),),
            BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
          ],
          child: BlocBuilder<EmailInputCubit, EmailValidationState>(
            builder: (context, state) => LoginView(),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class LoginView extends StatelessWidget {
  LoginView({super.key});

  late TextEditingController passwordController = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 56,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
                onChanged: (value) => context.read<EmailInputCubit>().onEmailChanged(value),
              ),
            ),
            SizedBox(
              height: 56,
              child: BlocBuilder<ToggleCubit, bool>(
                builder: (context, isObscured) {
                  return TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: GestureDetector(
                        onTap: () => context.read<ToggleCubit>().toggle(),
                        child: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
                      ),
                    ),
                    obscureText: isObscured,
                  );
                },
              ),
            ),
            const SizedBox(height: 22,),
            BlocConsumer<AuthCubit, AuthState>(
              builder: (context, authState) {
                return BlocBuilder<EmailInputCubit, EmailValidationState>(
                  builder: (context, state) {
                    return SizedBox(
                      height: 46,
                      width: double.maxFinite,
                      child: OutlinedButton(
                        onPressed: context.read<EmailInputCubit>().state.isValidEmail ? () {
                          context.read<AuthCubit>().signIn(
                            context.read<EmailInputCubit>().state.email,
                            passwordController.text,
                          );
                        } : null,
                        child: authState.isLoading
                         ? const Center(child: CircularProgressIndicator())
                         : const Text("Login"),
                      ),
                    );
                  },
                );
              },
              listener: (context, state) {
                if (state.hasError) {
                  state.error.when(
                    some: (error) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.message),),
                    ),
                    none: () => null,
                  );
                } else if (state.isAuthenticated) {
                  context.pushReplacement(AppRoute.home.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}