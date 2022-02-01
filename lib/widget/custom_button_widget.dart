import 'package:flutter/material.dart';
import 'package:music_palyer/my_colors.dart';

class CustomButtonWidget extends StatelessWidget {
  final double size;
  final String? image;
  final double borderWidth;
  final Widget? child;
  final bool isOnPressed;

  const CustomButtonWidget(
      {Key? key,
      this.child,
      this.size = 50,
      this.image,
      this.borderWidth = 2,
      this.isOnPressed = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(200),
      border: Border.all(width: borderWidth, color: Colors.white),
      boxShadow: const [
        BoxShadow(
          color: AppColor.lightBlueShadow,
          blurRadius: 10,
          offset: Offset(5, 5),
          spreadRadius: 3,
        ),
        BoxShadow(
          color: Colors.white60,
          blurRadius: 5,
          offset: Offset(-5, -5),
          spreadRadius: 3,
        ),
      ],
      gradient: const RadialGradient(
        colors: [
          AppColor.mainColor,
          AppColor.mainColor,
          AppColor.mainColor,
          Colors.white,
        ],
      ),
    );
    if (image != null) {
      boxDecoration = boxDecoration.copyWith(
          image: DecorationImage(
              image: ExactAssetImage(image!), fit: BoxFit.cover));
    }
    if (isOnPressed) {
      boxDecoration = boxDecoration.copyWith(
        gradient: const RadialGradient(
          colors: [
            AppColor.lightBlue,
            AppColor.darkBlue,
          ],
        ),
      );
    } else {
      boxDecoration = boxDecoration.copyWith(
        gradient: const RadialGradient(
          colors: [
            AppColor.mainColor,
            AppColor.mainColor,
            AppColor.mainColor,
            Colors.white,
          ],
        ),
      );
    }
    return Container(
      decoration: boxDecoration,
      child: child,
      height: size,
      width: size,
    );
  }
}
