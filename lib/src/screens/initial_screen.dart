import "package:faithwave_app/src/router/router.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              width: double.maxFinite,
              child: Text(
                "Faithwave",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 60,),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: () => context.push(AppRoute.login.path),
                child: const Text("Login"),
              ),
            ),
            const SizedBox(height: 22,),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: () => context.push(AppRoute.register.path),
                child: const Text("Register"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
