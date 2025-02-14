import "dart:convert";

import "package:faithwave_app/src/features/auth/services/auth_service.dart";
import "package:faithwave_app/src/features/todos/services/todo_service.dart";
import "package:faithwave_app/src/models/errors/todo_error.dart";
import "package:faithwave_app/src/models/todo.dart";
import "package:get_it/get_it.dart";
import "package:oxidized/oxidized.dart";
import "package:shared_preferences/shared_preferences.dart";

class LocalTodoService implements TodoService {
  late SharedPreferences repository;

  LocalTodoService(): repository = GetIt.instance<SharedPreferences>();

  @override
  Future<Result<List<Todo>, TodoError>> fetch() async {
    try {
      final user = GetIt.instance<AuthService>().currentUser;
      final todos = repository
        .getStringList(user.email)
        ?.map((e) => Todo.fromJson(jsonDecode(e)))
        .toList();
      return Ok(todos ?? []);
    } on Exception catch(_) {
      return Err(TodoErrorUnknown());
    }
  }

  @override
  Future<Result<List<Todo>, TodoError>> add({
    required String title, required bool isChecked,
  }) async {
    try {
      final user = GetIt.instance<AuthService>().currentUser;
      final todos = repository
        .getStringList(user.email)
        ?.map((e) => Todo.fromJson(jsonDecode(e)))
        .toList();

      final uuid = DateTime.now().millisecondsSinceEpoch.toString();
      final todo = Todo(
        uuid: uuid,
        title: title,
        isChecked: isChecked,
      );

      var newList = {...todos ?? []};
      newList.add(todo);

      await repository.setStringList(
        user.email,
        newList.map((e) => jsonEncode(e)).toList(),
      );

      return Ok(newList.toList());
    } on Exception catch(_) {
      return Err(TodoErrorUnknown());
    }
  }

  @override
  Future<Result<List<Todo>, TodoError>> toggleComplete({
    required Todo todo,
  }) async {
    try {
      final user = GetIt.instance<AuthService>().currentUser;
      final todos = repository
        .getStringList(user.email)
        ?.map((e) => Todo.fromJson(jsonDecode(e)))
        .toList();

      todos?.removeWhere((t) => t.uuid == todo.uuid);

      var updatedTodo = Todo(
        title: todo.title,
        isChecked: !todo.isChecked,
        uuid: todo.uuid,
      );

      var newList = {...todos ?? []};
      newList.add(updatedTodo);

      await repository.setStringList(
        user.email,
        newList.map((e) => jsonEncode(e)).toList(),
      );

      return Ok(newList.toList());
    } on Exception catch(_) {
      return Err(TodoErrorNotFound());
    }
  }

  @override
  Future<Result<List<Todo>, TodoError>> delete({
    required Todo todo,
  }) async {
    try {
      final user = GetIt.instance<AuthService>().currentUser;
      final todos = repository
        .getStringList(user.email)
        ?.map((e) => Todo.fromJson(jsonDecode(e)))
        .toList();

      todos?.removeWhere((t) => t.uuid == todo.uuid);

      await repository.setStringList(
        user.email,
        todos?.map((e) => jsonEncode(e)).toList() ?? [],
      );
      return Ok(todos ?? []);
    } on Exception catch(_) {
      return Err(TodoErrorUnknown());
    }
  }
}