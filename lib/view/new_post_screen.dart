// Updated NewPostScreen
import 'dart:typed_data';
import 'package:app/view/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../bloc/new_post/new_post_bloc.dart';
import '../../bloc/new_post/new_post_event.dart';
import '../../bloc/new_post/new_post_state.dart';
import '../../controller/new_post_controller.dart';
import 'dart:io';

class NewPostScreen extends StatelessWidget {
  final NewPostController controller = NewPostController();
  final List<String> filters = [
    'Browse',
    'Filter 1',
    'Filter 2',
    'Filter 3',
    'Filter 4'
  ];

  NewPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewPostBloc()..add(LoadMediaEvent()),
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: BlocBuilder<NewPostBloc, NewPostState>(
            builder: (context, state) {
              return Text('Selected: ${state.selectedFiles.length}');
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final bloc = context.read<NewPostBloc>();
                final state = bloc.state;
                print("DEBUG selectedFiles: ${state.selectedFiles.length}");
                if (state.selectedFiles.isNotEmpty) {
                  List<Uint8List> filteredImages = [];

                  for (var file in state.selectedFiles) {
                    final bytes = await controller.applyFilter(
                      file,
                      state.selectedFilter,
                      state.filterStrength,
                    );
                    if (bytes != null) {
                      filteredImages.add(bytes);
                    }
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PreviewScreen(imageBytes: filteredImages),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select at least one image."),
                    ),
                  );
                }
              },
              child: const Text("Next", style: TextStyle(color: Colors.purple)),
            ),
          ],
        ),
        body: BlocBuilder<NewPostBloc, NewPostState>(
          builder: (context, state) {
            final bloc = context.read<NewPostBloc>();

            return Column(
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: state.selectedFiles.isEmpty
                      ? const Center(child: Text("No Media Selected"))
                      : FutureBuilder<Uint8List>(
                          future: controller.applyFilter(
                            state.selectedFiles.first,
                            state.selectedFilter,
                            state.filterStrength,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Image.memory(snapshot.data!,
                                  fit: BoxFit.cover);
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                ),
                const Divider(),
                _buildFilters(bloc, state),
                _buildSlider(bloc, state),
                const Divider(),
                Expanded(child: _buildMediaGrid(bloc, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilters(NewPostBloc bloc, NewPostState state) {
    final List<Color> filterColors = [
      Colors.grey.shade300,
      Colors.purple.shade100,
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.orange.shade100,
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final name = filters[index];
          final isSelected = state.selectedFilter == name;

          return GestureDetector(
            onTap: () => bloc.add(ChangeFilterEvent(name)),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: filterColors[index],
                border: Border.all(
                  color: isSelected ? Colors.purple : Colors.transparent,
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ]
                    : [],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.image, size: 24),
                    const SizedBox(height: 4),
                    Text(name,
                        style: const TextStyle(fontSize: 10),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlider(NewPostBloc bloc, NewPostState state) {
    return Column(
      children: [
        const Text("Filter Strength"),
        Slider(
          value: state.filterStrength,
          min: 0,
          max: 10,
          divisions: 10,
          onChanged: (val) => bloc.add(ChangeFilterStrengthEvent(val)),
        ),
      ],
    );
  }

  Widget _buildMediaGrid(NewPostBloc bloc, NewPostState state) {
    return GridView.builder(
      itemCount: state.mediaList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        final entity = state.mediaList[index];
        return GestureDetector(
          onLongPress: () => bloc.add(SelectMediaEvent(index)),
          onTap: () => bloc.add(SelectMediaEvent(index)),
          child: FutureBuilder<File?>(
            future: entity.file,
            builder: (context, fileSnapshot) {
              final file = fileSnapshot.data;

              return FutureBuilder<Uint8List?>(
                future:
                    entity.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                builder: (_, snapshot) {
                  final bytes = snapshot.data;
                  if (bytes == null || file == null) return const SizedBox();

                  final isSelected =
                      state.selectedFiles.any((f) => f.path == file.path);
                 // final isSelected = state.selectedFiles.contains(entity);

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(bytes, fit: BoxFit.cover),
                      if (isSelected)
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          child: const Icon(Icons.check_circle,
                              color: Colors.white),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
