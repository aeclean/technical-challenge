import "package:faithwave_app/src/models/errors/todo_error.dart";
import "package:faithwave_app/src/models/todo.dart";
import "package:oxidized/oxidized.dart";

abstract interface class TodoService {
  Future<Result<List<Todo>, TodoError>> fetch();
  Future<Result<Todo, TodoError>> add({required String title, required bool isChecked});
  Future<Result<Todo, TodoError>> edit({required Todo todo});
  Future<Result<void, TodoError>> delete({required Todo todo});
}