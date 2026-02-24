// lib/bloc/user_data/user_data_event.dart
import 'package:equatable/equatable.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserDataEvent extends UserDataEvent {
  const LoadUserDataEvent();
}

class SaveUserDataEvent extends UserDataEvent {
  final String name;
  final int age;
  final double weight;
  final double height;
  final String? gender;

  const SaveUserDataEvent({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
  });

  @override
  List<Object?> get props => [name, age, weight, height, gender];
}