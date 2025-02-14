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
  Future<Result<Todo, TodoError>> add({
    required String title, required bool isChecked,
  }) async {
    try {
      final uuid = DateTime.now().millisecondsSinceEpoch.toString();
      final todo = Todo(
        uuid: uuid,
        title: title,
        isChecked: isChecked,
      );

      await repository.setString(uuid, todo.toString());

      return Ok(todo);
    } on Exception catch(_) {
      return Err(TodoErrorUnknown());
    }
  }

  @override
  Future<Result<Todo, TodoError>> edit({
    required Todo todo,
  }) async {
    try {
      await repository.setString(
        todo.uuid,
        jsonEncode(todo.toString()),
      );

      return Ok(todo);
    } on Exception catch(_) {
      return Err(TodoErrorNotFound());
    }
  }

  @override
  Future<Result<void, TodoError>> delete({
    required Todo todo,
  }) async {
    try {
      await repository.remove(todo.uuid);
      return const Ok(null);
    } on Exception catch(_) {
      return Err(TodoErrorUnknown());
    }
  }
}