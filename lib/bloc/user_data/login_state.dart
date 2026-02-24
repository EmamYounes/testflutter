import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;
  LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginError extends LoginState {
  final String message;
  LoginError(this.message);

  @override
  List<Object?> get props => [message];
}