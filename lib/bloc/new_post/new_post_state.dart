// Updated `NewPostState`
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:photo_manager/photo_manager.dart';

class NewPostState extends Equatable {
  final List<AssetEntity> mediaList;
  final List<File> selectedFiles;
  final String selectedFilter;
  final double filterStrength;
  final bool isLoading;
  final String? errorMessage;

  const NewPostState({
    this.selectedFiles = const [], // fix: default empty list
    this.mediaList = const [],
    this.selectedFilter = 'None',
    this.filterStrength = 1.0,
    this.isLoading = false,
    this.errorMessage,
  });

  NewPostState copyWith({
    List<AssetEntity>? mediaList,
    List<File>? selectedFiles,
    String? selectedFilter,
    double? filterStrength,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NewPostState(
      mediaList: mediaList ?? this.mediaList,
      selectedFiles: selectedFiles ?? this.selectedFiles,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      filterStrength: filterStrength ?? this.filterStrength,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        mediaList,
        selectedFiles,
        selectedFilter,
        filterStrength,
        isLoading,
        errorMessage,
      ];
}
