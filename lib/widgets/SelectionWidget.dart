import 'package:flutter/material.dart';
import 'package:kmschool/utils/extensions/extensions.dart';
import '../utils/constant.dart';
import 'ButtonWidget.dart';

class SelectionWidget extends StatelessWidget {
  final VoidCallback clickOnLeft;
  final String leftName;
  final String rightName;
  final VoidCallback clickOnRight;
  final bool selection;

  const SelectionWidget({
    Key? key,
    required this.clickOnLeft,
    required this.clickOnRight,
    required this.selection,
    required this.leftName,
    required this.rightName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              flex: 1,
              child: Align(
                  alignment: Alignment.center,
                  child: ButtonWidget(
                    margin: 0,
                    name: leftName,
                    icon: "",
                    visibility: false,
                    padding: 0,
                    onTap: () {
                      clickOnLeft();
                    },
                    size: 12,
                    scale: 2,
                    height: 50,
                    decoration: selection?kSelectedDecoration:kUnSelectedDecoration,
                    textColors: selection?Colors.white:Colors.black,
                    rightVisibility: false,
                    weight: FontWeight.w400,
                    iconColor: Colors.white,
                  )),
            ),
            20.width,
            Flexible(
              flex: 1,
              child: Align(
                  alignment: Alignment.center,
                  child: ButtonWidget(
                    margin: 0,
                    name: rightName,
                    icon: "",
                    visibility: false,
                    padding: 0,
                    onTap: () {
                      clickOnRight();
                    },
                    size: 12,
                    scale: 2,
                    height: 50,
                    decoration: selection?kUnSelectedDecoration:kSelectedDecoration,
                    textColors: selection?Colors.black:Colors.white,
                    rightVisibility: false,
                    weight: FontWeight.w400,
                    iconColor: Colors.red,
                  )),
            ),
          ],
        )
      ],
    );
  }
}
