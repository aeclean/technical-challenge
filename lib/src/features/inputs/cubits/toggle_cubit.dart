import "package:flutter_bloc/flutter_bloc.dart";

class ToggleCubit extends Cubit<bool> {
  ToggleCubit() : super(true);

  void toggle() => emit(!state);
}
