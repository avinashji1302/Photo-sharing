import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PreviewScreen extends StatelessWidget {
  final List<Uint8List> imageBytes;

  const PreviewScreen({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: imageBytes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          return Image.memory(imageBytes[index], fit: BoxFit.cover);
        },
      ),
    );
  }
}
