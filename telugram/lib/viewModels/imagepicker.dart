import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerr {
  Future<File?> uploadImage(String inputSource) async {
    final picker = ImagePicker();
    try {
      final XFile? pickerImage = await picker.pickImage(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
      );
      if (pickerImage != null) {
        return File(pickerImage.path); // Return the file if image is selected
      }
      return null; // Return null if no image is selected
    } catch (e) {
      print('Error picking image: $e');
      return null; // Return null if there's an error during image picking
    }
  }
}
