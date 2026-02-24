import 'package:equatable/equatable.dart';
import 'dart:typed_data';
import 'dart:io';

abstract class UploadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadInitial extends UploadState {}

class UploadLoading extends UploadState {}

class ImagePickedState extends UploadState {
  final File image;

  ImagePickedState(this.image);

  @override
  List<Object?> get props => [image];
}

class ImageGeneratedState extends UploadState {
  final Uint8List imageBytes;

  ImageGeneratedState(this.imageBytes);

  @override
  List<Object?> get props => [imageBytes];
}

class UploadError extends UploadState {
  final String message;

  UploadError(this.message);

  @override
  List<Object?> get props => [message];
}