import 'dart:io';

import 'package:flutter/material.dart';

class CustomUploadedImageWidget extends StatelessWidget {
  const CustomUploadedImageWidget({
    super.key,
    this.img,
  });
  final File? img;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      img!,
      fit: BoxFit.cover,
    );
  }
}
