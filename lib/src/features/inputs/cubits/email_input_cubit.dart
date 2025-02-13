part of "email_input_state.dart";

class EmailInputCubit extends Cubit<EmailValidationState> {
  
  EmailInputCubit() : super(const EmailValidationState());

  void onEmailChanged(String email) {
    emit(state.copyWith(email: email, isValid: EmailValidator.validate(email)));
  }
}