// lib/bloc/user_data/user_data_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_data_event.dart';
import 'user_data_state.dart';
import '../../user_service.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  UserDataBloc() : super(const UserDataState()) {
    on<LoadUserDataEvent>(_onLoadUserData);
    on<SaveUserDataEvent>(_onSaveUserData);
  }

  Future<void> _onLoadUserData(
      LoadUserDataEvent event,
      Emitter<UserDataState> emit,
      ) async {
    emit(state.copyWith(loading: true, error: null, saveSuccess: false));

    try {
      final data = await UserService.loadUserData();

      if (data == null) {
        emit(state.copyWith(loading: false));
        return;
      }

      emit(
        state.copyWith(
          loading: false,
          name: (data['name'] ?? '').toString(),
          age: int.tryParse(data['age']?.toString() ?? ''),
          weight: double.tryParse(data['weight']?.toString() ?? ''),
          height: double.tryParse(data['height']?.toString() ?? ''),
          gender: data['gender'] as String?,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSaveUserData(
      SaveUserDataEvent event,
      Emitter<UserDataState> emit,
      ) async {
    emit(state.copyWith(loading: true, error: null, saveSuccess: false));

    try {
      await UserService.saveUserData(
        name: event.name,
        age: event.age,
        weight: event.weight,
        height: event.height,
        gender: event.gender,
      );

      emit(
        state.copyWith(
          loading: false,
          name: event.name,
          age: event.age,
          weight: event.weight,
          height: event.height,
          gender: event.gender,
          saveSuccess: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: e.toString(),
          saveSuccess: false,
        ),
      );
    }
  }
}