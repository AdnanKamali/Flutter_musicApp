import 'package:flutter/material.dart';
import 'package:music_palyer/model/music_model.dart';
import 'package:music_palyer/my_colors.dart';
import 'package:music_palyer/widget/custom_button_widget.dart';
import 'package:music_palyer/widget/custom_progress_widget.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DetailPage extends StatefulWidget {
  final MusicModle modle;
  const DetailPage({Key? key, required this.modle}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  double value = 0;
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButtonWidget(
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColor.styleColor,
                      ),
                    ),
                  ),
                  const Text(
                    "PLAYING NOW",
                    style: TextStyle(color: AppColor.styleColor),
                  ),
                  CustomButtonWidget(
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.menu,
                        color: AppColor.styleColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Hero(
              tag: "ImageTag",
              child: CustomButtonWidget(
                image: "asset/image/flower.jpg",
                size: 250,
                borderWidth: 5,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            FittedBox(
              child: Text(
                widget.modle.title,
                style:
                    const TextStyle(color: AppColor.styleColor, fontSize: 29),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FittedBox(
              child: Text(
                widget.modle.artist,
                style: TextStyle(
                    color: AppColor.styleColor.withOpacity(0.4), fontSize: 23),
              ),
            ),
            SfSliderTheme(
                data: SfSliderTheme.of(context).copyWith(
                  thumbStrokeWidth: 8,
                  thumbStrokeColor: AppColor.mainColor,
                  activeDividerColor: AppColor.styleColor,
                  inactiveDividerColor: AppColor.styleColor.withAlpha(90),
                  thumbColor: AppColor.darkBlue,
                  thumbRadius: 15,
                ), // pre good library
                child: SfSlider(
                  value: value,
                  onChanged: (v) {
                    setState(() {
                      value = v;
                    });
                  },
                )),
            // Expanded(child: SizedBox()),
            // SfSliderTheme(data: , child: child)
            // Padding(
            //   padding: const EdgeInsets.all(24.0),
            //   child: CustomProgressWidget(
            //     value: 0.7,
            //     lableStart: widget.modle.duration.toString(),
            //     lableEnd: widget.modle.duration.toString(),
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButtonWidget(
                    size: 80,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.skip_previous),
                    ),
                  ),
                  CustomButtonWidget(
                    borderWidth: 0,
                    isOnPressed: true,
                    size: 80,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isPlaying = !isPlaying;
                          isPlaying
                              ? _controller.forward()
                              : _controller.reverse();
                        });
                      },
                      icon: AnimatedIcon(
                        progress: _controller,
                        icon: AnimatedIcons.pause_play,
                        color: isPlaying ? AppColor.styleColor : Colors.white,
                      ),
                    ),
                  ),
                  CustomButtonWidget(
                    size: 80,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.skip_next),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
