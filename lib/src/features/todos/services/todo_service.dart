import "package:faithwave_app/src/models/errors/todo_error.dart";
import "package:faithwave_app/src/models/todo.dart";
import "package:oxidized/oxidized.dart";

abstract interface class TodoService {
  Future<Result<List<Todo>, TodoError>> fetch();
  Future<Result<List<Todo>, TodoError>> add({required String title, required bool isChecked});
  Future<Result<List<Todo>, TodoError>> toggleComplete({required Todo todo});
  Future<Result<List<Todo>, TodoError>> delete({required Todo todo});
}