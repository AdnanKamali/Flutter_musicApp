import 'package:flutter/material.dart';

import '../resource/asset_manager.dart';
import '../resource/string_manager.dart';
import 'custom_button_widget.dart';

class ImageMusicShow extends StatelessWidget {
  const ImageMusicShow({
    Key? key,
    required this.imageOfMusic,
    required this.size,
  }) : super(key: key);
  final Image? imageOfMusic;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: StringManager.heroTag,
      child: SizedBox(
        height: size,
        width: size,
        child: imageOfMusic == null
            ? const CustomButtonWidget(
                size: 150,
                borderWidth: 5,
                image: AssetManager.flowerImage,
              )
            : ClipRRect(
                child: imageOfMusic,
                borderRadius: BorderRadius.circular(50),
              ),
      ),
    );
  }
}
