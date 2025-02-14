sealed class TodoError extends Error {
  final String message;

  TodoError(this.message);

  @override
  String toString() {
    return "TodoError: $message";
  }
}

final class TodoErrorUnknown extends TodoError {
  TodoErrorUnknown() : super("Unknown error");
}

final class TodoErrorInvalidUser extends TodoError {
  TodoErrorInvalidUser() : super("User invalid");
}

final class TodoErrorNotFound extends TodoError {
  TodoErrorNotFound() : super("Todo not found");
}