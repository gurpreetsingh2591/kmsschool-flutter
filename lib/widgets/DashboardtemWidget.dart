import 'package:flutter/material.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';
import '../utils/constant.dart';



class DashboardItemWidget extends StatelessWidget {
  final String name;
  final String image;
  final VoidCallback click;

  const DashboardItemWidget({
    Key? key,
    required this.name,
    required this.image,
    required this.click,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        click();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 15, right: 15),
        decoration: kInnerDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              image,
              scale: 6,
              color: Colors.white,
            ),
            10.height,
            Flexible(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: textStyle(Colors.white, 10, 0, FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
