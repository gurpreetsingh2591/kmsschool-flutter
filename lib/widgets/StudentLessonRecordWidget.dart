import 'package:flutter/material.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';
import '../utils/constant.dart';

class StudentLessonRecordWidget extends StatelessWidget {
  final String lessonPlanId;
  final String classId;
  final String statusEd;
  final String statusPg;
  final String statusPi;
  final String lessonName;
  final String lessonPlaned;
  final dynamic lessonPresented;

  const StudentLessonRecordWidget({
    Key? key,
    required this.lessonPlanId,
    required this.classId,
    required this.lessonName,
    required this.statusEd,
    required this.statusPg,
    required this.statusPi,
    required this.lessonPlaned,
    required this.lessonPresented,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: kMessageItemDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                "Lesson Title: $lessonName",
                textAlign: TextAlign.left,
                style: textStyle(Colors.black87, 14, 0, FontWeight.w500),
              ),
            ),
            5.height,
            Text(
              "Lesson Planned: $lessonPlaned",
              style: textStyle(Colors.black87, 14, 0, FontWeight.w500),
              textAlign: TextAlign.left,
            ),
            5.height,
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Lesson Presented: $lessonPresented",
                style: textStyle(Colors.black87, 14, 0, FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            5.height,
            Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    "Status:",
                    style: textStyle(Colors.black87, 14, 0, FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                  10.width,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: kEDBgDecoration,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ED:$statusEd",
                      style: textStyle(Colors.black87, 14, 0, FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  10.width,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: kPGBgDecoration,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "PG:$statusPg",
                      style: textStyle(Colors.black87, 14, 0, FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  10.width,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: kPIBgDecoration,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "PI:$statusPi",
                      style: textStyle(Colors.black87, 14, 0, FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
