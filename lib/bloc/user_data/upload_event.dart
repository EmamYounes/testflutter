import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class UploadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PickImageEvent extends UploadEvent {}

class GenerateImageEvent extends UploadEvent {
  final File image;
  final String prompt;

  GenerateImageEvent({
    required this.image,
    required this.prompt,
  });

  @override
  List<Object?> get props => [image, prompt];
}