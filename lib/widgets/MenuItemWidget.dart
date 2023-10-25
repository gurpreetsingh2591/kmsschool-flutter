import 'package:flutter/material.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';
import 'package:kmschool/utils/themes/colors.dart';
import '../utils/constant.dart';

class MenuItemWidget extends StatelessWidget {
  final List<String> monday;
  final List<dynamic> tuesday;
  final List<dynamic> wednesday;
  final List<dynamic> thursday;
  final List<dynamic> friday;
  final List<dynamic> week;
  final int pos;

  const MenuItemWidget({
    Key? key,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.week,
    required this.pos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 50,
              color: appBaseColor,
              alignment: Alignment.center,
              child: Text(
                "Week ${pos + 1}",
                textAlign: TextAlign.center,
                style: textStyle(Colors.white, 14, 0, FontWeight.w400),
              ),
            ),
            10.height,
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 60.0,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.center,
                    color: Colors.black12,
                    child: Text(

                      "Monday",
                      maxLines: 3,
                      style: textStyle(Colors.black87, 12, 0, FontWeight.w400,)
                      ,
                    ),
                  ),
                ),
                10.width,
                Expanded(
                  flex: 8,
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 60.0,

                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.centerLeft,
                    color: Colors.black12,
                    child: Text(
                      monday[pos],
                      style: textStyle(Colors.black87, 12, 0, FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
            10.height,
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 60.0,

                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.center,
                    color: Colors.black12,
                    child: Text(
                      "Tuesday",
                      style: textStyle(Colors.black87, 12, 0, FontWeight.w400),
                    ),
                  ),
                ),
                10.width,
                Expanded(
                  flex: 8,
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 60.0,

                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.centerLeft,
                    color: Colors.black12,
                    child: Text(
                      tuesday[pos],
                      style: textStyle(Colors.black87, 12, 0, FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
            10.height,
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 60.0,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.center,
                    color: Colors.black12,
                    child: Text(
                      "Wednesday",
                      style: textStyle(Colors.black87, 12, 0, FontWeight.w400),
                    ),
                  ),
                ),
                10.width,
                Expanded(
                  flex: 8,
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 60.0,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.centerLeft,
                    color: Colors.black12,
                    child: Text(
                      wednesday[pos],
                      style: textStyle(Colors.black87, 12, 0, FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
            10.height,
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 60.0,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal:4),
                    alignment: Alignment.center,
                    color: Colors.black12,
                    child: Text(
                      "Thursday",
                      style: textStyle(Colors.black87, 12, 0, FontWeight.w400),
                    ),
                  ),
                ),
                10.width,
                Expanded(
                  flex: 8,
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 60.0,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.centerLeft,
                    color: Colors.black12,
                    child: Text(
                      thursday[pos],
                      style: textStyle(Colors.black87, 12, 0, FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
            10.height,
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 60.0,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4),
                      alignment: Alignment.center,
                      color: Colors.black12,
                      child: Text(
                        "Friday",
                        style:
                            textStyle(Colors.black87, 12, 0, FontWeight.w400),
                      ),
                    )),
                10.width,
                Expanded(
                  flex: 8,
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 60.0,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.centerLeft,
                    color: Colors.black12,
                    child: Text(
                      friday[pos],
                      style: textStyle(Colors.black87, 12, 0, FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
            10.height,
          ],
        ));
  }
}
