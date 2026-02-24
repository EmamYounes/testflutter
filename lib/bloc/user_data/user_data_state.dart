// lib/bloc/user_data/user_data_state.dart
import 'package:equatable/equatable.dart';

class UserDataState extends Equatable {
  final bool loading;
  final String? name;
  final int? age;
  final double? weight;
  final double? height;
  final String? gender;
  final String? error;
  final bool saveSuccess;

  const UserDataState({
    this.loading = false,
    this.name,
    this.age,
    this.weight,
    this.height,
    this.gender,
    this.error,
    this.saveSuccess = false,
  });

  UserDataState copyWith({
    bool? loading,
    String? name,
    int? age,
    double? weight,
    double? height,
    String? gender,
    String? error,
    bool? saveSuccess,
  }) {
    return UserDataState(
      loading: loading ?? this.loading,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      error: error,
      saveSuccess: saveSuccess ?? this.saveSuccess,
    );
  }

  @override
  List<Object?> get props =>
      [loading, name, age, weight, height, gender, error, saveSuccess];
}