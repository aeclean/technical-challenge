import "package:faithwave_app/src/features/auth/cubits/auth_cubit.dart";
import "package:faithwave_app/src/router/router.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

   @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Faithwave"),
        centerTitle: true,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().signOut();
              context.go(AppRoute.initial.path);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}