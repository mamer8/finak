import 'dart:io';

import 'package:flutter/material.dart';

class CustomUploadedImageWidget extends StatelessWidget {
  const CustomUploadedImageWidget({
    super.key,
    this.imgPath,
  });
  final String? imgPath;

  @override
  Widget build(BuildContext context) {
    return Image.network(imgPath! ,
    errorBuilder: (context, error, stackTrace) => Image.file(File(imgPath!),
      fit: BoxFit.cover,
    ),
    );
    
    //  Image.file(
    //   img!,
    //   fit: BoxFit.cover,
    // );
  }
}
