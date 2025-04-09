import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/new_post/new_post_bloc.dart';
import '../bloc/new_post/new_post_event.dart';

class MediaGrid extends StatelessWidget {
  final List<AssetEntity> mediaList;

  const MediaGrid({super.key, required this.mediaList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: mediaList.length,
      itemBuilder: (context, index) {
        final media = mediaList[index];
        return FutureBuilder(
          future: media.thumbnailDataWithSize(ThumbnailSize(200, 200)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return GestureDetector(
                onTap: () {
                  context.read<NewPostBloc>().add(SelectMediaEvent(index));
                },
                child: Image.memory(snapshot.data!, fit: BoxFit.cover),
              );
            } else {
              return Container(color: Colors.grey[300]);
            }
          },
        );
      },
    );
  }
}
