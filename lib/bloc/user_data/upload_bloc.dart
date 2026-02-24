import 'package:flutter_bloc/flutter_bloc.dart';
import 'upload_event.dart';
import 'upload_state.dart';
import 'package:image_picker/image_picker.dart';
import '../../horde_service.dart';
import 'dart:io';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final ImagePicker picker = ImagePicker();

  UploadBloc() : super(UploadInitial()) {
    on<PickImageEvent>(_onPickImage);
    on<GenerateImageEvent>(_onGenerateImage);
  }

  Future<void> _onPickImage(
      PickImageEvent event, Emitter<UploadState> emit) async {
    try {
      final XFile? picked =
      await picker.pickImage(source: ImageSource.gallery);

      if (picked == null) {
        emit(UploadError("No image selected"));
        return;
      }

      emit(ImagePickedState(File(picked.path)));
    } catch (e) {
      emit(UploadError(e.toString()));
    }
  }

  Future<void> _onGenerateImage(
      GenerateImageEvent event, Emitter<UploadState> emit) async {
    try {
      emit(UploadLoading());

      final imageBytes = await HordeService.edit(
        image: event.image,
        prompt: event.prompt,
      );

      emit(ImageGeneratedState(imageBytes));
    } catch (e) {
      emit(UploadError("Failed: $e"));
    }
  }
}