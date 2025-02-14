import "package:faithwave_app/src/features/auth/cubits/auth_cubit.dart";
import "package:faithwave_app/src/features/todos/cubits/todos_cubit.dart";
import "package:faithwave_app/src/models/todo.dart";
import "package:faithwave_app/src/router/router.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
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
        child: BlocBuilder<TodoCubit, TodoState>(
          bloc: context.read<TodoCubit>()..fetchTodos(),
          builder: (context, state) {
            return BlocBuilder<TodoCubit, TodoState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator(),);
                } else {
                  return state.todos.mapOrElse(
                    (results) => Padding(
                      padding: const EdgeInsets.all(22),
                      child: ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) => ListItem(results[index]),
                      ),
                    ),
                    () => const EmptyView(),
                  );
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialogView(context),
        child: const Icon(Icons.add_outlined),
      ),
    );
  }

  void showDialogView(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const Text(
                "Add a Todo",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 22,),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Insert a title",
                ),
              ),
              const Expanded(child: const Center()),
              SizedBox(
                width: double.maxFinite,
                child: OutlinedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      context.read<TodoCubit>().addTodo(
                        title: controller.text,
                        isChecked: false,
                      );
                      context.pop();
                    }
                  },
                  child: const Text("Add"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class ListItem extends StatelessWidget {
  ListItem(this.todo, {super.key});

  Todo todo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(todo.title),
        ),
        Checkbox(
          value: todo.isChecked,
          onChanged: (_) {
            context.read<TodoCubit>().toggleComplete(todo: todo);
          },
        ),
        IconButton(
          onPressed: () => context.read<TodoCubit>().deleteTodo(todo: todo),
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("No data yet."),
    );
  }
}
