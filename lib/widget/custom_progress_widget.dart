import 'package:flutter/material.dart';
import 'package:music_palyer/my_colors.dart';
import 'package:music_palyer/widget/custom_button_widget.dart';

class CustomProgressWidget extends StatefulWidget {
  final double value;
  final String lableStart;
  final String lableEnd;

  const CustomProgressWidget({
    Key? key,
    required this.value,
    required this.lableStart,
    required this.lableEnd,
  }) : super(key: key);

  @override
  _CustomProgressWidgetState createState() => _CustomProgressWidgetState();
}

class _CustomProgressWidgetState extends State<CustomProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(widget.lableStart), Text(widget.lableEnd)],
          ),
          _mainProgress(context),
          _progressValue(context),
          _indicatorButton(context),
        ],
      ),
    );
  }

  Widget _indicatorButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width * widget.value,
        child: Row(
          children: [
            const Expanded(child: SizedBox()),
            CustomButtonWidget(
                size: 30,
                child: InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.fiber_manual_record,
                    size: 20,
                    color: AppColor.darkBlue,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _progressValue(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 5,
        width: MediaQuery.of(context).size.width * widget.value,
        decoration: BoxDecoration(
          color: AppColor.lightBlue,
          border: Border.all(
            color: AppColor.styleColor.withAlpha(90),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  Widget _mainProgress(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: AppColor.mainColor,
            border: Border.all(
              color: AppColor.styleColor.withAlpha(90),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: AppColor.styleColor.withAlpha(90),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, -1),
              ),
            ]),
      ),
    );
  }
}
