import "package:equatable/equatable.dart";
import "package:faithwave_app/src/features/auth/services/todo_service.dart";
import "package:faithwave_app/src/models/errors/todo_error.dart";
import "package:faithwave_app/src/models/todo.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:get_it/get_it.dart";
import "package:oxidized/oxidized.dart";

class TodoCubit extends Cubit<TodoState> {
  TodoService todoService = GetIt.I.get<TodoService>();

  TodoCubit() : super(const TodoState());

  Future<void> addTodo({
    required String title,
    required bool isChecked,
  }) async {
    emit(state.toLoading());
    final result = await todoService.add(title: title, isChecked: isChecked);
    final nextState = result.match(
      (todo) => state.copyWith(todo: Some(todo)),
      (error) => state.toError(error),
    );
    emit(nextState);
  }

  Future<void> editTodo({
    required Todo todo,
  }) async {
    emit(state.toLoading());
    final result = await todoService.edit(todo: todo);
    final nextState = result.match(
      (todo) => state.copyWith(todo: Some(todo)),
      (error) => state.toError(error),
    );
    emit(nextState);
  }

  Future<void> deleteTodo({
    required Todo todo,
  }) async {
    emit(state.toLoading());
    final result = await todoService.delete(todo: todo);
    final nextState = result.match(
      (_) => state.copyWith(todo: const None()),
      (error) => state.toError(error),
    );
    emit(nextState);
  }
}

class TodoState extends Equatable {
  final bool isLoading;
  final Option<TodoError> error;
  final Option<Todo> todo;

  const TodoState({
    this.isLoading = false,
    this.error = const None(),
    this.todo = const None(),
  });

  TodoState copyWith({
    bool? isLoading,
    Option<TodoError>? error,
    Option<Todo>? todo,
  }) =>
      TodoState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        todo: todo ?? this.todo,
      );

  TodoState toLoading() => copyWith(
        isLoading: true,
        error: const None(),
      );
  TodoState toError(TodoError error) => copyWith(
        isLoading: false,
        error: Some(error),
      );

  @override
  List<Object?> get props => [];
}