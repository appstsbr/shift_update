import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shift_flutter/src/screens/profile/image_picker_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

/// a class [ImagePickerHandler] e responsavel por captura e cropped de imagens
class ImagePickerHandler {
  ImagePickerDialog? imagePicker;
  AnimationController? _controller;
  bool chat;
  final void Function(dynamic file) updater;

  ImagePickerHandler(this._controller, this.updater, {this.chat = false});

  Future<File> openCamera() async {
    chat ? print("") : imagePicker!.dismissDialog();
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    CroppedFile data = await cropImage(image!);
    File file = File(data.path);
    return file;
  }

  Future<File> openGallery() async {
    chat ? print("") : imagePicker!.dismissDialog();
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    CroppedFile data = await cropImage(image!);
    File file = File(data.path);
    return file;
  }

  void init() {
    imagePicker = new ImagePickerDialog(this, _controller!);
    imagePicker!.initState();
  }

  Future cropImage(XFile? image) async {
    return ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
  }

  showDialog(BuildContext context) {
    imagePicker!.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}
