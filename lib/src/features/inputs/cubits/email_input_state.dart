import "package:email_validator/email_validator.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

part "email_input_cubit.dart";

class EmailValidationState extends Equatable {

  final String email;
  final bool isValidEmail;

  const EmailValidationState({
    this.email = "",
    this.isValidEmail = false,
  });

  EmailValidationState copyWith({
    String? email,
    bool? isValid,
  }) {
    return EmailValidationState(
      email: email ?? this.email,
      isValidEmail: isValid ?? isValidEmail,
    );
  }

  @override
  List<Object?> get props => [
    email,
    isValidEmail,
  ];

}