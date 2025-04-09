import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'new_post_event.dart';
import 'new_post_state.dart';

class NewPostBloc extends Bloc<NewPostEvent, NewPostState> {
  NewPostBloc() : super(const NewPostState()) {
    on<LoadMediaEvent>(_onLoadMedia);
    on<SelectMediaEvent>(_onSelectMedia);
    on<ChangeFilterEvent>(_onChangeFilter);
    on<ChangeFilterStrengthEvent>(_onChangeStrength);
  }

  Future<void> _onLoadMedia(LoadMediaEvent event, Emitter<NewPostState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await PhotoManager.requestPermissionExtend();
    if (!result.isAuth) {
      emit(state.copyWith(isLoading: false, errorMessage: "Permission denied"));
      return;
    }

    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    final recentAlbum = albums.isNotEmpty ? albums.first : null;

    if (recentAlbum == null) {
      emit(state.copyWith(isLoading: false, errorMessage: "No media found"));
      return;
    }

    final media = await recentAlbum.getAssetListPaged(page: 0, size: 100);
    if (media.isEmpty) {
      emit(state.copyWith(isLoading: false, errorMessage: "No media available"));
      return;
    }

    final firstFile = await media[0].file;
    emit(state.copyWith(
      isLoading: false,
      mediaList: media,
      selectedFiles: firstFile != null ? [firstFile] : [],
    ));
  }

  Future<void> _onSelectMedia(SelectMediaEvent event, Emitter<NewPostState> emit) async {
    final asset = state.mediaList[event.index];
    final file = await asset.file;

    if (file != null) {
      final updatedList = List<File>.from(state.selectedFiles);

      final alreadySelected = updatedList.any((f) => f.path == file.path);
      if (alreadySelected) {
        updatedList.removeWhere((f) => f.path == file.path);
      } else {
        updatedList.add(file);
      }

      emit(state.copyWith(selectedFiles: updatedList));
    }
  }

  void _onChangeFilter(ChangeFilterEvent event, Emitter<NewPostState> emit) {
    emit(state.copyWith(selectedFilter: event.filter));
  }

  void _onChangeStrength(ChangeFilterStrengthEvent event, Emitter<NewPostState> emit) {
    emit(state.copyWith(filterStrength: event.strength));
  }
}
