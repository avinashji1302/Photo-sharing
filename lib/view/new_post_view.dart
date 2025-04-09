// import 'package:app/view/media_grid.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:photo_manager/photo_manager.dart';
// import '../../bloc/new_post/new_post_bloc.dart';
// import '../../bloc/new_post/new_post_event.dart';
// import '../../bloc/new_post/new_post_state.dart';

// class NewPostView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Create Post')),
//       body: BlocBuilder<NewPostBloc, NewPostState>(
//         builder: (context, state) {
//           if (state.isLoading) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (state.errorMessage != null) {
//             return Center(child: Text(state.errorMessage!));
//           }

//           if (state.mediaList.isEmpty) {
//             return Center(child: Text('No media available.'));
//           }

//           return MediaGrid(mediaList: state.mediaList);
//         },
//       ),
//     );
//   }
// }
