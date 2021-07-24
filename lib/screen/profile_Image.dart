import 'package:flutter/material.dart';
import 'dart:io';

class ViewImage extends StatelessWidget {
  final File file;

  const ViewImage({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(
      file,
      height: MediaQuery.of(context).size.height,
    );
  }
}
