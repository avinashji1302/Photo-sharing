import 'dart:typed_data';
import 'dart:io';
import 'package:image/image.dart' as img;

class NewPostController {
  Future<Uint8List> applyFilter(File file, String filter, double strength) async {
    final originalBytes = await file.readAsBytes();
    final image = img.decodeImage(originalBytes);

    if (image == null || filter == 'Browse') return originalBytes;

    switch (filter) {
      case 'Brighten':
        img.adjustColor(image, brightness: 0.1 * strength);
        break;
      case 'Darken':
        img.adjustColor(image, brightness: -0.1 * strength);
        break;
      case 'Gray':
        img.grayscale(image);
        break;
      case 'Sepia':
        img.sepia(image);
        break;
    }

    return Uint8List.fromList(img.encodeJpg(image));
  }
}
